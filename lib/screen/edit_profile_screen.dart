import 'package:flutter/material.dart';

import '../domain/location.dart';
import '../domain/user_crew_member.dart';
import '../service/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final UserCrewMember user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _interestsController;

  String _gender = 'other';
  String _birthdayGroup = '2000s';
  List<String> _languages = ['English'];
  Location? _currentLocation;
  Location? _homeBase;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _usernameController = TextEditingController(text: user.username);
    _bioController = TextEditingController(text: user.bio ?? '');
    _interestsController = TextEditingController(text: user.interests?.join(', ') ?? '');
    _gender = user.gender;
    _birthdayGroup = user.birthdayGroup;
    _languages = user.languages;
    _currentLocation = user.currentLocation;
    _homeBase = user.homeBase;
  }

  Future<void> _saveProfile() async {
    final updatedUser = widget.user.copyWith(
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      interests: _interestsController.text.split(',').map((e) => e.trim()).toList(),
      gender: _gender,
      birthdayGroup: _birthdayGroup,
      languages: _languages,
      currentLocation: _currentLocation,
      homeBase: _homeBase,
    );

    await UserService().saveUser(updatedUser);
    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: _bioController, decoration: const InputDecoration(labelText: 'Bio')),
            TextField(controller: _interestsController, decoration: const InputDecoration(labelText: 'Interests (comma-separated)')),

            DropdownButtonFormField<String>(
              value: _gender,
              items: ['male', 'female'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (val) => setState(() => _gender = val!),
              decoration: const InputDecoration(labelText: 'Gender'),
            ),

            DropdownButtonFormField<String>(
              value: _birthdayGroup,
              items: ['2000s', '90s', '80s', '70s'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
              onChanged: (val) => setState(() => _birthdayGroup = val!),
              decoration: const InputDecoration(labelText: 'Birthday Group'),
            ),

            // Languages dropdown (multi-select can be added later)
            DropdownButtonFormField<String>(
              value: _languages.first,
              items: ['English', 'Spanish', 'French', 'German'].map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
              onChanged: (val) => setState(() => _languages = [val!]),
              decoration: const InputDecoration(labelText: 'Language'),
            ),

            const SizedBox(height: 16),
            Text('Current Location: ${_currentLocation?.label ?? "Not set"}'),
            ElevatedButton(
              onPressed: () async {
                final location = await LocationService().getCurrentLocation();
                setState(() => _currentLocation = location);
              },
              child: const Text('Use Current Location'),
            ),

            const SizedBox(height: 16),
            Text('Home Base: ${_homeBase?.label ?? "Not set"}'),
            ElevatedButton(
              onPressed: () async {
                // TODO: Show country → city picker
              },
              child: const Text('Select Home Base'),
            ),

            const SizedBox(height: 16),
            Text('Joined On: ${widget.user.joinedOn.toLocal().toString().split(" ").first}'),
            Text('Last Active: ${widget.user.lastActive.toLocal().toString().split(" ").first}'),
          ],
        ),
      ),
    );
  }
}