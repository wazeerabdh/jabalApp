import 'package:dio/dio.dart';

import 'package:hexacom_user/deleviry/commons/models/api_response.dart';
import 'package:hexacom_user/deleviry/data/datasource/remote/dio/dio_client.dart';
import 'package:hexacom_user/deleviry/data/datasource/remote/exception/api_error_handler.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo_D {
  final DioClient_D? dioClient;
  final SharedPreferences? sharedPreferences;

  OrderRepo_D({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse_D> getAllOrders() async {
    try {
      final response = await dioClient!.get('${AppConstants.currentOrdersUri_D}${sharedPreferences!.get(AppConstants.token)}');
      return ApiResponse_D.withSuccess(response);
    } catch (e) {
      return ApiResponse_D.withError(ApiErrorHandler_D.getMessage(e));
    }
  }

  Future<ApiResponse_D> getOrderDetails({String? orderID}) async {
    try {
      final response = await dioClient!.get('${AppConstants.orderDetailsUri_D}${sharedPreferences!.get(AppConstants.token)}&order_id=$orderID');
      return ApiResponse_D.withSuccess(response);
    } catch (e) {
      return ApiResponse_D.withError(ApiErrorHandler_D.getMessage(e));
    }
  }

  Future<ApiResponse_D> getAllOrderHistory() async {
    try {
      final response = await dioClient!.get('${AppConstants.orderHistoryUri_D}${sharedPreferences!.get(AppConstants.token)}');
      return ApiResponse_D.withSuccess(response);
    } catch (e) {
      return ApiResponse_D.withError(ApiErrorHandler_D.getMessage(e));
    }
  }

  Future<ApiResponse_D> updateOrderStatus({String? token, int? orderId, String? status}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.updateOrderStatusUri_D,
        data: {"token": token, "order_id": orderId, "status": status, "_method": 'put'},
      );
      return ApiResponse_D.withSuccess(response);
    } catch (e) {
      return ApiResponse_D.withError(ApiErrorHandler_D.getMessage(e));
    }
  }
  Future<ApiResponse_D> updatePaymentStatus({String? token, int? orderId, String? status}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.updatePaymentStatusUri_D,
        data: {"token": token, "order_id": orderId, "status": status, "_method": 'put'},
      );
      return ApiResponse_D.withSuccess(response);
    } catch (e) {
      return ApiResponse_D.withError(ApiErrorHandler_D.getMessage(e));
    }
  }

  Future<ApiResponse_D> getOrderModel(String orderId) async {
    try {
      final response = await dioClient!.get('${AppConstants.getOrderModel_D}${sharedPreferences!.get(AppConstants.token)}&id=$orderId');
      return ApiResponse_D.withSuccess(response);
    } catch (e) {
      return ApiResponse_D.withError(ApiErrorHandler_D.getMessage(e));
    }
  }
}
