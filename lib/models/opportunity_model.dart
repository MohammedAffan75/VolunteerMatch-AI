class OpportunityModel {
  final String id;
  final String title;
  final String description;
  final List<String> requiredSkills;
  final String cause;
  final double latitude;
  final double longitude;
  final DateTime dateTime;
  final int numberNeeded;
  final String status;
  final String postedBy;
  final List<String> applicants;

  const OpportunityModel({
    required this.id,
    required this.title,
    required this.description,
    this.requiredSkills = const [],
    this.cause = '',
    this.latitude = 0,
    this.longitude = 0,
    required this.dateTime,
    this.numberNeeded = 1,
    this.status = 'open',
    required this.postedBy,
    this.applicants = const [],
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json, {String? id}) {
    final rawDate = json['dateTime'];
    return OpportunityModel(
      id: id ?? (json['id'] as String? ?? ''),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      cause: json['cause'] as String? ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      dateTime: rawDate is String
          ? DateTime.tryParse(rawDate) ?? DateTime.now()
          : DateTime.now(),
      numberNeeded: json['numberNeeded'] as int? ?? 1,
      status: json['status'] as String? ?? 'open',
      postedBy: json['postedBy'] as String? ?? '',
      applicants: List<String>.from(json['applicants'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'requiredSkills': requiredSkills,
      'cause': cause,
      'latitude': latitude,
      'longitude': longitude,
      'dateTime': dateTime.toIso8601String(),
      'numberNeeded': numberNeeded,
      'status': status,
      'postedBy': postedBy,
      'applicants': applicants,
    };
  }
}
