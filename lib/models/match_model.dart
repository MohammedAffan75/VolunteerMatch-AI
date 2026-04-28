class MatchModel {
  final String opportunityId;
  final String volunteerId;
  final int matchScore;
  final String reason;
  final String biasCheck;
  final String recommendation;

  const MatchModel({
    required this.opportunityId,
    required this.volunteerId,
    required this.matchScore,
    required this.reason,
    required this.biasCheck,
    required this.recommendation,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      opportunityId: json['opportunityId'] as String? ?? '',
      volunteerId: json['volunteerId'] as String? ?? '',
      matchScore: (json['matchScore'] ?? 0) as int,
      reason: json['reason'] as String? ?? '',
      biasCheck: json['biasCheck'] as String? ?? '',
      recommendation: json['recommendation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'opportunityId': opportunityId,
      'volunteerId': volunteerId,
      'matchScore': matchScore,
      'reason': reason,
      'biasCheck': biasCheck,
      'recommendation': recommendation,
    };
  }
}
