import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hexacom_user/localization/language_constrants.dart';

class NetworkInfoHelper {
  final Connectivity connectivity;
  NetworkInfoHelper(this.connectivity);

  Future<bool> get isConnected async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static void checkConnectivity(GlobalKey<ScaffoldMessengerState> globalKey) {
    bool firstTime = true;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : globalKey.currentState?.hideCurrentSnackBar();
        globalKey.currentState?.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_connection', globalKey.currentContext!): getTranslated('connected', globalKey.currentContext!),
            textAlign: TextAlign.center,
          ),
        ));
      }
      firstTime = false;
    });
  }
}
