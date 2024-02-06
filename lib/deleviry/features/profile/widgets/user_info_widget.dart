
import 'package:flutter/material.dart';

import '../../../../utill/dimensions.dart';

class UserInfoWidget_D extends StatelessWidget {
  final String? text;
  const UserInfoWidget_D({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        color: Theme.of(context).canvasColor,
        border: Border.all(color: const Color(0xFFDCDCDC)),
      ),
      child: Text(
        text ?? '',
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
