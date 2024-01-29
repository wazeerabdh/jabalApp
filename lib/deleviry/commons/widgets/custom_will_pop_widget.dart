// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexacom_user/deleviry/helper/custom_snackbar_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';

class CustomWillPopWidget_D extends StatefulWidget {
  final Widget child;
  const CustomWillPopWidget_D({Key? key, required this.child}) : super(key: key);

  @override
  State<CustomWillPopWidget_D> createState() => _CustomWillPopWidget_DState();
}

class _CustomWillPopWidget_DState extends State<CustomWillPopWidget_D> {
  bool canExit = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(Navigator.canPop(context)){
          return true;
        }else{
          if(canExit) {
            return true;
          }else {
            showCustomSnackBar_D(getTranslated('back_press_again_to_exit', context)!, isError: false);
            canExit = true;
            Timer(const Duration(seconds: 2), () {
              canExit = false;
            });
            return false;
          }
        }
      },
      child: widget.child,
    );
  }
}
