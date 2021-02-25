import 'package:intl/intl.dart';
import 'package:tensorfit/ui/pages/journey_bloc/user_gender_type.dart';

class User {
  final int id;
  final String email;
  final String provider;
  final String dateOfBirth;
  final int height;
  final int weight;
  final String locale;
  final String gender;

  User(
      {this.id,
      this.email,
      this.provider,
      this.dateOfBirth,
      this.height,
      this.weight,
      this.locale,
      this.gender});

  User update(
    DateTime newDateOfBirth,
    int newHeight,
    int newWeight,
    UserGenderType newGender,
    String newLocale,
  ) {
    var textDateOfBirth = DateFormat('yyyy/MM/dd').format(newDateOfBirth);
    var textGender;
    switch (newGender) {
      case UserGenderType.Male:
        textGender = 'male';
        break;
      case UserGenderType.Female:
        textGender = 'female';
        break;
    }
    return User(
      id: this.id,
      email: this.email,
      provider: this.provider,
      dateOfBirth: textDateOfBirth,
      height: newHeight,
      weight: newWeight,
      locale: newLocale,
      gender: textGender,
    );
  }

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

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'email': this.email,
        'provider': this.provider,
        'date_of_birth': this.dateOfBirth,
        'height': this.height,
        'weight': this.weight,
        'locale': this.locale,
        'gender': this.gender,
      };
}
