class Patient{
  final String id;
  final String user_id;
  final String name;
  final String email;
  final String gender;
  final String preexisting_conditions;
  final String created_at;

  Patient({
    required this.id,
    required this.user_id,
    required this.name,
    required this.email,
    required this.gender,
    required this.preexisting_conditions,
    required this.created_at
  });

  // Convert JSON to User instance
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      user_id: json['user_id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      preexisting_conditions: json['preexisting_conditions'],
      created_at: json['created_at'],
    );
  }

  // Convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'name': name,
      'email': email,
      'gender': gender,
      'preexisting_conditions': preexisting_conditions,
      'created_at': created_at,
    };
  }
}