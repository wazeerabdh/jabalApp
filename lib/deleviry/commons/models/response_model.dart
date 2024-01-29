class ResponseModel_D {
  final String? _message;
  final bool _isSuccess;

  ResponseModel_D(this._message, this._isSuccess);

  bool get isSuccess => _isSuccess;
  String? get message => _message;
}