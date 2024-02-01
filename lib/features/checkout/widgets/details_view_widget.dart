import 'package:souqexpress/common/models/cart_model.dart';
import 'package:souqexpress/common/widgets/custom_directionality_widget.dart';
import 'package:souqexpress/common/widgets/custom_shadow_widget.dart';
import 'package:souqexpress/common/widgets/custom_text_field_widget.dart';
import 'package:souqexpress/features/cart/widgets/cart_item_widget.dart';
import 'package:souqexpress/features/checkout/providers/checkout_provider.dart';
import 'package:souqexpress/features/checkout/widgets/payment_info_widget.dart';
import 'package:souqexpress/features/checkout/widgets/place_order_button_view.dart';
import 'package:souqexpress/helper/price_converter_helper.dart';
import 'package:souqexpress/helper/responsive_helper.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsViewWidget extends StatelessWidget {
  final bool kmWiseCharge;
  final bool selfPickup;
  final double deliveryCharge;
  final double amount;
  final TextEditingController orderNoteController;
  final List<CartModel?> cartList;
  final String? orderType;



  const DetailsViewWidget({
    Key? key, required this.kmWiseCharge,
    required this.selfPickup,
    required this.deliveryCharge,
    required this.orderNoteController,
    required this.amount, required this.cartList, required this.orderType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const PaymentInfoWidget(),

        CustomShadowWidget(
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(getTranslated('add_delivery_note', context), style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            CustomTextFieldWidget(
              fillColor: Theme.of(context).canvasColor,
              isShowBorder: true,
              controller: orderNoteController,
              hintText: getTranslated('type', context),
              maxLines: 5,
              inputType: TextInputType.multiline,
              inputAction: TextInputAction.newline,
              capitalization: TextCapitalization.sentences,
            ),
          ]),
        ),

        CustomShadowWidget(
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Column(children: [
              CartItemWidget(
                title: getTranslated('subtotal', context),
                subTitle: PriceConverterHelper.convertPrice(amount),
                style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: 10),


              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  getTranslated('delivery_fee', context),
                  style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),

                Consumer<CheckoutProvider>(
                    builder: (context, checkoutProvider, _) {
                      return (selfPickup || checkoutProvider.distance != -1 || !kmWiseCharge) ? CustomDirectionalityWidget(
                        child: Text(
                          '(+) ${PriceConverterHelper.convertPrice(selfPickup ? 0 : deliveryCharge)}',

                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ),
                      ) :
                      Text(
                        getTranslated('not_found', context),
                        style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                      );
                    }
                ),
              ]),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Divider(),
              ),

              CartItemWidget(
                title: getTranslated('total_amount', context),
                subTitle: PriceConverterHelper.convertPrice(amount + deliveryCharge),
                style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
              ),

              if(ResponsiveHelper.isDesktop(context)) const SizedBox(height: Dimensions.paddingSizeDefault),


              if(ResponsiveHelper.isDesktop(context))  PlaceOrderButtonView(
                amount: amount, deliveryCharge: deliveryCharge,
                orderType: orderType,
                kmWiseCharge: kmWiseCharge,
                cartList: cartList,
                orderNote: orderNoteController.text,
              )

            ]),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),


      ],
    );
  }
}
