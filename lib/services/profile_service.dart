import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fcmchatapp/models/user_profile.dart';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ProfileService {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final FirebaseAuth auth;

  ProfileService({
    required this.firestore,
    required this.storage,
    required this.auth,
  });

  Future<UserProfile> getCurrentUserProfile() async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return getUserProfile(user.uid);
  }

  Future<UserProfile> getUserProfile(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    if (!doc.exists) throw Exception('User not found');
    return UserProfile.fromFirestore(doc);
  }

  Future<String> uploadProfilePhoto(File imageFile) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Compress image before upload
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      '${imageFile.path}_compressed.jpg',
      quality: 80, // 80% quality
      minWidth: 600,
      minHeight: 600,
    );

    final extension = imageFile.path.split('.').last;
    final ref = storage
        .ref()
        .child('profile_photos')
        .child('${user.uid}.$extension');

    await ref.putFile(compressedFile as File? ?? imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> validateAndUpdateProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
    String? bio,
  }) async {
    // Validation
    if (displayName != null && displayName.isEmpty) {
      throw ArgumentError('Display name cannot be empty');
    }
    if (bio != null && bio.length > 150) {
      throw ArgumentError('Bio must be less than 150 characters');
    }

    await updateProfile(
      userId: userId,
      displayName: displayName,
      photoUrl: photoUrl,
      bio: bio,
    );
  }

  Future<void> updateProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
    String? bio,
  }) async {
    final updates = <String, dynamic>{};
    if (displayName != null) updates['displayName'] = displayName;
    if (photoUrl != null) updates['photoUrl'] = photoUrl;
    if (bio != null) updates['bio'] = bio;

    await firestore.collection('users').doc(userId).update(updates);

    if (displayName != null) {
      await auth.currentUser?.updateDisplayName(displayName);
    }
  }

  Stream<UserProfile> profileChanges(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => UserProfile.fromFirestore(doc));
  }
}
