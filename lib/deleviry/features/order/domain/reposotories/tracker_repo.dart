
import 'package:dio/dio.dart';
import 'package:hexacom_user/deleviry/commons/models/api_response.dart';
import 'package:hexacom_user/deleviry/data/datasource/remote/dio/dio_client.dart';
import 'package:hexacom_user/deleviry/data/datasource/remote/exception/api_error_handler.dart';
import 'package:hexacom_user/deleviry/features/order/domain/models/track_data_model.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerRepo_D {
  final DioClient_D? dioClient;
  final SharedPreferences? sharedPreferences;
  TrackerRepo_D({required this.dioClient, required this.sharedPreferences});


  Future<ApiResponse_D> addHistory(TrackDataModel_D trackBody) async {
    try {
      Response response = await dioClient!.post(AppConstants.recordLocationUri_D, data: trackBody.toJson());
      return ApiResponse_D.withSuccess(response);
    } catch (e) {
      return ApiResponse_D.withError(ApiErrorHandler_D.getMessage(e));
    }
  }

}