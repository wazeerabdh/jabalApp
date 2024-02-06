import 'package:souqexpress/helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/styles.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final Function? onTap;
  final Widget? leadingButton;

  const TitleWidget({Key? key, required this.title, this.onTap, this.leadingButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title!, style: ResponsiveHelper.isDesktop(context) ? rubikMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge) : rubikMedium),

      leadingButton != null ? leadingButton! :  onTap != null ? InkWell(
        onTap: onTap as void Function()?,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Text(
            getTranslated('view_all', context),
            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          ),
        ),
      ) : const SizedBox(),
    ]);
  }
}
