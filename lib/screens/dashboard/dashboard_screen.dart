import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_match_ai/services/auth_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.getCurrentProfile(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final hours = user?.totalHours ?? 18;
        final points = user?.points ?? 240;
        final badges = user?.badges.isNotEmpty == true ? user!.badges : ['Literacy Hero', 'Flood Responder'];
        return Scaffold(
          appBar: AppBar(title: const Text('My Activity & Impact')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: Text('Total Hours: $hours'),
                  subtitle: Text('Points: $points • People helped: ${(hours * 4).toInt()}'),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: hours / 2)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: hours / 3)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: hours / 4)]),
                    ],
                    titlesData: const FlTitlesData(show: true),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(spacing: 8, children: badges.map((e) => Chip(label: Text(e))).toList()),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.timer),
                label: const Text('Log hours after event'),
              ),
            ],
          ),
        );
      },
    );
  }
}
