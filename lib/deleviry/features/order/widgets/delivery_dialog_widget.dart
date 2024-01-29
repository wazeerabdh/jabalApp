
import 'package:flutter/material.dart';
import 'package:hexacom_user/deleviry/commons/widgets/custom_button_widget.dart';
import 'package:hexacom_user/deleviry/features/auth/providers/auth_provider.dart';
import 'package:hexacom_user/deleviry/features/order/domain/models/order_model.dart';
import 'package:hexacom_user/deleviry/features/order/providers/order_provider.dart';
import 'package:hexacom_user/deleviry/features/order/providers/tracker_provider.dart';
import 'package:hexacom_user/deleviry/features/order/screens/order_complete_screen.dart';
import 'package:hexacom_user/deleviry/features/order/screens/order_details_screen.dart';
import 'package:hexacom_user/deleviry/helper/price_converter_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/images.dart';
import 'package:hexacom_user/utill/styles.dart';

import 'package:provider/provider.dart';

class DeliveryDialogWidget_D extends StatelessWidget {
  final Function onTap;
  final OrderModel_D? orderModel;

  final double? totalPrice;

  const DeliveryDialogWidget_D({Key? key, required this.onTap, this.totalPrice, this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            border: Border.all(color: Theme.of(context).primaryColor, width: 0.2)),
        child: Stack(
          clipBehavior: Clip.none, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(Images.money),
              const SizedBox(height: 20),
              Center(
                  child: Text(
                    getTranslated('do_you_collect_money', context)!,
                    style: rubikRegular,
                  )),
              const SizedBox(height: 20),
              Center(
                  child: Text(
                    PriceConverterHelper_D.convertPrice(context, totalPrice),
                    style: rubikMedium.copyWith(color: Theme.of(context).primaryColor,fontSize: 30),
                  )),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: CustomButtonWidget_D(
                        btnTxt: getTranslated('no', context),
                        isShowBorder: true,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderDetailsScreen_D(orderModelItem: orderModel,)));
                        },
                      )),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Expanded(
                      child: Consumer<OrderProvider_D>(
                        builder: (context, order, child) {
                          return !order.isLoading ? CustomButtonWidget_D(
                            btnTxt: getTranslated('yes', context),
                            onTap: () {
                              Provider.of<TrackerProvider_D>(context, listen: false).updateTrackStart(false);
                              Provider.of<OrderProvider_D>(context, listen: false).updateOrderStatus(
                                  token: Provider.of<AuthProvider_D>(context, listen: false).getUserToken(),
                                  orderId: orderModel!.id,
                                  status: 'delivered').then((value) {
                                if (value!.isSuccess) {
                                  order.updatePaymentStatus(
                                      token: Provider.of<AuthProvider_D>(context, listen: false).getUserToken(), orderId: orderModel!.id, status: 'paid');
                                  Provider.of<OrderProvider_D>(context, listen: false).getAllOrders();
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(builder: (_) => OrderCompleteScreen_D(orderID: orderModel!.id.toString())));
                                }
                              });
                            },
                          ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                        },
                      )),
                ],
              ),
            ],
          ),
          Positioned(
            right: -20,
            top: -20,
            child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.clear, size: Dimensions.paddingSizeLarge),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderDetailsScreen_D(orderModelItem: orderModel)));
                }),
          ),
        ],
        ),
      ),
    );
  }
}

