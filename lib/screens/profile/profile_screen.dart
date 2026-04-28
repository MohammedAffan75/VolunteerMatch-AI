import 'package:flutter/material.dart';
import 'package:volunteer_match_ai/models/user_model.dart';
import 'package:volunteer_match_ai/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _name = TextEditingController();
  final _skills = TextEditingController();
  UserModel? _user;

  Future<void> _load() async {
    final u = await AuthService.getCurrentProfile();
    if (u == null) return;
    setState(() {
      _user = u;
      _name.text = u.name;
      _skills.text = u.skills.join(', ');
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _save() async {
    if (_user == null) return;
    final updated = UserModel(
      uid: _user!.uid,
      role: _user!.role,
      name: _name.text.trim(),
      email: _user!.email,
      skills: _skills.text.split(',').map((e) => e.trim()).toList(),
      availability: _user!.availability,
      latitude: _user!.latitude,
      longitude: _user!.longitude,
      preferredCauses: _user!.preferredCauses,
      points: _user!.points,
      badges: _user!.badges,
      totalHours: _user!.totalHours,
    );
    await AuthService.updateProfile(updated);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(onPressed: () => AuthService.signOut().then((_) => Navigator.pushReplacementNamed(context, '/login')), icon: const Icon(Icons.logout)),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
                const SizedBox(height: 12),
                TextField(controller: _skills, decoration: const InputDecoration(labelText: 'Skills')),
                const SizedBox(height: 20),
                FilledButton(onPressed: _save, child: const Text('Save changes')),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/chats'),
                  child: const Text('Open chats'),
                ),
              ],
            ),
    );
  }
}
