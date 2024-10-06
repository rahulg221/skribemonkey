class Entry {
  final String id;
  final String patientId;
  final String userId;
  final String?
      condition; // Nullable, as it could be empty or missing in some cases
  final int urgencyLevel;
  final DateTime createdAt;
  final String summary;

  Entry({
    required this.id,
    required this.patientId,
    required this.userId,
    this.condition, // Optional
    required this.urgencyLevel,
    required this.createdAt,
    required this.summary,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'] ?? '', // If `id` is null, fallback to an empty string
      patientId: json['patient_id'] ?? '', // Same for `patient_id`
      userId: json['user_id'] ?? '', // Same for `user_id`
      condition: json['condition'], // `condition` can be null
      urgencyLevel:
          json['urgency_level'] ?? 0, // Provide default value of 0 if null
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime
              .now(), // Fallback to current time if `created_at` is null or cannot be parsed
      summary: json['Summary'] ??
          '', // Fallback to empty string if `summary` is null
    );
  }
}
