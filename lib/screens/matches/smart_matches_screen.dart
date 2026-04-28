import 'package:flutter/material.dart';
import 'package:volunteer_match_ai/models/match_model.dart';
import 'package:volunteer_match_ai/models/opportunity_model.dart';
import 'package:volunteer_match_ai/models/user_model.dart';
import 'package:volunteer_match_ai/services/auth_service.dart';
import 'package:volunteer_match_ai/services/gemini_matching_service.dart';
import 'package:volunteer_match_ai/services/opportunity_service.dart';

class SmartMatchesScreen extends StatefulWidget {
  const SmartMatchesScreen({super.key});

  @override
  State<SmartMatchesScreen> createState() => _SmartMatchesScreenState();
}

class _SmartMatchesScreenState extends State<SmartMatchesScreen> {
  List<MatchModel> _matches = [];
  bool _loading = false;

  Future<void> _runMatching() async {
    setState(() => _loading = true);
    final user = await AuthService.getCurrentProfile();
    if (user == null) return;
    final opportunities = await OpportunityService.streamOpenOpportunities().first;
    final out = <MatchModel>[];
    for (final o in opportunities) {
      out.add(await GeminiMatchingService.instance.generateMatch(volunteer: user, opportunity: o));
    }
    out.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    if (mounted) {
      setState(() {
        _matches = out;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _runMatching();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Smart Matches')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _matches.isEmpty
              ? Center(
                  child: FilledButton.icon(
                    onPressed: _runMatching,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Generate smart matches'),
                  ),
                )
              : ListView.builder(
                  itemCount: _matches.length,
                  itemBuilder: (_, i) {
                    final m = _matches[i];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${m.matchScore}')),
                        title: Text('Opportunity: ${m.opportunityId.substring(0, 6)}...'),
                        subtitle: Text('${m.reason}\nBias check: ${m.biasCheck}\n${m.recommendation}'),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _runMatching,
        label: const Text('Refresh AI'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}
