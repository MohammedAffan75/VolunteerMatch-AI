import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteer_match_ai/models/opportunity_model.dart';

class OpportunityService {
  static final _db = FirebaseFirestore.instance.collection('opportunities');

  static Stream<List<OpportunityModel>> streamOpenOpportunities() {
    return _db
        .where('status', isEqualTo: 'open')
        .orderBy('dateTime')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OpportunityModel.fromJson(doc.data(), id: doc.id))
              .toList(),
        );
  }

  static Future<void> createOpportunity(OpportunityModel model) async {
    await _db.doc(model.id).set(model.toJson());
  }

  static Future<void> applyToOpportunity(String oppId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _db.doc(oppId).update({
      'applicants': FieldValue.arrayUnion([uid]),
    });
  }
}
