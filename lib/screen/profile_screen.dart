import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/auth_service.dart';
import '../service/image_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _selectedImage;
  final ImageService _imageService = ImageService();

  Future<void> _pickImage(bool fromCamera) async {
    final image = fromCamera
        ? await _imageService.takePhoto()
        : await _imageService.pickImageFromGallery();

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _uploadImage(String type) async {
    final email = await AuthService().getEmail();
    final userId = email ?? 'unknown_user';
    if (_selectedImage != null) {
      final url = await _imageService.uploadImage(_selectedImage!, userId, type);
      if (url != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$type image uploaded')),
        );
        // TODO: Save URL to Firestore or update user model
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Profile Page", style: TextStyle(fontSize: 24, color: Colors.green)),
        CircleAvatar(
          radius: 100,
          backgroundImage: _selectedImage != null
              ? FileImage(_selectedImage!)
              : const NetworkImage("https://avatar.iran.liara.run/public") as ImageProvider,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () => _pickImage(true),
            ),
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: () => _pickImage(false),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _uploadImage('profile'),
              child: const Text('Save as Profile'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _uploadImage('background'),
              child: const Text('Save as Background'),
            ),
          ],
        ),
      ],
    );
  }
}