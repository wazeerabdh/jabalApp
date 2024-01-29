
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexacom_user/deleviry/commons/models/api_response.dart';

import 'package:hexacom_user/deleviry/features/chat/domain/models/chat_model.dart';
import 'package:hexacom_user/deleviry/features/chat/domain/reposotories/chat_repo.dart';
import 'package:hexacom_user/deleviry/helper/api_checker_helper.dart';
import 'package:hexacom_user/deleviry/helper/custom_snackbar_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class ChatProvider_D with ChangeNotifier {
  final ChatRepo_D? chatRepo;
  ChatProvider_D({required this.chatRepo});

  List<Messages>?  _messages;
  bool _isSendButtonActive = false;
  List <XFile>? _imageFile;
  List <XFile>_chatImage = [];
  bool _isLoading= false;

  List<Messages>? get messages => _messages;
  bool get isSendButtonActive => _isSendButtonActive;
  List <XFile>? get imageFile => _imageFile;
  List<XFile> get chatImage => _chatImage;
  bool get isLoading => _isLoading;


  Future<void> getChatMessages (int? orderId, {bool isLoad = false}) async {
    if(isLoad){
      _messages = null;
    }
    ApiResponse_D apiResponse = await chatRepo!.getMessage(orderId,1);
    if (apiResponse.response?.data['messages'] != {} && apiResponse.response?.statusCode == 200) {
      _messages = [];
      _messages?.addAll(ChatModel.fromJson(apiResponse.response!.data).messages!);
    } else {
      _messages = [];
      ApiCheckerHelper_D.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void pickImage(bool isRemove) async {
    final ImagePicker picker = ImagePicker();

    if(isRemove) {
      _imageFile = [];
      _chatImage = [];
    }else {
      _imageFile = await picker.pickMultiImage(imageQuality: 30);

      if (_imageFile != null) {
        _chatImage.addAll(_imageFile!);
      }

    }

    _isSendButtonActive = true;
    notifyListeners();
  }

  void removeImage(int index){
    chatImage.removeAt(index);
    notifyListeners();
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  Future<http.StreamedResponse> sendMessage(String message, List<XFile> file, int? orderId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    http.StreamedResponse response = await chatRepo!.sendMessage(message, file, orderId);

    if (response.statusCode == 200) {
      _imageFile = [];
      _chatImage = [];
      file =[];
      getChatMessages(orderId);
      _isLoading= false;

    } else {
      showCustomSnackBar_D(getTranslated('write_some_thing', Get.context!)!);

    }

    _imageFile = [];
    _isLoading= false;

    notifyListeners();

    return response;
  }

}
