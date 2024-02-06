import 'package:dio/dio.dart';

class ApiResponse_D {
  final Response? response;
  final dynamic error;

  ApiResponse_D(this.response, this.error);

  ApiResponse_D.withError(dynamic errorValue)
      : response = null,
        error = errorValue;

  ApiResponse_D.withSuccess(Response responseValue)
      : response = responseValue,
        error = null;
}
