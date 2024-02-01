
import 'package:souqexpress/deleviry/commons/models/api_response.dart';
import 'package:souqexpress/deleviry/data/datasource/remote/dio/dio_client.dart';
import 'package:souqexpress/deleviry/data/datasource/remote/exception/api_error_handler.dart';
import 'package:souqexpress/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo_D {
  final DioClient_D? dioClient;
  final SharedPreferences? sharedPreferences;

  ProfileRepo_D({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse_D> getUserInfo() async {
    try {
      final response = await dioClient!.get('${AppConstants.profileUri_D}${sharedPreferences!.getString(AppConstants.token)}');
      return ApiResponse_D.withSuccess(response);
    } catch (e) {
      return ApiResponse_D.withError(ApiErrorHandler_D.getMessage(e));
    }
  }
}
