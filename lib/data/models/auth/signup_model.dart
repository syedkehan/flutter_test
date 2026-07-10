class SignUpModel {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String? dateOfBirth;

  SignUpModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'password': password,
    if (dateOfBirth != null && dateOfBirth!.isNotEmpty)
      'dateOfBirth': dateOfBirth,
  };
}
