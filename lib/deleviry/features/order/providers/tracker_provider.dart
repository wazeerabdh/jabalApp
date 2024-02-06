import 'dart:async';

import 'package:flutter/material.dart';
import 'package:souqexpress/deleviry/commons/models/api_response.dart';
import 'package:souqexpress/deleviry/commons/models/response_model.dart';
import 'package:souqexpress/deleviry/features/order/domain/models/track_data_model.dart';
import 'package:souqexpress/deleviry/features/order/domain/reposotories/tracker_repo.dart';
import 'package:souqexpress/deleviry/helper/api_checker_helper.dart';


class TrackerProvider_D extends ChangeNotifier {
  final TrackerRepo_D? trackerRepo;
  TrackerProvider_D({required this.trackerRepo});

  bool _startTrack = false;
  Timer? timer;


  void updateTrackStart(bool status) {
    _startTrack = status;
    if (status == false && timer != null) {
      timer!.cancel();
    }
    notifyListeners();
  }

  Future<ResponseModel_D?> addTrackData({TrackDataModel_D? trackBody}) async {
    ResponseModel_D? responseModel;
    responseModel = await locationUpdate(trackBody: trackBody);

    timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_startTrack) {
        responseModel = await locationUpdate(trackBody: trackBody);
        notifyListeners();
      } else {
        timer.cancel();
      }
    });

    return responseModel;
  }

  Future<ResponseModel_D?> locationUpdate({TrackDataModel_D? trackBody}) async{
    ResponseModel_D? responseModel;

    ApiResponse_D apiResponse = await trackerRepo!.addHistory(trackBody!);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel_D('Successfully start track', true);
    } else {
      responseModel = ResponseModel_D(ApiCheckerHelper_D.getError(apiResponse).errors?.first.message, false);
    }
    return responseModel;

  }
}
