class Patient {
  final String id;
  final String user_id;
  final String first_name;
  final String last_name;
  final String email;
  final String gender;
  final List<String> preexisting_conditions;
  final DateTime created_at;

  Patient(
      {required this.id,
      required this.user_id,
      required this.first_name,
      required this.last_name,
      required this.email,
      required this.gender,
      required this.preexisting_conditions,
      required this.created_at});

  // Convert JSON to User instance
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      user_id: json['user_id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      gender: json['gender'],
      preexisting_conditions: json['preexisting_conditions'],
      created_at: json['created_at']
    );
  }

  // Convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'gender': gender,
      'preexisting_conditions': preexisting_conditions
    };
  }
}
