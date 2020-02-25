class User {
  final int id;
  final String email;
  final String provider;
  final String dateOfBirth;
  final int height;
  final int weight;
  final String locale;
  final String gender;

  User({this.id, this.email, this.provider, this.dateOfBirth, this.height, this.weight, this.locale, this.gender});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      provider: json['provider'],
      dateOfBirth: json['date_of_birth'],
      height: json['height'],
      weight: json['weight'],
      locale: json['locale'],
      gender: json['gender'],
    );
  }
}
