import 'package:flutter/material.dart';
import 'package:hexacom_user/deleviry/commons/models/api_response.dart';
import 'package:hexacom_user/deleviry/features/profile/domain/models/userinfo_model.dart';
import 'package:hexacom_user/deleviry/features/profile/domain/reposotories/profile_repo.dart';
import 'package:hexacom_user/deleviry/helper/api_checker_helper.dart';


class ProfileProvider_D with ChangeNotifier {
  final ProfileRepo_D? profileRepo1;

  ProfileProvider_D({required this.profileRepo1});

  UserInfoModel_D? _userInfoModel;
  UserInfoModel_D? get userInfoModel => _userInfoModel;

  void getUserInfo() async {
    ApiResponse_D apiResponse = await profileRepo1!.getUserInfo();

    if (apiResponse.response?.statusCode == 200) {
      _userInfoModel = UserInfoModel_D.fromJson(apiResponse.response?.data);

    } else {
      ApiCheckerHelper_D.checkApi(apiResponse);

    }
    notifyListeners();
  }
}
