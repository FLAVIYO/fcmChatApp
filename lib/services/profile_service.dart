import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcmchatapp/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fcmchatapp/models/user_profile.dart';
import 'dart:io';

import 'package:get_it/get_it.dart';

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
    final AppLogger _logger = GetIt.instance<AppLogger>();
    final user = auth.currentUser;

    if (user == null) {
      _logger.error(
        'Upload failed: No authenticated user',
        Exception('No authenticated user'),
        StackTrace.current,
      );
      throw Exception('User not authenticated');
    }

    _logger.debug('Starting profile photo upload for user: ${user.uid}');
    _logger.debug('Received file type: ${imageFile.runtimeType}');
    _logger.debug('File path: ${imageFile.path}');
    _logger.debug('File exists: ${await imageFile.exists()}');

    if (!await imageFile.exists()) {
      _logger.error(
        'Upload failed: File does not exist',
        Exception('File not found at path: ${imageFile.path}'),
        StackTrace.current,
      );
      throw Exception('Selected file does not exist');
    }

    try {
      // Get the extension (fallback to jpg if not found)
      final parts = imageFile.path.split('.');
      final extension = parts.isNotEmpty ? parts.last : 'jpg';
      _logger.debug('Using file extension: $extension');

      // Build reference
      final ref = storage.ref().child('profile_photos/${user.uid}.$extension');
      _logger.debug('Firebase Storage full path: ${ref.fullPath}');

      // Start the upload
      _logger.debug('Uploading to Firebase...');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      _logger.debug('Upload task complete. Snapshot state: ${snapshot.state}');

      // Ensure Firebase registers the new file
      await ref.getMetadata();

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();
      _logger.debug('Download URL retrieved: $downloadUrl');

      return downloadUrl;
    } catch (e, stackTrace) {
      _logger.error(
        'Profile photo upload failed',
        e,
        stackTrace,
        extras: {'user_id': user.uid, 'file_path': imageFile.path},
      );
      rethrow;
    }
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
