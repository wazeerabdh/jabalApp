import 'package:country_code_picker/country_code_picker.dart';
import 'package:hexacom_user/common/enums/footer_type_enum.dart';
import 'package:hexacom_user/common/models/signup_model.dart';
import 'package:hexacom_user/features/auth/providers/registration_provider.dart';
import 'package:hexacom_user/features/auth/widgets/sign_up_logo_widget.dart';
import 'package:hexacom_user/helper/email_checker_helper.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/main.dart';
import 'package:hexacom_user/features/auth/providers/auth_provider.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/images.dart';
import 'package:hexacom_user/utill/routes.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:hexacom_user/common/widgets/custom_button_widget.dart';
import 'package:hexacom_user/common/widgets/custom_shadow_widget.dart';
import 'package:hexacom_user/helper/custom_snackbar_helper.dart';
import 'package:hexacom_user/common/widgets/custom_text_field_widget.dart';
import 'package:hexacom_user/common/widgets/footer_web_widget.dart';
import 'package:hexacom_user/common/widgets/web_app_bar_widget.dart';
import 'package:hexacom_user/features/auth/widgets/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _countryDialCode;

  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  double _maxScroll = 1;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
      _maxScroll = _scrollController.position.maxScrollExtent;
    });
  }

  @override
  void initState() {
    super.initState();

    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final RegistrationProvider registrationProvider =
        Provider.of<RegistrationProvider>(context, listen: false);

    _scrollController.addListener(_scrollListener);

    _numberFocus.addListener(() {
      setState(() {});
    });
    _passwordFocus.addListener(() {
      setState(() {});
    });

    authProvider.updateIsUpdateTernsStatus(value: false, isUpdate: false);
    registrationProvider.setErrorMessage = '';

    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .countryCode!)
        .dialCode;
  }

  @override
  void dispose() {
    super.dispose();

    _numberFocus.dispose();
    _passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config =
        Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? null
          : Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(90), child: WebAppBarWidget())
          : null,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                if (!ResponsiveHelper.isDesktop(context))
                  SliverAppBar(
                    elevation: 5,
                    backgroundColor: Theme.of(context).cardColor,
                    automaticallyImplyLeading: false,
                    pinned: true,
                    expandedHeight: innerBoxIsScrolled ? 100 : 160,
                    title: AnimatedOpacity(
                      opacity:
                          (_scrollPosition / _maxScroll).floor().toDouble(),
                      duration: const Duration(milliseconds: 500),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(Images.logo1, width: 40, height: 40),
                          const SizedBox(width: 10),
                          Text(
                            getTranslated('signup', context),
                            style: rubikBold.copyWith(
                                color: Theme.of(context).primaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    flexibleSpace: const FlexibleSpaceBar(
                      background: SignUpLogoWidget(),
                    ),
                  )
              ];
            },
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Center(
                        child: SizedBox(
                  width: Dimensions.webScreenWidth,
                  child: CustomShadowWidget(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context)
                          ? 300
                          : Dimensions.paddingSizeExtraLarge,
                      vertical: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.paddingSizeLarge
                          : 0,
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // for first name section

                        if (ResponsiveHelper.isDesktop(context))
                          const Center(child: SignUpLogoWidget()),

                        CustomTextFieldWidget(
                          prefixIconUrl: Images.profile,
                          isShowPrefixIcon: true,
                          hintText: getTranslated('first_name', context),
                          isShowBorder: true,
                          controller: _firstNameController,
                          focusNode: _firstNameFocus,
                          nextFocus: _lastNameFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        // for last name section

                        CustomTextFieldWidget(
                          hintText: getTranslated('last_name', context),
                          prefixIconUrl: Images.profile,
                          isShowBorder: true,
                          isShowPrefixIcon: true,
                          controller: _lastNameController,
                          focusNode: _lastNameFocus,
                          nextFocus: _numberFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        // for email section
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.radiusSizeDefault),
                            border: Border.all(
                              color: _numberFocus.hasFocus
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5)
                                  : Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(children: [
                            CodePickerWidget(
                              onChanged: (countryCode) {
                                _countryDialCode = countryCode.dialCode;
                              },
                              initialSelection: "YE",
                              favorite: [_countryDialCode!],
                              showDropDownButton: true,
                              padding: EdgeInsets.zero,
                              showFlagMain: true,
                              textStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color),
                            ),
                            Container(
                                width: 1,
                                height: Dimensions.paddingSizeExtraLarge,
                                color: Theme.of(context).dividerColor),
                            Expanded(
                                child: CustomTextFieldWidget(
                              borderColor: Colors.transparent,
                              hintText:
                                  getTranslated('enter_phone_number', context),
                              isShowBorder: true,
                              controller: _numberController,
                              focusNode: _numberFocus,
                              nextFocus: _emailFocus,
                              inputType: TextInputType.phone,
                            )),
                          ]),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        CustomTextFieldWidget(
                          hintText: getTranslated('email', context),
                          isShowBorder: true,
                          prefixIconData: Icons.email,
                          isShowPrefixIcon: true,
                          controller: _emailController,
                          focusNode: _emailFocus,
                          nextFocus: _passwordFocus,
                          inputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        // for password section,
                        CustomTextFieldWidget(
                          prefixIconData: Icons.lock,
                          hintText: getTranslated('password', context),
                          isShowBorder: true,
                          isPassword: true,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          nextFocus: _confirmPasswordFocus,
                          isShowSuffixIcon: true,
                          isShowPrefixIcon: true,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        // for confirm password section
                        CustomTextFieldWidget(
                          hintText: getTranslated('confirm_password', context),
                          isShowBorder: true,
                          isPassword: true,
                          prefixIconData: Icons.lock,
                          isShowPrefixIcon: true,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          isShowSuffixIcon: true,
                          inputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        Consumer<RegistrationProvider>(
                            builder: (context, registrationProvider, _) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              registrationProvider.errorMessage!.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                      radius: 5)
                                  : const SizedBox.shrink(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  registrationProvider.errorMessage ?? "",
                                  style: rubikMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              )
                            ],
                          );
                        }),

                        Row(children: [
                          InkWell(
                            onTap: () =>
                                authProvider.updateIsUpdateTernsStatus(),
                            child: Container(
                              width: Dimensions.paddingSizeLarge,
                              height: Dimensions.paddingSizeLarge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.3),
                                    width: 1),
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(
                                        authProvider.isAgreeTerms ? 0.2 : 0.02),
                              ),
                              child: authProvider.isAgreeTerms
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context).primaryColor,
                                      size: Dimensions.paddingSizeDefault,
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Text(getTranslated('i_agree_with_the', context)),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, Routes.getTermsRoute()),
                            child: Text(
                                getTranslated('terms_and_condition', context),
                                style: rubikRegular.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        // for signup button

                        Consumer<RegistrationProvider>(
                            builder: (context, registrationProvider, _) {
                          return CustomButtonWidget(
                            isLoading: registrationProvider.isLoading,
                            btnTxt: getTranslated('signup', context),
                            onTap: !authProvider.isAgreeTerms
                                ? null
                                : () {
                                    String firstName =
                                        _firstNameController.text.trim();
                                    String lastName =
                                        _lastNameController.text.trim();
                                    String number = _countryDialCode! +
                                        _numberController.text.trim();
                                    String email = _emailController.text.trim();
                                    String password =
                                        _passwordController.text.trim();
                                    String confirmPassword =
                                        _confirmPasswordController.text.trim();

                                    if (firstName.isEmpty) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_first_name', context),
                                          context);
                                    } else if (lastName.isEmpty) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_last_name', context),
                                          context);
                                    } else if (_numberController.text.isEmpty) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_phone_number', context),
                                          context);
                                    } else if (email.isEmpty) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_email_address', context),
                                          context);
                                    } else if (EmailCheckerHelper.isNotValid(
                                        email)) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_valid_email', context),
                                          context);
                                    } else if (password.isEmpty) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_password', context),
                                          context);
                                    } else if (password.length < 6) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'password_should_be', context),
                                          context);
                                    } else if (confirmPassword.isEmpty) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_confirm_password',
                                              context),
                                          context);
                                    } else if (password != confirmPassword) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'password_did_not_match',
                                              context),
                                          context);
                                    } else {
                                      SignUpModel signUpModel = SignUpModel(
                                        fName: firstName,
                                        lName: lastName,
                                        email: email,
                                        password: password,
                                        phone: number,
                                      );

                                      registrationProvider
                                          .registration(signUpModel, config)
                                          .then((status) async {
                                        if (status.isSuccess) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              Get.context!,
                                              Routes.getMainRoute(),
                                              (route) => false);
                                        } else if ((config.phoneVerification! ||
                                                config.emailVerification!) &&
                                            status.message == null) {
                                          Navigator.of(context).pushNamed(
                                            Routes.getVerifyRoute('sign-up',
                                                '${config.phoneVerification! ? signUpModel.phone : signUpModel.email}'),
                                          );
                                        }
                                      });
                                    }
                                  },
                          );
                        }),

                        // for already an account
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(getTranslated('already_have_account', context),
                                style: rubikRegular),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            InkWell(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, Routes.getLoginRoute()),
                              child: Text(getTranslated('login', context),
                                  style: rubikMedium.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Center(
                            child: Text(
                          getTranslated('or', context),
                          style: rubikRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                        )),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Center(
                            child: InkWell(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, Routes.getDashboardRoute('home')),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text:
                                    '${getTranslated('continue_as_a', context)}  ',
                                style: rubikRegular.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                )),
                            TextSpan(
                                text: getTranslated('guest', context),
                                style: rubikMedium.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline,
                                )),
                          ])),
                        )),
                      ],
                    ),
                  ),
                ))),
                const FooterWebWidget(footerType: FooterType.sliver),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
