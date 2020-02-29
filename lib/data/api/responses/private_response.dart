class PrivateResponse {
  static PrivateResponse ok(String token, dynamic response) => PrivateResponse._(token: token, response: response, errors: []);

  static PrivateResponse error(List<String> errors) => PrivateResponse._(errors: errors);

  final String token;
  final dynamic response;
  final List<String> errors;

  PrivateResponse._({this.token, this.response, this.errors});
}
