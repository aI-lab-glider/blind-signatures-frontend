class User {
  int userId;
  String email;
  String publicKey;

  User({
    required this.userId,
    required this.email,
    required this.publicKey
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['id'],
        email: responseData['email'],
        publicKey: responseData['public_key']
    );
  }
}