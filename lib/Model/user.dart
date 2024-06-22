class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final DateTime birthdate;
  final String role;
  final bool etatDelete;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.birthdate,
    required this.role,
    required this.etatDelete,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print('Parsing User: $json');
    return User(
      id: json['_id'] ?? '', // Provide a default value if the field is null
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : DateTime.now(),
      role: json['role'] ?? '',
      etatDelete: json['etatDelete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'birthdate': birthdate.toIso8601String(),
      'role': role,
      'etatDelete': etatDelete,
    };
  }
}
