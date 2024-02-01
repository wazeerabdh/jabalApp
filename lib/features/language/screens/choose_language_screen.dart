
import 'package:souqexpress/common/widgets/custom_pop_scope_widget.dart';
import 'package:souqexpress/common/widgets/language_select_widget.dart';
import 'package:souqexpress/features/language/widgets/language_select_button_widget.dart';
import 'package:souqexpress/features/language/widgets/search_language_widget.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/provider/language_provider.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseLanguageScreen extends StatefulWidget {
  final bool fromMenu;
  const ChooseLanguageScreen({Key? key, this.fromMenu = false}) : super(key: key);

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {

  @override
  Widget build(BuildContext context) {
    Provider.of<LanguageProvider>(context, listen: false).initializeAllLanguages(context);


    return CustomPopScopeWidget(child: Scaffold(body: SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: Container(
              width: Dimensions.webScreenWidth,
              padding: const EdgeInsets.symmetric(horizontal: 100).copyWith(
                top: Dimensions.paddingSizeLarge,
              ),
              child: Text(
               "اختر لغة التطبيق",
                style: rubikMedium.copyWith(fontSize: 18, color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
            ),
          ),
          // const SizedBox(height: 30),


          // Center(child: Container(
          //   width: Dimensions.webScreenWidth,
          //   padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge),
          //   child: const SearchLanguageWidget(),
          // )),
          const SizedBox(height: 30),

          Expanded(child: SingleChildScrollView(child: LanguageSelectWidget(fromMenu: widget.fromMenu))),

          LanguageSelectButtonWidget(fromMenu: widget.fromMenu),
        ],
      ),
    )));
  }
}





