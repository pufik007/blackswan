class Errors {
  final List<String> errors;

  Errors({this.errors});

  factory Errors.fromJson(Map<String, dynamic> json) {
    Map<String,dynamic> rawErrors = json['errors'];

    var res = List<String>();
    for(var key in rawErrors.keys) {
      if(key == 'full_messages') {
        List<dynamic> values = rawErrors[key];

        for(var value in values) {
          res.add(value.toString());
        }
      }
      if(key == 'error') {
        res.add(rawErrors[key]);
      }
    }

    return Errors(
      errors: res,
    );
  }
}