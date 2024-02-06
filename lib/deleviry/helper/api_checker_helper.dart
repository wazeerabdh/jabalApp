
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:souqexpress/deleviry/commons/models/api_response.dart';
import 'package:souqexpress/deleviry/commons/models/error_response.dart';
import 'package:souqexpress/deleviry/features/auth/screens/login_screen.dart';
import 'package:souqexpress/features/splash/providers/splash_provider.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:provider/provider.dart';


class ApiCheckerHelper_D {
  static void checkApi(ApiResponse_D apiResponse) {
    ErrorResponse_D error = getError(apiResponse);

    if((error.errors![0].code == '401' || error.errors![0].code == 'auth-001')) {
      Provider.of<SplashProvider>(Get.context!, listen: false).removeSharedData();
      Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (_) => const LoginScreen_D()), (route) => false);
    }else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text(error.errors![0].message ?? getTranslated('not_found', Get.context!)!
            , style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    }
  }

  static ErrorResponse_D getError(ApiResponse_D apiResponse){
    ErrorResponse_D error;

    try{
      error = ErrorResponse_D.fromJson(apiResponse);
    }catch(e){
      if(apiResponse.error != null){
        error = ErrorResponse_D.fromJson(apiResponse.error);
      }else{
        error = ErrorResponse_D(errors: [Errors_D(code: '', message: apiResponse.error.toString())]);
      }
    }
    return error;
  }
}