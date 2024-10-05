class User{
  final String id;
  final String name;
  final String email;
  final String role;
  final String created_at;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.created_at
  });

  // Convert JSON to User instance
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      created_at: json['created_at'],
    );
  }

  // Convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'created_at': created_at
    };
  }
}