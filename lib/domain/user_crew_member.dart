import 'location.dart';

class UserCrewMember {
  final String email;
  final String username;

  final String? bio;
  final List<String>? interests;
  final String? profilePhotoUrl;
  final String? backgroundPhotoUrl;

  final String gender; // e.g. 'male', 'female'
  final String birthdayGroup; // e.g. '2000s', '90s', '80s'

  final List<String> languages;

  final Location? currentLocation;
  final Location? homeBase;

  final DateTime joinedOn;
  final bool isOnline;
  final DateTime lastActive;

  UserCrewMember({
    required this.email,
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

  UserCrewMember copyWith({
    String? email,
    String? username,
    String? bio,
    List<String>? interests,
    String? profilePhotoUrl,
    String? backgroundPhotoUrl,
    String? gender,
    String? birthdayGroup,
    List<String>? languages,
    Location? currentLocation,
    Location? homeBase,
    DateTime? joinedOn,
    bool? isOnline,
    DateTime? lastActive,
  }) {
    return UserCrewMember(
      email: email ?? this.email,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      backgroundPhotoUrl: backgroundPhotoUrl ?? this.backgroundPhotoUrl,
      gender: gender ?? this.gender,
      birthdayGroup: birthdayGroup ?? this.birthdayGroup,
      languages: languages ?? this.languages,
      currentLocation: currentLocation ?? this.currentLocation,
      homeBase: homeBase ?? this.homeBase,
      joinedOn: joinedOn ?? this.joinedOn,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}