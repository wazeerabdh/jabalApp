  import 'package:flutter/material.dart';
import 'package:hexacom_user/deleviry/commons/widgets/custom_image_widget.dart';
import 'package:hexacom_user/deleviry/features/auth/providers/auth_provider.dart';
import 'package:hexacom_user/deleviry/features/html/screens/html_viewer_screen.dart';
import 'package:hexacom_user/deleviry/features/profile/providers/profile_provider.dart';
import 'package:hexacom_user/deleviry/features/profile/widgets/acount_delete_dialog_widget.dart';
import 'package:hexacom_user/deleviry/features/profile/widgets/profile_button_widget.dart';
import 'package:hexacom_user/deleviry/features/profile/widgets/theme_status_widget.dart';
import 'package:hexacom_user/deleviry/features/profile/widgets/user_info_widget.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:provider/provider.dart';

import '../widgets/sign_out_confirmation_dialog_widget.dart';

class ProfileScreen_D extends StatelessWidget {
  const ProfileScreen_D({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final AuthProvider_D authProvider = Provider.of<AuthProvider_D>(context, listen: false);
    return Scaffold(
        body: Consumer<ProfileProvider_D>(builder: (context, profileProvider, child) =>
        profileProvider.userInfoModel == null ? const Center(child: CircularProgressIndicator()) :
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        getTranslated('my_profile', context)!,
                        style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white),
                      ),
                      const SizedBox(height: 30),

                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: CustomImageWidget_D(
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl}/${profileProvider.userInfoModel!.image}',
                              height: 80, width: 80,
                              )),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        profileProvider.userInfoModel!.fName != null
                            ? '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}'
                            : "",
                        style: rubikRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                Container(
                  color: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated('theme_style', context)!,
                            style: rubikRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                          const ThemeStatusWidget_D()
                        ],
                      ),
                      const SizedBox(height: 20),

                      UserInfoWidget_D(text: profileProvider.userInfoModel!.fName),
                      const SizedBox(height: 15),

                      UserInfoWidget_D(text: profileProvider.userInfoModel!.lName),
                      const SizedBox(height: 15),

                      UserInfoWidget_D(text: profileProvider.userInfoModel!.phone),
                      const SizedBox(height: 20),

                      ProfileButtonWidget_D(icon: Icons.privacy_tip, title: getTranslated('privacy_policy', context), onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HtmlViewerScreen_D(isPrivacyPolicy: true)));
                      }),
                      const SizedBox(height: 10),

                      ProfileButtonWidget_D(icon: Icons.list, title: getTranslated('terms_and_condition', context), onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HtmlViewerScreen_D(isPrivacyPolicy: false)));
                      }),
                      const SizedBox(height: 10),

                      ProfileButtonWidget_D(icon: Icons.delete, title: getTranslated('delete_account', context), onTap: () {
                        showDialog(context: context, builder: (context)=> AccountDeleteDialogWidget_D(
                          icon: Icons.question_mark_sharp,
                          title: getTranslated('are_you_sure_to_delete_account', context),
                          description: getTranslated('it_will_remove_your_all_information', context),
                          onTapFalseText:getTranslated('no', context),
                          onTapTrueText: getTranslated('yes', context),
                          isFailed: true,
                          onTapFalse: () => Navigator.of(context).pop(),
                          onTapTrue: () async => await authProvider.deleteUser(),
                        ));

                      }),




                      ProfileButtonWidget_D(icon: Icons.logout, title: getTranslated('logout', context), onTap: () {
                        showDialog(context: context, barrierDismissible: false, builder: (context) => const SignOutConfirmationDialogWidget());
                      }),


                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}


