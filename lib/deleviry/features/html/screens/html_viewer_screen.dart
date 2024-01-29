import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:hexacom_user/deleviry/commons/widgets/custom_app_bar_widget.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';


class HtmlViewerScreen_D extends StatelessWidget {

  final bool isPrivacyPolicy;
  const HtmlViewerScreen_D({Key? key, required this.isPrivacyPolicy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String data = isPrivacyPolicy ? Provider.of<SplashProvider>(context, listen: false).configModel!.privacyPolicy ?? ''
        : Provider.of<SplashProvider>(context, listen: false).configModel!.termsAndConditions ?? '';
    return Scaffold(
      appBar: CustomAppBarWidget_D(title: getTranslated(isPrivacyPolicy ? 'privacy_policy' : 'terms_and_condition', context)),
      body: SingleChildScrollView(
        padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        child: HtmlWidget(
          data,
          key: Key(data.toString()),
          onTapUrl: (String url) {
            return launchUrlString(url);
          },
        ),
      ),
    );
  }
}