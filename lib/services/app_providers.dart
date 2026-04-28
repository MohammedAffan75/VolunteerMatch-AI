import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_match_ai/models/opportunity_model.dart';
import 'package:volunteer_match_ai/services/opportunity_service.dart';

final opportunitiesProvider = StreamProvider<List<OpportunityModel>>((ref) {
  return OpportunityService.streamOpenOpportunities();
});
