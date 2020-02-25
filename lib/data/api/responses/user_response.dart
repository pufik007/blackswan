import 'package:tensorfit/data/api/entities/user.dart';

class UserResponse {
  static UserResponse ok(String token, String client, User user) => UserResponse._(token: token, client: client, user: user, errors: []);

  static UserResponse error(List<String> errors) => UserResponse._(errors: errors);

  final String token;
  final String client;
  final User user;
  final List<String> errors;

  UserResponse._({this.token, this.client, this.user, this.errors});
}
