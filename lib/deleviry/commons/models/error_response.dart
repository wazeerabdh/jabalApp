/// errors : [{"code":"l_name","message":"The last name field is required."},{"code":"password","message":"The password field is required."}]

class ErrorResponse_D {
  List<Errors_D>? _errors;

  List<Errors_D>? get errors => _errors;

  ErrorResponse_D({
      List<Errors_D>? errors}){
    _errors = errors;
}

  ErrorResponse_D.fromJson(dynamic json) {
    if (json["errors"] != null) {
      _errors = [];
      if(json['errors'] is List) {
        json["errors"].forEach((v) {
          _errors!.add(Errors_D.fromJson(v));
        });
      }else{
        _errors!.add(Errors_D.fromJson(json['errors']));
      }

    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_errors != null) {
      map["errors"] = _errors!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// code : "l_name"
/// message : "The last name field is required."

class Errors_D {
  String? _code;
  String? _message;

  String? get code => _code;
  String? get message => _message;
  Errors_D({
      String? code, 
      String? message}){
    _code = code;
    _message = message;
}

  Errors_D.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["message"] = _message;
    return map;
  }

}