import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:volunteer_match_ai/services/auth_service.dart';
import 'package:volunteer_match_ai/services/app_providers.dart';
import 'package:volunteer_match_ai/services/demo_data_service.dart';
import 'package:volunteer_match_ai/services/opportunity_service.dart';

class OpportunitiesScreen extends ConsumerStatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  ConsumerState<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends ConsumerState<OpportunitiesScreen> {
  String query = '';
  String cause = 'all';

  @override
  Widget build(BuildContext context) {
    final asyncOpps = ref.watch(opportunitiesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Opportunities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dataset_outlined),
            tooltip: 'Load Karnataka demo data',
            onPressed: () async {
              final uid = AuthService.currentUser?.uid;
              if (uid == null) return;
              await DemoDataService.seedKarnatakaDemo(uid);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Karnataka demo data added')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => Navigator.pushNamed(context, '/opportunity-form'),
          ),
        ],
      ),
      body: asyncOpps.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          final filtered = items.where((e) {
            final q = query.toLowerCase();
            final matchesQuery = e.title.toLowerCase().contains(q) || e.description.toLowerCase().contains(q);
            final matchesCause = cause == 'all' || e.cause.toLowerCase() == cause.toLowerCase();
            return matchesQuery && matchesCause;
          }).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by title'),
                        onChanged: (v) => setState(() => query = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: cause,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(value: 'rural literacy', child: Text('Literacy')),
                        DropdownMenuItem(value: 'flood relief', child: Text('Flood Relief')),
                        DropdownMenuItem(value: 'health camps', child: Text('Health Camps')),
                      ],
                      onChanged: (v) => setState(() => cause = v ?? 'all'),
                    ),
                  ],
                ),
              ),
              if (filtered.isEmpty) const Expanded(child: Center(child: Text('No opportunities found.'))),
              if (filtered.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final item = filtered[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(item.title),
                          subtitle: Text(
                            '${item.cause} • ${DateFormat.yMMMd().format(item.dateTime)}\n'
                            'Skills: ${item.requiredSkills.join(', ')}',
                          ),
                          isThreeLine: true,
                          trailing: FilledButton(
                            onPressed: () => OpportunityService.applyToOpportunity(item.id),
                            child: const Text('Apply'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
