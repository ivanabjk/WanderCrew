import 'location.dart';

class User {
  final String id;
  final String email;
  final String password;
  final String username;

  final String? bio;
  final List<String>? interests;
  final String? profilePhotoUrl;
  final String? backgroundPhotoUrl;

  final String gender; // e.g. 'male', 'female', 'non-binary', 'other'
  final String birthdayGroup; // e.g. '2000s', '90s', '80s'

  final List<String> languages;

  final Location? currentLocation;
  final Location? homeBase;

  final DateTime joinedOn;
  final bool isOnline;
  final DateTime lastActive;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.username,
    this.bio,
    this.interests,
    this.profilePhotoUrl,
    this.backgroundPhotoUrl,
    required this.gender,
    required this.birthdayGroup,
    required this.languages,
    this.currentLocation,
    this.homeBase,
    required this.joinedOn,
    required this.isOnline,
    required this.lastActive,
  });
}