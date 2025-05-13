import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fcmchatapp/utils/app_logger.dart';
import 'package:fcmchatapp/utils/toast_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fcmchatapp/models/user_profile.dart';
import 'package:fcmchatapp/services/profile_service.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({this.userId, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile> _profileFuture;
  final ProfileService _profileService = GetIt.instance<ProfileService>();
  final ImagePicker _picker = ImagePicker();
  final AppToasts _toasts = GetIt.instance<AppToasts>();
  final AppLogger _logger = GetIt.instance<AppLogger>();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    setState(() {
      _profileFuture =
          widget.userId != null
              ? _profileService.getUserProfile(widget.userId!)
              : _profileService.getCurrentUserProfile();
    });
  }

  Future<void> _updateProfilePhoto() async {
    try {
      _logger.debug('Starting image picker process...');
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        _logger.debug('User cancelled image selection');
        return;
      }

      _logger.debug('Picked file type: ${pickedFile.runtimeType}');
      _logger.debug('Picked file path: ${pickedFile.path}');

      setState(() => _isUploading = true);

      // Conversion step
      _logger.debug('Attempting XFile to File conversion...');
      final File imageFile = File(pickedFile.path);
      _logger.debug('Converted file type: ${imageFile.runtimeType}');
      _logger.debug('File exists: ${await imageFile.exists()}');

      // Compression step
      _logger.debug('Starting image compression...');
      final File compressedFile = await _compressImage(imageFile);
      _logger.debug('Compressed file type: ${compressedFile.runtimeType}');
      _logger.debug('Compressed file exists: ${await compressedFile.exists()}');
      _logger.debug(
        'Compressed file size: ${await compressedFile.length()} bytes',
      );

      final profile = await _profileFuture;
      _logger.debug('User profile loaded: ${profile.uid}');

      _logger.debug('Starting profile photo upload...');
      final photoUrl = await _profileService.uploadProfilePhoto(compressedFile);
      _logger.debug('Upload completed. Photo URL: $photoUrl');

      await _profileService.validateAndUpdateProfile(
        userId: profile.uid,
        photoUrl: photoUrl,
      );

      _logger.debug('Profile update successful');
      _loadProfile();
    } catch (e, stackTrace) {
      _logger.error(
        'Photo update failed :${e.toString()} ', e, stackTrace,
        extras: {
          'error_type': e.runtimeType.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      if (mounted) {
        _toasts.showError(
          context: context,
          message: 'Photo update failed: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<File> _compressImage(File file) async {
    _logger.debug('Starting image compression...');
    _logger.debug('Input file: ${file.path}');
    _logger.debug('Input file size: ${await file.length()} bytes');

    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${file.path}_compressed.jpg',
        quality: 80,
        minWidth: 600,
        minHeight: 600,
      );

      if (result == null) {
        _logger.warning('Compression returned null, using original file');
        return file;
      }

      _logger.debug('Compression successful. Output path: ${result.path}');
      final compressedFile = File(result.path);
      _logger.debug(
        'Compressed file size: ${await compressedFile.length()} bytes',
      );

      return compressedFile;
    } catch (e, stackTrace) {
      _logger.error(
        'Image compression failed', e, stackTrace,
      );
      return file; // Fallback to original
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions:
            widget.userId == null
                ? [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed:
                        () async =>
                            _showEditDialog(context, (await _profileFuture)),
                  ),
                ]
                : null,
      ),
      body: FutureBuilder<UserProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              _isUploading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Profile not found'));
          }

          final profile = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileAvatar(profile),
                const SizedBox(height: 24),
                _buildProfileInfo(profile),
                if (widget.userId == null) ...[
                  const SizedBox(height: 32),
                  _buildEditButton(context, profile),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(UserProfile profile) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: ClipOval(
            child:
                profile.photoUrl != null
                    ? CachedNetworkImage(
                      imageUrl: profile.photoUrl!,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => _buildDefaultAvatar(),
                    )
                    : _buildDefaultAvatar(),
          ),
        ),
        if (widget.userId == null)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _updateProfilePhoto,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.background,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.person,
          size: 60,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildProfileInfo(UserProfile profile) {
    return Column(
      children: [
        Text(
          profile.displayName ?? 'No name',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          profile.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              profile.bio!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEditButton(BuildContext context, UserProfile profile) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profile'),
        onPressed: () => _showEditDialog(context, profile),
      ),
    );
  }

  void _showEditDialog(BuildContext context, UserProfile profile) {
    final nameController = TextEditingController(text: profile.displayName);
    final bioController = TextEditingController(text: profile.bio);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Profile'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a display name';
                      }
                      if (value.length > 30) {
                        return 'Name too long (max 30 chars)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    maxLength: 150,
                    validator: (value) {
                      if (value != null && value.length > 150) {
                        return 'Bio too long (max 150 chars)';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      await _profileService.validateAndUpdateProfile(
                        userId: profile.uid,
                        displayName: nameController.text.trim(),
                        bio: bioController.text.trim(),
                      );
                      if (mounted) {
                        _loadProfile();
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (mounted) {
                        _logger.error('Profile update failed', e, StackTrace.current);
                      }
                    }
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
    );
  }
}
