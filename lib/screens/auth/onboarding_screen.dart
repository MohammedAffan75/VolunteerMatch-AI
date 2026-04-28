import 'package:flutter/material.dart';
import 'package:volunteer_match_ai/models/user_model.dart';
import 'package:volunteer_match_ai/services/auth_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _skills = TextEditingController(text: 'teaching,first aid');
  final _causes = TextEditingController(text: 'rural literacy,health camps');
  final _availability = TextEditingController(text: 'weekends,evenings');
  final _lat = TextEditingController(text: '12.9716');
  final _lng = TextEditingController(text: '77.5946');
  bool _loading = false;

  Future<void> _save() async {
    setState(() => _loading = true);
    try {
      final current = await AuthService.getCurrentProfile();
      if (current == null) return;
      final updated = UserModel(
        uid: current.uid,
        role: current.role,
        name: current.name,
        email: current.email,
        skills: _skills.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        preferredCauses: _causes.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        availability: _availability.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        latitude: double.tryParse(_lat.text) ?? 0,
        longitude: double.tryParse(_lng.text) ?? 0,
        points: current.points,
        badges: current.badges,
        totalHours: current.totalHours,
      );
      await AuthService.updateProfile(updated);
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick onboarding')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(controller: _skills, decoration: const InputDecoration(labelText: 'Skills (comma-separated)')),
          const SizedBox(height: 12),
          TextField(controller: _causes, decoration: const InputDecoration(labelText: 'Preferred causes')),
          const SizedBox(height: 12),
          TextField(controller: _availability, decoration: const InputDecoration(labelText: 'Availability')),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: TextField(controller: _lat, decoration: const InputDecoration(labelText: 'Latitude'))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: _lng, decoration: const InputDecoration(labelText: 'Longitude'))),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _loading ? null : _save,
            child: _loading ? const CircularProgressIndicator() : const Text('Complete setup'),
          ),
        ],
      ),
    );
  }
}
