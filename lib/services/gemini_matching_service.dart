import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:volunteer_match_ai/models/match_model.dart';
import 'package:volunteer_match_ai/models/opportunity_model.dart';
import 'package:volunteer_match_ai/models/user_model.dart';

class GeminiMatchingService {
  GeminiMatchingService._();
  static final instance = GeminiMatchingService._();

  final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');

  String buildPrompt(UserModel volunteer, OpportunityModel opportunity) {
    return '''
You are VolunteerMatch AI, an ethical matching assistant for Karnataka-focused social impact opportunities.

Objective:
- Match a volunteer to an NGO opportunity based on skills, availability, location, and cause alignment.
- Prioritize relevance to: rural literacy, flood relief, health camps.
- Must align with UN SDG 17 (partnerships), SDG 3 (health), SDG 4 (quality education).
- Be unbiased across gender, religion, caste, language, and socioeconomic background.

Volunteer Profile:
${jsonEncode(volunteer.toJson())}

Opportunity:
${jsonEncode(opportunity.toJson())}

Return STRICT JSON only:
{
  "matchScore": <0-100 int>,
  "reason": "<concise explanation with 2-4 factors>",
  "biasCheck": "<state fairness checks performed>",
  "recommendation": "<one practical next action>"
}

Scoring guidance:
- Skills fit: 35%
- Cause alignment: 25%
- Availability overlap: 20%
- Location practicality: 20%
''';
  }

  Future<MatchModel> generateMatch({
    required UserModel volunteer,
    required OpportunityModel opportunity,
  }) async {
    try {
      final response = await model.generateContent([
        Content.text(buildPrompt(volunteer, opportunity)),
      ]);
      final raw = (response.text ?? '{}').trim();
      final cleaned = raw.startsWith('```')
          ? raw.replaceAll('```json', '').replaceAll('```', '').trim()
          : raw;
      final map = jsonDecode(cleaned) as Map<String, dynamic>;
      return MatchModel.fromJson({
        ...map,
        'opportunityId': opportunity.id,
        'volunteerId': volunteer.uid,
      });
    } catch (_) {
      return MatchModel(
        opportunityId: opportunity.id,
        volunteerId: volunteer.uid,
        matchScore: 50,
        reason: 'Fallback score used due to AI service error.',
        biasCheck: 'No sensitive attribute weighting was applied.',
        recommendation: 'Show this opportunity and let volunteer decide.',
      );
    }
  }
}
