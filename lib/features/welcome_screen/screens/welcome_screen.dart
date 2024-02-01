import 'package:souqexpress/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter/material.dart';
import 'package:souqexpress/deleviry/features/auth/screens/login_screen.dart';
import 'package:souqexpress/helper/responsive_helper.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/features/splash/providers/splash_provider.dart';
import 'package:souqexpress/utill/color_resources.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/images.dart';
import 'package:souqexpress/utill/routes.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:souqexpress/common/widgets/custom_button_widget.dart';
import 'package:souqexpress/common/widgets/main_app_bar_widget.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(80), child: MainAppBarWidget()) : null,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: Dimensions.webScreenWidth,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Container(


                    // decoration: BoxDecoration(color: Colors.black12,borderRadius: BorderRadius.circular(8)),
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(30),
                    child: ResponsiveHelper.isWeb() ? Consumer<SplashProvider>(
                      builder:(context, splash, child) => FadeInImage.assetNetwork(
                        placeholder: Images.placeholder(context),
                        image: splash.baseUrls != null ? '${splash.baseUrls!.ecommerceImageUrl}/${splash.configModel!.appLogo}' : '',
                        height: 180,
                      ),
                    ) : Image.asset(Images.logo1, height: 160,width: 160,),
                  ),
                  // const SizedBox(height: 10),
                  // Text(
                  //   getTranslated('welcome', context),
                  //   textAlign: TextAlign.center,
                  //   style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 32),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Text(
                      getTranslated('welcome_to_efood', context),
                      textAlign: TextAlign.center,
                      style: rubikMedium.copyWith(color: ColorResources.getGreyColor(context)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: CustomButtonWidget(
                      btnTxt: getTranslated('login', context),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault,
                        right: Dimensions.paddingSizeDefault,
                        bottom: Dimensions.paddingSizeDefault,
                        top: 12),
                    child: CustomButtonWidget(
                      btnTxt: getTranslated('signup', context),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.getCreateAccountRoute());
                      },
                      backgroundColor: Colors.black,
                    ),
                  ),         Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: CustomButtonWidget(
                      btnTxt: getTranslated('sing_up_or_login', context),
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen_D()));


                      },
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1, 40),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Routes.getMainRoute());
                    },
                    child: RichText(text: TextSpan(children: [
                      TextSpan(text: '${getTranslated('login_as_a', context)} ', style: rubikRegular.copyWith(color: ColorResources.getGreyColor(context))),

                      TextSpan(text: getTranslated('guest', context), style: rubikMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                    ])),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
