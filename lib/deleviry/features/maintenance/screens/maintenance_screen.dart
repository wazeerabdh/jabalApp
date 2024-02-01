
import 'package:flutter/material.dart';

import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/images.dart';


class MaintenanceScreen_D extends StatelessWidget {
  const MaintenanceScreen_D({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingSize = MediaQuery.of(context).size.height * 0.025;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(paddingSize),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

            Image.asset(Images.maintenance, width: 200, height: 200),

            Text(getTranslated('maintenance_mode', context)!,style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(
              getTranslated('maintenance_text', context)!,
              textAlign: TextAlign.center,

            ),

          ]),
        ),
      ),
    );
  }
}
