import 'package:flutter/material.dart';
import 'package:souqexpress/common/models/language_model.dart';
import 'package:souqexpress/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
