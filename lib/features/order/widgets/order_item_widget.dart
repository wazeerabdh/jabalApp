import 'package:souqexpress/common/models/cart_model.dart';
import 'package:souqexpress/common/models/order_model.dart';
import 'package:souqexpress/features/order/enums/order_status_enum.dart';
import 'package:souqexpress/helper/custom_snackbar_helper.dart';
import 'package:souqexpress/helper/date_converter_helper.dart';
import 'package:souqexpress/helper/responsive_helper.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/main.dart';
import 'package:souqexpress/provider/theme_provider.dart';
import 'package:souqexpress/utill/color_resources.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/routes.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:souqexpress/common/widgets/custom_button_widget.dart';
import 'package:souqexpress/features/order/screens/order_details_screen.dart';
import 'package:souqexpress/features/order/widgets/re_order_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';

class OrderItemWidget extends StatelessWidget {
  final List<OrderModel>? orderList;
  final int index;
  final bool isRunning;
  const OrderItemWidget({Key? key, required this.orderList, required this.index, required this.isRunning}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context,
              Routes.getOrderDetailsRoute(orderList![index].id),
              arguments: OrderDetailsScreen(orderModel: orderList![index], orderId: orderList![index].id),
            );
          },
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 300]!, spreadRadius: 1, blurRadius: 5)],
              borderRadius: BorderRadius.circular(15),
            ),
            child: IntrinsicHeight(
              child: ResponsiveHelper.isDesktop(context) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        
                Expanded(
                  child: Row(children: [
        
                    Text('${getTranslated('order_id', context)} :', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        
                    Text(orderList![index].id.toString(), style: rubikBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  ]),
                ),
        
                Expanded(
                  child: Row(children: [
        
                    Text('${getTranslated('date', context)}:' , style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        
                    Text(DateConverterHelper.isoStringToLocalDateOnly( orderList![index].createdAt!), style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
        
                  ]),
                ),
        
                Expanded(
                  child: Text(
                    '${orderList![index].totalQuantity} ${getTranslated( orderList![index].totalQuantity! > 1 ? 'items' : 'item', context)}',
                    style: rubikRegular.copyWith(color: ColorResources.colorGrey),
                  ),
                ),
        
        
                Expanded(child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: OrderStatus.pending.name == orderList![index].orderStatus ? ColorResources.colorBlue.withOpacity(0.08)
                            : OrderStatus.out_for_delivery.name == orderList![index].orderStatus ? ColorResources.getRatingColor(context).withOpacity(0.08)
                            : OrderStatus.canceled.name == orderList![index].orderStatus ? Theme.of(context).colorScheme.error.withOpacity(0.08) : ColorResources.colorGreen.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getTranslated(orderList![index].orderStatus, context),
                        style: rubikRegular.copyWith(color: OrderStatus.pending.name == orderList![index].orderStatus ? ColorResources.colorBlue
                            : OrderStatus.out_for_delivery.name == orderList![index].orderStatus ? ColorResources.getRatingColor(context)
                            : OrderStatus.canceled.name == orderList![index].orderStatus ? Theme.of(context).colorScheme.error : ColorResources.colorGreen),
                      ),
                    ),
                  ],
                )),
        
                Expanded(child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 40, width: 150, child: OrderItemButtonView(index: index, isRunning: isRunning, orderList: orderList)),
                  ],
                )),
        
              ]) : Row(children: [
        
                Flexible(
                  flex: 4,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        
                    Row(children: [
        
                      Text('${getTranslated('order_id', context)} :', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        
                      Text(orderList![index].id.toString(), style: rubikBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        
                    Text(
                      '${orderList![index].totalQuantity} ${getTranslated( orderList![index].totalQuantity! > 1 ? 'items' : 'item', context)}',
                      style: rubikRegular.copyWith(color: ColorResources.colorGrey),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
        
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: OrderStatus.pending.name == orderList![index].orderStatus ? ColorResources.colorBlue.withOpacity(0.08)
                            : OrderStatus.out_for_delivery.name == orderList![index].orderStatus ? ColorResources.getRatingColor(context).withOpacity(0.08)
                            : OrderStatus.canceled.name == orderList![index].orderStatus ? Theme.of(context).colorScheme.error.withOpacity(0.08) : ColorResources.colorGreen.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getTranslated(orderList![index].orderStatus, context),
                        style: rubikRegular.copyWith(color: OrderStatus.pending.name == orderList![index].orderStatus ? ColorResources.colorBlue
                            : OrderStatus.out_for_delivery.name == orderList![index].orderStatus ? ColorResources.getRatingColor(context)
                            : OrderStatus.canceled.name == orderList![index].orderStatus ? Theme.of(context).colorScheme.error : ColorResources.colorGreen),
                      ),
                    ),
        
                  ]),
                ),
        
                Flexible(
                  flex: 3,
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        
                      Text('${getTranslated('date', context)}:' , style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        
                      Text(DateConverterHelper.isoStringToLocalDateOnly( orderList![index].createdAt!), style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
        
                    ]),
        
                    orderList![index].orderType == 'pos'? const SizedBox(): SizedBox(
                      height: 40,
                      child: OrderItemButtonView(index: index, isRunning: isRunning, orderList: orderList),
                    ),
                  ]),
                ),
        
              ]),
            ),
          ),
        );
      }
    );
  }
}

class OrderItemButtonView extends StatelessWidget {
  const OrderItemButtonView({
    Key? key,
    required this.index,
    required this.isRunning,
    required this.orderList,
  }) : super(key: key);

  final int index;
  final bool isRunning;
  final List<OrderModel>? orderList;

  @override
  Widget build(BuildContext context) {

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        return CustomButtonWidget(
          isLoading: orderProvider.isLoading && index == orderProvider.getReOrderIndex,
          radius: Dimensions.radiusSizeFifty,
          btnTxt: getTranslated(isRunning  || orderList![index].orderType == 'pos' ? 'track_order' : 'reorder', context),
          style: rubikMedium.copyWith(color: Colors.white),
          onTap: () async {
            if(isRunning || orderList![index].orderType == 'pos') {
              Navigator.pushNamed(context, Routes.getOrderTrackingRoute(orderList![index].id));
            }else {

              if(!orderProvider.isLoading) {
                orderProvider.setReorderIndex = index;
                List<CartModel>? cartList =  await orderProvider.reorderProduct('${orderList![index].id}');

                if(cartList != null &&  cartList.isNotEmpty){
                  showDialog(context: Get.context!, builder: (context)=> const ReOrderDialogWidget());
                }else{
                  showCustomSnackBar(getTranslated('product_not_available', Get.context!), Get.context!);
                }
              }
            }
          },
        );
      }
    );
  }
}