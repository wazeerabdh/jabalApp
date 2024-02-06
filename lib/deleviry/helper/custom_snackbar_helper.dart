
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar_D(String message, {bool isError = true}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    backgroundColor: isError ? Colors.red : Colors.green,
    content: Text(message),
    duration: const Duration(seconds: 2),
  ));
}