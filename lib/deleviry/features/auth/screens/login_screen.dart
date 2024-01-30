
import 'package:flutter/material.dart';
import 'package:hexacom_user/deleviry/commons/widgets/custom_button_widget.dart';
import 'package:hexacom_user/deleviry/commons/widgets/custom_text_field_widget.dart';
import 'package:hexacom_user/deleviry/commons/widgets/custom_will_pop_widget.dart';
import 'package:hexacom_user/deleviry/features/auth/providers/auth_provider.dart';
import 'package:hexacom_user/deleviry/features/auth/screens/delivery_man_registration_screen.dart';
import 'package:hexacom_user/deleviry/features/dashboard/screens/dashboard_screen.dart';
import 'package:hexacom_user/deleviry/helper/custom_snackbar_helper.dart';
import 'package:hexacom_user/deleviry/helper/email_checker_helper.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/images.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:provider/provider.dart';

class LoginScreen_D extends StatefulWidget {
  const LoginScreen_D({Key? key}) : super(key: key);

  @override
  State<LoginScreen_D> createState() => _LoginScreen_DState();
}

class _LoginScreen_DState extends State<LoginScreen_D> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController!.text = Provider.of<AuthProvider_D>(context, listen: false).getUserEmail();
    _passwordController!.text = Provider.of<AuthProvider_D>(context, listen: false).getUserPassword();
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return CustomWillPopWidget_D(child: Scaffold(body: Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Consumer<AuthProvider_D>(
        builder: (context, authProvider, child) => Form(
          key: _formKeyLogin,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:20),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    Images.logo1,
                    height: MediaQuery.of(context).size.height / 5,
                    fit: BoxFit.scaleDown,
                    matchTextDirection: true,
                  ),
                ),
                //SizedBox(height: 20),
                Center(
                    child: Text(
                      getTranslated('login_de', context)!,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 18, color: Theme.of(context).hintColor),
                    )),
                const SizedBox(height: 15),
                Text(
                  getTranslated('email_address', context)!,
                  style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                CustomTextFieldWidget_D(
                  hintText: getTranslated('**********', context),
                  isShowBorder: true,
                  focusNode: _emailFocus,
                  nextFocus: _passwordFocus,
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Text(
                  getTranslated('password', context)!,
                  style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                CustomTextFieldWidget_D(
                  hintText: getTranslated('password_hint', context),
                  isShowBorder: true,
                  isPassword: true,
                  isShowSuffixIcon: true,
                  focusNode: _passwordFocus,
                  controller: _passwordController,
                  inputAction: TextInputAction.done,
                ),
                const SizedBox(height: 12),

                // for remember me section
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<AuthProvider_D>(
                        builder: (context, authProvider, child) => InkWell(
                          onTap: () {
                            authProvider.toggleRememberMe();
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                    color: authProvider.isActiveRememberMe ? Theme.of(context).primaryColor : Colors.white,
                                    border:
                                    Border.all(color: authProvider.isActiveRememberMe ? Colors.transparent : Colors.black),
                                    borderRadius: BorderRadius.circular(3)),
                                child: authProvider.isActiveRememberMe
                                    ? const Icon(Icons.done, color: Colors.white, size: 17)
                                    : const SizedBox.shrink(),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),
                              Text(
                                getTranslated('remember_me', context)!,
                                style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )),
                  ],
                ),

                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    authProvider.loginErrorMessage!.isNotEmpty
                        ? const CircleAvatar(backgroundColor: Colors.red, radius: 5)
                        : const SizedBox.shrink(),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authProvider.loginErrorMessage ?? "",
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                CustomButtonWidget_D(
                  isLoading: authProvider.isLoading,
                  btnTxt: getTranslated('login', context),
                  onTap: () async {

                    String email = _emailController!.text.trim();
                    String password = _passwordController!.text.trim();
                    if (email.isEmpty) {
                      showCustomSnackBar_D(getTranslated('enter_email_address', context)!);
                    }else if (EmailCheckerHelper.isNotValid(email)) {
                      showCustomSnackBar_D(getTranslated('enter_valid_email', context)!);
                    }else if (password.isEmpty) {
                      showCustomSnackBar_D(getTranslated('enter_password', context)!);
                    }else if (password.length < 8) {
                      showCustomSnackBar_D(getTranslated('password_should_be', context)!);
                    }else {
                      authProvider.login(emailAddress: email, password: password).then((status) async {
                        if (status.isSuccess) {
                          if (authProvider.isActiveRememberMe) {
                            authProvider.saveUserNumberAndPassword(email, password);
                          } else {
                            authProvider.clearUserEmailAndPassword();
                          }
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardScreen_D()));
                        }
                      });
                    }
                  },
                ),

                const SizedBox(height: 10),

                splashProvider.configModel_D!.toggleDmRegistration! ? TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(1, 40),
                  ),
                  onPressed: () async => await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DeliveryManRegistrationScreen_D()),
                  ),
                  child: RichText(text: TextSpan(children: [
                    TextSpan(text: '${getTranslated('join_as_a', context)} ', style: rubikRegular.copyWith(color: Colors.black54)),
                    TextSpan(text:getTranslated('delivery_man', context), style: rubikMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                  ])),
                ) : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    )));

  }
}
