import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:souqexpress/deleviry/features/dashboard/screens/dashboard_screen.dart';
import 'package:souqexpress/deleviry/features/maintenance/screens/maintenance_screen.dart';
import 'package:souqexpress/features/language/screens/choose_language_screen.dart';
import 'package:souqexpress/helper/responsive_helper.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/main.dart';
import 'package:souqexpress/features/auth/providers/auth_provider.dart';
import 'package:souqexpress/features/cart/providers/cart_provider.dart';
import 'package:souqexpress/provider/language_provider.dart';
import 'package:souqexpress/features/splash/providers/splash_provider.dart';
import 'package:souqexpress/utill/app_constants.dart';
import 'package:souqexpress/utill/images.dart';
import 'package:souqexpress/utill/routes.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;

    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : _globalKey.currentState!.hideCurrentSnackBar();
        _globalKey.currentState!.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_connection', _globalKey.currentContext!): getTranslated('connected', _globalKey.currentContext!),
            textAlign: TextAlign.center,
          ),
        ));

        if(!isNotConnected) {
          _routeToPage();
          _goRouteToPage();
        }

      }

      firstTime = false;

    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();

    Provider.of<CartProvider>(context, listen: false).getCartData();
    _routeToPage();
    _goRouteToPage();
    Provider.of<LanguageProvider>(context, listen: false).initializeAllLanguages(context);


  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Images.logo, width: 170,),
            Text(AppConstants.appName, style: rubikBold.copyWith(fontSize: 30, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _routeToPage() {

    Provider.of<SplashProvider>(context, listen: false).initConfig().then((bool isSuccess) {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          double minimumVersion = 0.0;
          if(Platform.isAndroid) {
            if(Provider.of<SplashProvider>(context, listen: false).configModel!.playStoreConfig!.minVersion!=null){
              minimumVersion = Provider.of<SplashProvider>(context, listen: false).configModel!.playStoreConfig!.minVersion?? 6.0;

            }
          }else if(Platform.isIOS) {
            if(Provider.of<SplashProvider>(context, listen: false).configModel!.appStoreConfig!.minVersion!=null){
              minimumVersion = Provider.of<SplashProvider>(context, listen: false).configModel!.appStoreConfig!.minVersion?? 6.0;
            }
          }

          if(AppConstants.appVersion < minimumVersion && !ResponsiveHelper.isWeb()) {
            Navigator.pushNamedAndRemoveUntil(context, Routes.getUpdateRoute(), (route) => false);

          }else if (Provider.of<SplashProvider>(context, listen: false).configModel!.maintenanceMode!) {
            Navigator.pushNamedAndRemoveUntil(context, Routes.getMaintainRoute(), (route) => false);

          }else{

            if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken();

              Navigator.pushNamedAndRemoveUntil(Get.context!, Routes.getMainRoute(), (route) => false);

            } else {
              if(Provider.of<SplashProvider>(context, listen: false).showLang()) {
                Navigator.pushNamedAndRemoveUntil(context, ResponsiveHelper.isMobile(context) ? Routes.getLanguageRoute('splash') : Routes.getMainRoute(), (route) => false);

              }else {
                Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);

              }
            }
          }
        });
      }
    });


    // void _checkPermission(Widget navigateTo) async {
    //   LocationPermission permission = await Geolocator.checkPermission();
    //   if(permission == LocationPermission.denied) {
    //     permission = await Geolocator.requestPermission();
    //   }
    //   if(permission == LocationPermission.denied) {
    //     showDialog(context: Get.context!, barrierDismissible: false, builder: (context) => AlertDialog(
    //       title: Text(getTranslated('alert', context)!),
    //       content: Text(getTranslated('allow_for_all_time', context)!),
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //       actions: [ElevatedButton(
    //         onPressed: () async {
    //           Navigator.pop(context);
    //           await Geolocator.requestPermission();
    //           _checkPermission(navigateTo);
    //         },
    //         child: Text(getTranslated('ok', context)!),
    //       )],
    //     ));
    //   }else if(permission == LocationPermission.deniedForever) {
    //     await Geolocator.openLocationSettings();
    //   }else {
    //     Navigator.pushReplacement(Get.context!, MaterialPageRoute(builder: (_) => navigateTo));
    //   }
    // }
  }
  void _goRouteToPage() {
    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<SplashProvider>(context, listen: false).initConfig_1(context).then((bool isSuccess) {
      if (isSuccess) {
        if(Provider.of<SplashProvider>(context, listen: false).configModel!.maintenanceMode!) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MaintenanceScreen_D()));
        }
        Timer(const Duration(seconds: 1), () async {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Provider.of<AuthProvider>(context, listen: false).updateToken();
            // _checkPermission(const DashboardScreen_D());
          } else {
            // _checkPermission(const ChooseLanguageScreen());
          }

        });
      }
    });
  }
}
