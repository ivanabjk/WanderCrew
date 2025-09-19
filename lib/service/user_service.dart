import "package:cloud_firestore/cloud_firestore.dart";
import "../domain/location.dart";
import "../domain/user_crew_member.dart";


class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(UserCrewMember user) async {
    try {
      await _firestore.collection('users').doc(user.email).set({
        'email': user.email,
        'username': user.username,
        'bio': user.bio,
        'interests': user.interests,
        'profilePhotoUrl': user.profilePhotoUrl,
        'backgroundPhotoUrl': user.backgroundPhotoUrl,
        'gender': user.gender,
        'birthdayGroup': user.birthdayGroup,
        'languages': user.languages,
        'joinedOn': user.joinedOn.toIso8601String(),
        'isOnline': user.isOnline,
        'lastActive': user.lastActive.toIso8601String(),
        'currentLocation': user.currentLocation?.toMap(),
        'homeBase': user.homeBase?.toMap(),
      });
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  Future<UserCrewMember?> getUserByEmail(String email) async {
    try {
      final doc = await _firestore.collection('users').doc(email).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      return UserCrewMember(
        email: data['email'],
        username: data['username'],
        bio: data['bio'],
        interests: List<String>.from(data['interests'] ?? []),
        profilePhotoUrl: data['profilePhotoUrl'],
        backgroundPhotoUrl: data['backgroundPhotoUrl'],
        gender: data['gender'],
        birthdayGroup: data['birthdayGroup'],
        languages: List<String>.from(data['languages']),
        joinedOn: DateTime.parse(data['joinedOn']),
        isOnline: data['isOnline'],
        lastActive: DateTime.parse(data['lastActive']),
        currentLocation: data['currentLocation'] != null
            ? Location.fromMap(data['currentLocation'])
            : null,
        homeBase: data['homeBase'] != null
            ? Location.fromMap(data['homeBase'])
            : null,
      );
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  UserCrewMember createDefaultUser({
    required String uid,
    required String email,
  }) {
    return UserCrewMember(
      email: email,
      username: email.split('@')[0],
      bio: null,
      interests: [],
      profilePhotoUrl: null,
      backgroundPhotoUrl: null,
      gender: 'other',
      birthdayGroup: '2000s',
      languages: ['English'],
      currentLocation: null,
      homeBase: null,
      joinedOn: DateTime.now(),
      isOnline: true,
      lastActive: DateTime.now(),
    );
  }

}