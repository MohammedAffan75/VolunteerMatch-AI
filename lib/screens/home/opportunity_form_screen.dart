import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteer_match_ai/models/opportunity_model.dart';
import 'package:volunteer_match_ai/services/auth_service.dart';
import 'package:volunteer_match_ai/services/opportunity_service.dart';

class OpportunityFormScreen extends StatefulWidget {
  const OpportunityFormScreen({super.key});

  @override
  State<OpportunityFormScreen> createState() => _OpportunityFormScreenState();
}

class _OpportunityFormScreenState extends State<OpportunityFormScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _skills = TextEditingController(text: 'teaching,first aid');
  final _cause = TextEditingController(text: 'rural literacy');
  final _lat = TextEditingController(text: '12.9716');
  final _lng = TextEditingController(text: '77.5946');
  final _needed = TextEditingController(text: '10');
  DateTime _dateTime = DateTime.now().add(const Duration(days: 2));

  Future<void> _submit() async {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return;
    final model = OpportunityModel(
      id: const Uuid().v4(),
      title: _title.text.trim(),
      description: _description.text.trim(),
      requiredSkills: _skills.text.split(',').map((e) => e.trim()).toList(),
      cause: _cause.text.trim(),
      latitude: double.tryParse(_lat.text) ?? 0,
      longitude: double.tryParse(_lng.text) ?? 0,
      dateTime: _dateTime,
      numberNeeded: int.tryParse(_needed.text) ?? 1,
      postedBy: uid,
    );
    await OpportunityService.createOpportunity(model);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post opportunity')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 10),
          TextField(
            controller: _description,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 10),
          TextField(controller: _skills, decoration: const InputDecoration(labelText: 'Required skills')),
          const SizedBox(height: 10),
          TextField(controller: _cause, decoration: const InputDecoration(labelText: 'Cause')),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: TextField(controller: _lat, decoration: const InputDecoration(labelText: 'Lat'))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: _lng, decoration: const InputDecoration(labelText: 'Lng'))),
            ],
          ),
          const SizedBox(height: 10),
          TextField(controller: _needed, decoration: const InputDecoration(labelText: 'Volunteers needed')),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDate: _dateTime,
              );
              if (date != null) setState(() => _dateTime = date);
            },
            child: Text('Date: ${_dateTime.toLocal()}'),
          ),
          const SizedBox(height: 18),
          FilledButton(onPressed: _submit, child: const Text('Publish')),
        ],
      ),
    );
  }
}
