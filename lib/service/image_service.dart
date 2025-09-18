import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  Future<File?> takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    return image != null ? File(image.path) : null;
  }

  Future<String?> uploadImage(File imageFile, String userId, String type) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('users/$userId/$type.jpg'); // type = 'profile' or 'background'
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}