import 'package:hexacom_user/common/models/config_model.dart';
import 'package:hexacom_user/features/checkout/providers/checkout_provider.dart';
import 'package:hexacom_user/helper/checkout_helper.dart';
import 'package:hexacom_user/helper/price_converter_helper.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:hexacom_user/common/widgets/custom_button_widget.dart';
import 'package:hexacom_user/common/widgets/custom_directionality_widget.dart';
import 'package:hexacom_user/features/checkout/widgets/custom_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryFeeDialogWidget extends StatelessWidget {
  final double amount;
  final double distance;
  final bool freeDelivery;
  final Function(double amount)? callBack;
  const DeliveryFeeDialogWidget({Key? key, required this.amount, required this.distance, required this.freeDelivery, this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Consumer<CheckoutProvider>(builder: (context, checkoutProvider, child) {
      double deliveryCharge = CheckOutHelper.getDeliveryCharge(
        orderAmount: amount, distance: distance,
        discount: checkoutProvider.getCheckOutData?.placeOrderDiscount ?? 0,
        configModel: configModel,
        freeDeliveryType: checkoutProvider.getCheckOutData?.freeDeliveryType,
      );

      callBack!(deliveryCharge);

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.width*0.4 : MediaQuery.of(context).size.width ,
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Container(
              height: 70, width: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delivery_dining,
                color: Theme.of(context).primaryColor, size: 50,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Column(children: [
              Text(
                '${getTranslated('delivery_fee_from_your_selected_address_to_branch', context)}:',
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              CustomDirectionalityWidget(child: Text(
                PriceConverterHelper.convertPrice(deliveryCharge),
                style: rubikBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
              )),

              const SizedBox(height: 20),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(getTranslated('subtotal', context), style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                CustomDirectionalityWidget(child: Text(
                  PriceConverterHelper.convertPrice(amount),
                  style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                )),
              ]),
              const SizedBox(height: 10),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  getTranslated('delivery_fee', context),
                  style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),

                CustomDirectionalityWidget(child: Text(
                  freeDelivery ? getTranslated('free', context):
                  '(+) ${PriceConverterHelper.convertPrice(deliveryCharge)}',
                  style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                )),
              ]),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: CustomDividerWidget(),
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(getTranslated('total_amount', context), style: rubikMedium.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor,
                )),

                CustomDirectionalityWidget(child: Text(
                  PriceConverterHelper.convertPrice(amount + deliveryCharge),
                  style: rubikMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    color: Theme.of(context).primaryColor,
                  ),
                )),
              ]),
            ]),
            const SizedBox(height: 30),

            CustomButtonWidget(btnTxt: getTranslated('ok', context), onTap: () {
              Navigator.pop(context);
            }),

          ]),
        ),
      );
    });
  }
}
