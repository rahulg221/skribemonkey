class Entry{
  final String id;
  final String patient_id;
  final String user_id;
  final String condition;
  final String treatment;
  final String urgency_level;
  final String created_at;
  final String RAW_summary;
  final String Summary;

  Entry({
    required this.id,
    required this.patient_id,
    required this.user_id,
    required this.condition,
    required this.treatment,
    required this.urgency_level,
    required this.created_at,
    required this.RAW_summary,
    required this.Summary
  });

  // Convert JSON to User instance
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json[''],
      patient_id: json['patient_id'],
      user_id: json['user_id'],
      condition: json['condition'],
      treatment: json['treatment'],
      urgency_level: json['urgency_level'],
      created_at: json['created_at'],
      RAW_summary: json['RAW_summary'],
      Summary: json['Summary']
    );
  }

  // Convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patient_id,
      'user_id': user_id,
      'condition': condition,
      'treatment': treatment,
      'urgency_level': urgency_level,
      'created_at': created_at,
      'RAW_summary': RAW_summary,
      'Summary': Summary
    };
  }
}