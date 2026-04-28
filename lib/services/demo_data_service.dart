import 'package:uuid/uuid.dart';
import 'package:volunteer_match_ai/models/opportunity_model.dart';
import 'package:volunteer_match_ai/services/opportunity_service.dart';

class DemoDataService {
  static Future<void> seedKarnatakaDemo(String postedBy) async {
    final now = DateTime.now();
    final samples = [
      OpportunityModel(
        id: const Uuid().v4(),
        title: 'Rural Literacy Weekend - Mysuru',
        description: 'Teach reading and basic numeracy for children in rural clusters.',
        requiredSkills: const ['teaching', 'communication'],
        cause: 'rural literacy',
        latitude: 12.2958,
        longitude: 76.6394,
        dateTime: now.add(const Duration(days: 5)),
        numberNeeded: 20,
        postedBy: postedBy,
      ),
      OpportunityModel(
        id: const Uuid().v4(),
        title: 'Flood Relief Logistics - Kodagu',
        description: 'Coordinate relief kit packing, transport, and distribution.',
        requiredSkills: const ['coordination', 'logistics'],
        cause: 'flood relief',
        latitude: 12.3375,
        longitude: 75.8069,
        dateTime: now.add(const Duration(days: 8)),
        numberNeeded: 30,
        postedBy: postedBy,
      ),
      OpportunityModel(
        id: const Uuid().v4(),
        title: 'Community Health Camp - Bengaluru Rural',
        description: 'Assist doctors in registration, queue management, and awareness.',
        requiredSkills: const ['first aid', 'public outreach'],
        cause: 'health camps',
        latitude: 13.2841,
        longitude: 77.6078,
        dateTime: now.add(const Duration(days: 12)),
        numberNeeded: 25,
        postedBy: postedBy,
      ),
    ];

    for (final s in samples) {
      await OpportunityService.createOpportunity(s);
    }
  }
}
