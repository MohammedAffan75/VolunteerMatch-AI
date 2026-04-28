class UserModel {
  final String uid;
  final String role;
  final String name;
  final String email;
  final List<String> skills;
  final List<String> availability;
  final double latitude;
  final double longitude;
  final List<String> preferredCauses;
  final int points;
  final List<String> badges;
  final double totalHours;

  const UserModel({
    required this.uid,
    required this.role,
    required this.name,
    required this.email,
    this.skills = const [],
    this.availability = const [],
    this.latitude = 0,
    this.longitude = 0,
    this.preferredCauses = const [],
    this.points = 0,
    this.badges = const [],
    this.totalHours = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return UserModel(
      uid: id ?? (json['uid'] as String? ?? ''),
      role: json['role'] as String? ?? 'volunteer',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      availability: List<String>.from(json['availability'] ?? []),
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      preferredCauses: List<String>.from(json['preferredCauses'] ?? []),
      points: json['points'] as int? ?? 0,
      badges: List<String>.from(json['badges'] ?? []),
      totalHours: (json['totalHours'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'role': role,
      'name': name,
      'email': email,
      'skills': skills,
      'availability': availability,
      'latitude': latitude,
      'longitude': longitude,
      'preferredCauses': preferredCauses,
      'points': points,
      'badges': badges,
      'totalHours': totalHours,
    };
  }
}
