class AppUser {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String location;
  final String password;
  final String role;

  AppUser({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.location,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'location': location,
        'password': password,
        'role': role,
      };
}
