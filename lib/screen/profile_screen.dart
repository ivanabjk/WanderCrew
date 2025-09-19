import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wander_crew/service/shared_pref.dart';
import 'package:wander_crew/service/user_service.dart';
import 'package:wander_crew/domain/user_crew_member.dart';

import '../service/auth_service.dart';
import '../service/profile_service.dart';

final ProfileService _profileService = ProfileService();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  UserCrewMember? _user;
  bool _loading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUser();
  }

  Future<void> _loadUser() async {
    final email = await SharedPref.instance.getEmail();
    if (email != null) {
      final user = await UserService().getUserByEmail(email);
      setState(() {
        _user = user;
        _loading = false;
      });
    }
  }

  Future<void> _handlePhotoUpdate(String type) async {
    if (_user == null) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Choose from gallery'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a photo'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
        ],
      ),
    );

    if (source == null) return;

    final updatedUser = await _profileService.updatePhoto(
      type: type,
      user: _user!,
      source: source,
    );

    if (updatedUser != null) {
      setState(() => _user = updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return const Scaffold(
        body: Center(child: Text('User not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black,),
            onPressed: () {
              AuthService().logout(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 240, // enough to include the overflowed avatar
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Background image
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: _user!.backgroundPhotoUrl != null
                        ? DecorationImage(
                      image: NetworkImage(_user!.backgroundPhotoUrl!),
                      fit: BoxFit.cover,
                    )
                        : const DecorationImage(
                      image: AssetImage("assets/default_avatar.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Background camera icon
                Positioned(
                  top: 12,
                  left: 12,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.black),
                    onPressed: () => _handlePhotoUpdate('background'),
                  ),
                ),

                // Profile picture with camera icon
                Positioned(
                  bottom: 0,
                  left: MediaQuery.of(context).size.width / 2 - 70,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 66,
                          backgroundImage: _user!.profilePhotoUrl != null
                              ? NetworkImage(_user!.profilePhotoUrl!)
                              : const AssetImage("assets/default_avatar.png") as ImageProvider,
                        ),
                      ),
                      Material(
                        color: Colors.deepPurple,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => _handlePhotoUpdate('profile'),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _user!.username,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.verified, color: Colors.blueAccent, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.deepPurple,
            tabs: const [
              Tab(text: 'About'),
              Tab(text: 'Explored'),
              Tab(text: 'Trips'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gender: ${_user!.gender}'),
                          Text('Birthday Group: ${_user!.birthdayGroup}'),
                          Text('Languages: ${_user!.languages.join(", ")}'),
                          Text('Interests: ${_user!.interests?.join(", ") ?? "None"}'),
                          Text('Bio: ${_user!.bio}'),
                          Text('Home Base: ${_user!.homeBase?.label ?? "Not set"}'),
                          Text('Current Location: ${_user!.currentLocation?.label ?? "Not set"}'),
                          Text('Joined On: ${_user!.joinedOn.toLocal().toString().split(" ").first}'),
                          Text('Last Active: ${_user!.lastActive.toLocal().toString().split(" ").first}'),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.deepPurple),
                          onPressed: () {
                            // TODO: Navigate to edit screen
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Center(child: Text('Explored content goes here')),
                const Center(child: Text('Trips content goes here')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}