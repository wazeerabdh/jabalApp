import 'package:flutter/material.dart';
import 'package:souqexpress/deleviry/commons/widgets/custom_button_widget.dart';
import 'package:souqexpress/deleviry/features/dashboard/screens/dashboard_screen.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/images.dart';

class OrderCompleteScreen_D extends StatelessWidget {
  final String? orderID;

  const OrderCompleteScreen_D({Key? key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:   EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.doneWithFullBackground,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                getTranslated('order_successfully_delivered', context)!,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated('order_id', context)!,
                    style: Theme.of(context).textTheme.displayMedium!,
                  ),
                  Text(
                    ' #$orderID',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CustomButtonWidget_D(
                btnTxt: getTranslated('back_home', context),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashboardScreen_D()), (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
