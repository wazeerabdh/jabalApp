import 'package:souqexpress/common/widgets/custom_button_widget.dart';
import 'package:souqexpress/features/checkout/providers/checkout_provider.dart';
import 'package:souqexpress/features/coupon/providers/coupon_provider.dart';
import 'package:souqexpress/features/splash/providers/splash_provider.dart';
import 'package:souqexpress/helper/custom_snackbar_helper.dart';
import 'package:souqexpress/helper/price_converter_helper.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonViewWidget extends StatelessWidget {
  final double itemPrice;
  final double total;
  final double deliveryCharge;
  final double discount;

  const ButtonViewWidget({
    Key? key, required this.itemPrice,
    required this.total,
    required this.deliveryCharge,
    required this.discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final CouponProvider couponProvider = Provider.of<CouponProvider>(context, listen: false);

    return Container(
      width: Dimensions.webScreenWidth,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: CustomButtonWidget(
          btnTxt: getTranslated('proceed_to_checkout', context), onTap: () {
        if(itemPrice < Provider.of<SplashProvider>(context, listen: false).configModel!.minimumOrderValue!) {
          showCustomSnackBar('Minimum order amount is ${PriceConverterHelper.convertPrice(Provider.of<SplashProvider>(context, listen: false).configModel!.minimumOrderValue)}, you have ${PriceConverterHelper.convertPrice(itemPrice)} in your cart, please add more item.', context);
        } else {
          Navigator.pushNamed(context, Routes.getCheckoutRoute(
            amount: total,
            deliveryCharge: deliveryCharge,
            type: checkoutProvider.orderType,
            discount: discount,
            code: couponProvider.coupon?.code,
            fromCart: true,
          ));
        }
      }),
    );
  }
}
