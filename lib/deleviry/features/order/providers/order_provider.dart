import 'dart:async';
import 'package:flutter/material.dart';

import 'package:souqexpress/deleviry/commons/models/api_response.dart';
import 'package:souqexpress/deleviry/commons/models/response_model.dart';
import 'package:souqexpress/deleviry/features/order/domain/models/order_details_model.dart';
import 'package:souqexpress/deleviry/features/order/domain/models/order_model.dart';
import 'package:souqexpress/deleviry/features/order/domain/reposotories/order_repo.dart';
import 'package:souqexpress/deleviry/helper/api_checker_helper.dart';
import 'package:souqexpress/deleviry/helper/custom_snackbar_helper.dart';

class OrderProvider_D with ChangeNotifier {
  final OrderRepo_D? orderRepo;

  OrderProvider_D({required this.orderRepo});

  List<OrderModel_D>? _currentOrders;
  List<OrderModel_D> _currentOrdersReverse = [];
  bool _isLoading = false;
  List<OrderModel_D>? _allOrderHistory;
  late List<OrderModel_D> _allOrderReverse;
  List<OrderDetailsModel_D>? _orderDetails;

  List<OrderModel_D>? get currentOrders => _currentOrders;
  bool get isLoading => _isLoading;
  List<OrderModel_D>? get allOrderHistory => _allOrderHistory;
  List<OrderDetailsModel_D>? get orderDetails => _orderDetails;


  Future getAllOrders() async {
    ApiResponse_D apiResponse = await orderRepo!.getAllOrders();

    if (apiResponse.response?.statusCode == 200) {
      _currentOrders = [];
      _currentOrdersReverse = [];

      apiResponse.response?.data.forEach((order) {
        _currentOrdersReverse.add(OrderModel_D.fromJson(order));
      });

      _currentOrders = List.from(_currentOrdersReverse.reversed);

    } else {
      ApiCheckerHelper_D.checkApi(apiResponse);

    }
    notifyListeners();
  }


  Future<List<OrderDetailsModel_D>?> getOrderDetails(String orderID) async {
    _orderDetails = null;
    ApiResponse_D apiResponse = await orderRepo!.getOrderDetails(orderID: orderID);

    if (apiResponse.response?.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response!.data.forEach((orderDetail) => _orderDetails!.add(OrderDetailsModel_D.fromJson(orderDetail)));

    } else {
      ApiCheckerHelper_D.checkApi(apiResponse);

    }

    notifyListeners();
    return _orderDetails;
  }

  // get all order history


  Future<List<OrderModel_D>?> getOrderHistory() async {
    ApiResponse_D apiResponse = await orderRepo!.getAllOrderHistory();

    if (apiResponse.response!.statusCode == 200) {
      _allOrderHistory = [];
      _allOrderReverse = [];

      apiResponse.response!.data.forEach((orderDetail) => _allOrderReverse.add(OrderModel_D.fromJson(orderDetail)));

      _allOrderHistory = List.from(_allOrderReverse.reversed);

    } else {
      ApiCheckerHelper_D.checkApi(apiResponse);

    }

    notifyListeners();
    return _allOrderHistory;
  }

  // update Order Status



  Future<ResponseModel_D> updateOrderStatus({String? token, int? orderId, String? status}) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse_D apiResponse = await orderRepo!.updateOrderStatus(token: token, orderId: orderId, status: status);
    _isLoading = false;
    notifyListeners();

    ResponseModel_D responseModel;

    if (apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel_D(apiResponse.response?.data['message'], true);
    } else {

      String? feedbackMessage = ApiCheckerHelper_D.getError(apiResponse).errors?[0].message;
      showCustomSnackBar_D(feedbackMessage ?? '');
      responseModel = ResponseModel_D(feedbackMessage, false);
    }

    notifyListeners();
    return responseModel;
  }

  Future updatePaymentStatus({String? token, int? orderId, String? status}) async {
    await orderRepo!.updatePaymentStatus(token: token, orderId: orderId, status: status);

    notifyListeners();
  }

  Future<void> refresh() async{
    _isLoading = true;
    notifyListeners();
    await getAllOrders();
    await getOrderHistory();
    _isLoading = false;
    notifyListeners();
  }

  Future<OrderModel_D?> getOrderModel(String orderID) async {
   OrderModel_D? currentOrderModel;

    ApiResponse_D apiResponse = await orderRepo!.getOrderModel(orderID);

    if (apiResponse.response?.statusCode == 200) {
      currentOrderModel = OrderModel_D.fromJson(apiResponse.response!.data);

    } else {
      ApiCheckerHelper_D.checkApi(apiResponse);

    }

    notifyListeners();
    return currentOrderModel;
  }
}
