import 'package:souqexpress/helper/responsive_helper.dart';
import 'package:souqexpress/main.dart';
import 'package:souqexpress/common/widgets/web_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/styles.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final bool onlyDesktop;
  final Function? onBackPressed;
  final double space;
  const CustomAppBarWidget({Key? key, this.title, this.isBackButtonExist = true, this.onBackPressed, this.onlyDesktop = false, this.space = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? const WebAppBarWidget() : onlyDesktop ? SizedBox(height: space) : AppBar(
      title: title == null ? null : Text(title!, style: TextStyle(
        fontSize: Dimensions.fontSizeLarge,fontFamily: "Tajawal",
        color: Colors.white,
      )),
      centerTitle: true,elevation: 0,
      leading: isBackButtonExist ? IconButton(
        icon: const Icon(Icons.arrow_back_ios,size: 18),
        color: Colors.white,
        onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
      ) : const SizedBox(),
      backgroundColor: Theme.of(context).primaryColor,

    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, ResponsiveHelper.isDesktop(Get.context!) ? 90 : 50);
}
