class PublicResponse {
  static PublicResponse ok(dynamic response) => PublicResponse._(response: response, errors: []);

  static PublicResponse error(List<String> errors) => PublicResponse._(errors: errors);

  final dynamic response;
  final List<String> errors;

  PublicResponse._({this.response, this.errors});
}
