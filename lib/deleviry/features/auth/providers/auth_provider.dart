import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:souqexpress/deleviry/commons/models/api_response.dart';
import 'package:souqexpress/deleviry/commons/models/config_model.dart';
import 'package:souqexpress/deleviry/commons/models/error_response.dart';
import 'package:souqexpress/deleviry/commons/models/response_model.dart';
import 'package:souqexpress/deleviry/data/datasource/remote/dio/dio_client.dart';
import 'package:souqexpress/deleviry/features/auth/domain/models/delivery_man_body_model.dart';
import 'package:souqexpress/deleviry/features/auth/domain/reposotories/auth_repo.dart';
import 'package:souqexpress/deleviry/features/auth/screens/login_screen.dart';
import 'package:souqexpress/deleviry/helper/api_checker_helper.dart';
import 'package:souqexpress/deleviry/helper/custom_snackbar_helper.dart';
import 'package:souqexpress/features/splash/providers/splash_provider.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class AuthProvider_D with ChangeNotifier {
  final AuthRepo_D? authRepo;
  AuthProvider_D({required this.authRepo});
  bool _isLoading = false;
  String? _loginErrorMessage = '';
  XFile? _pickedImage;
  List<XFile> _pickedIdentities = [];
  final List<String> _identityTypeList = ['passport', 'driving_license', 'nid', 'restaurant_id'];
  int _identityTypeIndex = 0;
  final int _dmTypeIndex = 0;
  XFile? _pickedLogo;
  XFile? _pickedCover;
  int? _selectedBranchIndex;
  List<Branches_D>? _branchList;
  String _verificationCode = '';
  bool _isEnableVerificationCode = false;
  bool _isActiveRememberMe = false;


  bool get isLoading => _isLoading;
  String? get loginErrorMessage => _loginErrorMessage;
  List<String> get identityTypeList => _identityTypeList;
  XFile? get pickedImage => _pickedImage;
  List<XFile> get pickedIdentities => _pickedIdentities;
  int get identityTypeIndex => _identityTypeIndex;
  int get dmTypeIndex => _dmTypeIndex;
  XFile? get pickedLogo => _pickedLogo;
  XFile? get pickedCover => _pickedCover;
  List<Branches_D>? get branchList => _branchList;
  int? get selectedBranchIndex => _selectedBranchIndex;
  String get verificationCode => _verificationCode;
  bool get isEnableVerificationCode => _isEnableVerificationCode;
  bool get isActiveRememberMe => _isActiveRememberMe;


  Future<ResponseModel_D> login({String? emailAddress, String? password}) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();

    ApiResponse_D apiResponse = await authRepo!.login(emailAddress: emailAddress, password: password);
    ResponseModel_D responseModel;

    if (apiResponse.response?.statusCode == 200) {
      Map map = apiResponse.response?.data;
      String token = map["token"];
      authRepo!.saveUserToken(token);
      responseModel = ResponseModel_D('', true);
      await authRepo!.updateToken();
    } else {

      _loginErrorMessage = ApiCheckerHelper_D.getError(apiResponse).errors?[0].message;
      responseModel = ResponseModel_D(_loginErrorMessage, false);
    }

    _isLoading = false;
    notifyListeners();

    return responseModel;
  }


  Future<void> updateToken({String? token}) async {
    await authRepo!.updateToken(token: token);
  }

  void updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }


  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  bool isLoggedIn() {
    return authRepo!.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authRepo!.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo!.saveUserNumberAndPassword(number, password);
  }

  String getUserEmail() {
    return authRepo!.getUserEmail();
  }

  String getUserPassword() {
    return authRepo!.getUserPassword();
  }

  Future<bool> clearUserEmailAndPassword() async {
    return authRepo!.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo!.getUserToken();
  }

  void loadBranchList(){
    _branchList = [];

    _branchList?.add(Branches_D(id: 0, name: getTranslated('all', Get.context!)));
    _branchList?.addAll(Provider.of<SplashProvider>(Get.context!, listen: false).configModel_D?.branches ?? []);
   }

  void pickDmImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedImage = null;
      _pickedIdentities = [];
    }else {
      if (isLogo) {
        _pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        if(xFile != null) {
          _pickedIdentities.add(xFile);
        }
      }
      notifyListeners();
    }
  }

  void setIdentityTypeIndex(String? identityType, bool notify) {
    int index0 = 0;
    for(int index=0; index<_identityTypeList.length; index++) {
      if(_identityTypeList[index] == identityType) {
        index0 = index;
        break;
      }
    }
    _identityTypeIndex = index0;
    if(notify) {
      notifyListeners();
    }
  }



  void removeIdentityImage(int index) {
    _pickedIdentities.removeAt(index);
    notifyListeners();
  }

  Future<void> registerDeliveryMan(DeliveryManBodyModel_D deliveryManBody) async {
    _isLoading = true;
    notifyListeners();

    List<MultipartBody> multiParts = [];
    multiParts.add(MultipartBody('image', _pickedImage));

    for(XFile file in _pickedIdentities) {
      multiParts.add(MultipartBody('identity_image[]', file));
    }

    http.Response? apiResponse = await authRepo?.registerDeliveryMan(deliveryManBody, multiParts);

    if (apiResponse?.statusCode == 200) {
      Navigator.of(Get.context!).pop();
      showCustomSnackBar_D(getTranslated('delivery_man_registration_successful', Get.context!)!, isError: false);
    } else {
      dynamic errorResponse;
      try{
        errorResponse = ErrorResponse_D.fromJson(jsonDecode(apiResponse!.body.toString())).errors![0].message;
      }catch(er){
        errorResponse = apiResponse?.body;
      }

      showCustomSnackBar_D(errorResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  void setBranchIndex(int index, {bool isUpdate = true}){
    _selectedBranchIndex = index;

    if(isUpdate){
      notifyListeners();
    }
  }

  Future<void> deleteUser() async {
    _isLoading = true;
    notifyListeners();
    ApiResponse_D response = await authRepo!.deleteUser();
    _isLoading = false;
    notifyListeners();

    if (response.response?.statusCode == 200) {
      Provider.of<SplashProvider>(Get.context!, listen: false).removeSharedData();
      showCustomSnackBar_D(getTranslated('your_account_remove_successfully', Get.context!)!);
      Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (_) => const LoginScreen_D()), (route) => false);

    }else{
      Navigator.of(Get.context!).pop();
      ApiCheckerHelper_D.checkApi(response);
    }
  }

}
