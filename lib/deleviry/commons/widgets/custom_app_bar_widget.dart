
import 'package:flutter/material.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/styles.dart';

class CustomAppBarWidget_D extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  const CustomAppBarWidget_D({Key? key, required this.title, this.isBackButtonExist = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color)),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyLarge!.color),
        onPressed: () => Navigator.pop(context),
      ) : const SizedBox(),
      elevation: 0,
      backgroundColor: Theme.of(context).cardColor,
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}
