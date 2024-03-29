import 'package:souqexpress/data/datasource/remote/dio/dio_client.dart';
import 'package:souqexpress/data/datasource/remote/exception/api_error_handler.dart';
import 'package:souqexpress/common/models/api_response_model.dart';
import 'package:souqexpress/deleviry/commons/models/api_response.dart';
import 'package:souqexpress/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.dioClient});

  Future<ApiResponseModel> getConfig() async {
    try {
      final response = await dioClient!.get(AppConstants.configUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse_D> getConfig1() async {
    try {
      final response = await dioClient!.get(AppConstants.configUri);
      return ApiResponse_D.withSuccess(response);
    } catch (e) {
      return ApiResponse_D.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponseModel> getPolicyPage() async {
    try {
      final response = await dioClient!.get(AppConstants.policyPage);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if(!sharedPreferences!.containsKey(AppConstants.theme)) {
      return sharedPreferences!.setBool(AppConstants.theme, false);
    }
    if(!sharedPreferences!.containsKey(AppConstants.countryCode)) {
      return sharedPreferences!.setString(AppConstants.countryCode,
          AppConstants.languages[0].countryCode!);
    }
    if(!sharedPreferences!.containsKey(AppConstants.languageCode)) {
      return sharedPreferences!.setString(AppConstants.languageCode,
          AppConstants.languages[0].languageCode!);
    }
    if(!sharedPreferences!.containsKey(AppConstants.onBoardingSkip)) {
      return sharedPreferences!.setBool(AppConstants.onBoardingSkip, false);
    }
    if (!sharedPreferences!.containsKey(AppConstants.langSkip)) {
      sharedPreferences!.setBool(AppConstants.langSkip, true);
    }
    if(!sharedPreferences!.containsKey(AppConstants.cartList)) {
      return sharedPreferences!.setStringList(AppConstants.cartList, []);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences!.clear();
  }
  void disableLang() {
    sharedPreferences!.setBool(AppConstants.langSkip, false);
  }

  bool showLang() {
    return sharedPreferences!.getBool(AppConstants.langSkip)?? true;
  }
}