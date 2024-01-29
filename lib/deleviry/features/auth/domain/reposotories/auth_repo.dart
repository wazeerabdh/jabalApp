
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:hexacom_user/deleviry/commons/models/api_response.dart';
import 'package:hexacom_user/deleviry/data/datasource/remote/dio/dio_client.dart';
import 'package:hexacom_user/deleviry/data/datasource/remote/exception/api_error_handler.dart';
import 'package:hexacom_user/deleviry/features/auth/domain/models/delivery_man_body_model.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class AuthRepo_D {
  final DioClient_D? dioClient;
  final SharedPreferences? sharedPreferences;
  AuthRepo_D({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse_D> login({String? emailAddress, String? password}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginUri_D,
        data: {"email": emailAddress, "password": password},
      );
      return ApiResponse_D.withSuccess(response);
    } catch (e) {
      return ApiResponse_D.withError(ApiErrorHandler_D.getMessage(e));
    }
  }



  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient!.token = token;
    dioClient!.dio!.options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};

    try {
      await sharedPreferences!.setString(AppConstants.token, token);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse_D> updateToken({String? token}) async {
    try {
      String? deviceToken = await _saveDeviceToken();
      Response response = await dioClient!.post(
        AppConstants.tokenUri_D,
        data: {"_method": "put", "fcm_token": token ?? deviceToken, "token": sharedPreferences!.get(AppConstants.token)},
      );
      return ApiResponse_D.withSuccess(response);
    } catch (e) {
      return ApiResponse_D.withError(ApiErrorHandler_D.getMessage(e));
    }
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken != null) {
      debugPrint('--------Device Token---------- $deviceToken');
    }
    return deviceToken;
  }

  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    return sharedPreferences!.remove(AppConstants.token);
    //return sharedPreferences.clear();
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences!.setString(AppConstants.userPassword, password);
      await sharedPreferences!.setString(AppConstants.userEmail, number);
    } catch (e) {
      rethrow;
    }
  }

  String getUserEmail() {
    return sharedPreferences!.getString(AppConstants.userEmail) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences!.getString(AppConstants.userPassword) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences!.remove(AppConstants.userPassword);
    return await sharedPreferences!.remove(AppConstants.userEmail);
  }

  Future<http.Response> registerDeliveryMan(DeliveryManBodyModel_D deliveryManBody, List<MultipartBody> multiParts) async {
    http.Response response = await dioClient!.postMultipartData(
      AppConstants.register_D,
      deliveryManBody.toJson(),
      multiParts,
    );
    return response;
  }

  Future<ApiResponse_D> deleteUser() async {
    try{
      Response response = await dioClient!.delete('${AppConstants.removeAccount_D}${sharedPreferences!.get(AppConstants.token)}');
      return ApiResponse_D.withSuccess(response);
    }catch(e) {
      return ApiResponse_D.withError(ApiErrorHandler_D.getMessage(e));
    }

  }
}
