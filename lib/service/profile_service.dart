import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wander_crew/service/image_service.dart';
import 'package:wander_crew/service/shared_pref.dart';
import 'package:wander_crew/service/user_service.dart';
import 'package:wander_crew/domain/user_crew_member.dart';

class ProfileService {
  final ImageService _imageService = ImageService();
  final UserService _userService = UserService();

  Future<UserCrewMember?> updatePhoto({
    required String type, // 'profile' or 'background'
    required UserCrewMember user,
    required ImageSource source,
  }) async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return null;

    final File? imageFile = source == ImageSource.gallery
        ? await _imageService.pickImageFromGallery()
        : await _imageService.takePhoto();

    if (imageFile == null) return null;

    final downloadUrl = await _imageService.uploadImage(imageFile, email, type);
    if (downloadUrl == null) return null;

    final updatedUser = user.copyWith(
      profilePhotoUrl: type == 'profile' ? downloadUrl : user.profilePhotoUrl,
      backgroundPhotoUrl: type == 'background' ? downloadUrl : user.backgroundPhotoUrl,
    );

    print("Firestore doc ID: ${updatedUser.email}");
    print("Auth email: ${FirebaseAuth.instance.currentUser?.email}");
    print("SharedPref email: ${await SharedPref.instance.getEmail()}");

    await _userService.saveUser(updatedUser);
    return updatedUser;
  }
}