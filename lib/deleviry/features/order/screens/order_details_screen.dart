import 'dart:math';


import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hexacom_user/deleviry/commons/providers/localization_provider.dart';
import 'package:hexacom_user/deleviry/commons/providers/location_provider.dart';
import 'package:hexacom_user/deleviry/commons/widgets/custom_button_widget.dart';
import 'package:hexacom_user/deleviry/commons/widgets/custom_image_widget.dart';
import 'package:hexacom_user/deleviry/features/auth/providers/auth_provider.dart';
import 'package:hexacom_user/deleviry/features/chat/screens/chat_screen.dart';
import 'package:hexacom_user/deleviry/features/order/domain/models/order_model.dart';
import 'package:hexacom_user/deleviry/features/order/domain/models/track_data_model.dart';
import 'package:hexacom_user/deleviry/features/order/providers/order_provider.dart';
import 'package:hexacom_user/deleviry/features/order/providers/tracker_provider.dart';
import 'package:hexacom_user/deleviry/features/order/screens/order_complete_screen.dart';
import 'package:hexacom_user/deleviry/features/order/widgets/custom_divider_widget.dart';
import 'package:hexacom_user/deleviry/features/order/widgets/delivery_dialog_widget.dart';
import 'package:hexacom_user/deleviry/features/order/widgets/slider_button_widget.dart';
import 'package:hexacom_user/deleviry/helper/date_converter_helper.dart';
import 'package:hexacom_user/deleviry/helper/map_helper.dart';
import 'package:hexacom_user/deleviry/helper/price_converter_helper.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/images.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../localization/language_constrants.dart';

class OrderDetailsScreen_D extends StatefulWidget {
  final OrderModel_D? orderModelItem;
  const OrderDetailsScreen_D({Key? key, this.orderModelItem}) : super(key: key);

  @override
  State<OrderDetailsScreen_D> createState() => _OrderDetailsScreen_DState();
}

class _OrderDetailsScreen_DState extends State<OrderDetailsScreen_D> {
  OrderModel_D? orderModel;
  double? deliveryCharge = 0;


  @override
  void initState() {
    orderModel = widget.orderModelItem;
    _loadData();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider_D>(context, listen: false).getOrderDetails(orderModel!.id.toString());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          getTranslated('order_details', context)!,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
        ),
      ),
      body: Consumer<OrderProvider_D>(
        builder: (context, order, child) {
          double itemsPrice = 0;
          double discount = 0;
          double tax = 0;
          if (order.orderDetails != null) {
            for (var orderDetails in order.orderDetails!) {
              itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
              discount = discount + (orderDetails.discountOnProduct! * orderDetails.quantity!);
              tax = tax + (orderDetails.taxAmount! * orderDetails.quantity!);
            }
          }
          double subTotal = itemsPrice + tax;
          double totalPrice = subTotal - discount + deliveryCharge!;
          if(orderModel!.couponDiscountAmount != null){
            totalPrice = totalPrice - orderModel!.couponDiscountAmount!;
          }

          return order.orderDetails != null && orderModel != null ? Column(children: [
            Expanded(child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              children: [
                Row(children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${getTranslated('order_id', context)}', style: rubikRegular),
                        Text(' # ${orderModel!.id}', style: rubikMedium),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.watch_later, size: 17),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                       if(orderModel != null && orderModel?.createdAt != null) Text(DateConverterHelper_D.isoStringToLocalDateOnly(orderModel!.createdAt!),
                            style: rubikRegular),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 5, spreadRadius: 1,
                    )],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTranslated('customer', context)!, style: rubikRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                    )),

                    ListTile(
                      leading: ClipOval(
                        child: CustomImageWidget_D(
                          placeholder: Images.placeholder2, height: 40, width: 40, fit: BoxFit.cover,
                          image: orderModel!.customer != null
                              ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${orderModel!.customer!.image ?? ''}' : '',
                        ),
                      ),
                      title: Text(
                        orderModel!.deliveryAddress == null
                            ? '' : orderModel!.deliveryAddress!.contactPersonName ?? '',
                        style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                      trailing: InkWell(
                        onTap:orderModel!.deliveryAddress != null ?  () async {
                          Uri uri = Uri.parse('tel:${orderModel!.deliveryAddress!.contactPersonNumber}');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Could not launch $uri';
                          }
                        } : null,
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.fontSizeLarge),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).shadowColor),
                          child:  Icon(Icons.call_outlined, color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 5, spreadRadius: 1,
                    )],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTranslated('delivery_details', context)!, style: rubikMedium),

                    ListTile(
                      horizontalTitleGap: Dimensions.paddingSizeExtraSmall,
                      minLeadingWidth: Dimensions.paddingSizeDefault,
                      leading: Icon(Icons.house, color: Theme.of(context).primaryColor),
                      title: Text(getTranslated('from', context)!),
                      subtitle: Text(orderModel!.branch?.address ?? ''),
                    ),
                    const Divider( height: 2),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    ListTile(
                      horizontalTitleGap: Dimensions.paddingSizeExtraSmall,
                      minLeadingWidth: Dimensions.paddingSizeDefault,
                      leading: Icon(Icons.location_on_outlined, color: Theme.of(context).primaryColor),
                      title: Text(getTranslated('to', context)!),
                      subtitle: orderModel!.deliveryAddress != null ?  Text(
                        '${orderModel!.deliveryAddress!.address!}\n${orderModel?.deliveryAddress?.floor != null ? '${getTranslated('floor', context)} - ${orderModel?.deliveryAddress?.floor},' : ''
                        } ${orderModel?.deliveryAddress?.road != null ? '${getTranslated('road', context)} - ${orderModel?.deliveryAddress?.road},' : ''
                        } ${orderModel?.deliveryAddress?.house != null ? '${getTranslated('house', context)} - ${orderModel?.deliveryAddress?.house}' : ''}'
                      ) : const SizedBox(),
                      isThreeLine: true,
                    ),
                  ]),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Text('${getTranslated('item', context)}:', style: rubikRegular),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(order.orderDetails!.length.toString(), style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                    ]),
                    orderModel!.orderStatus == 'processing' || orderModel!.orderStatus == 'out_for_delivery'
                        ? Row(children: [
                      Text('${getTranslated('payment_status', context)}:',
                          style: rubikRegular),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(getTranslated('${orderModel!.paymentStatus}', context)!,
                          style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                    ])
                        : const SizedBox.shrink(),
                  ],
                ),
                const Divider(height: 20),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.orderDetails!.length,
                  itemBuilder: (context, index) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder2,
                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${order.orderDetails![index].productDetails!.image![0]}',
                            height: 70, width: 80, fit: BoxFit.cover, imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder2, height: 70, width: 80, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    order.orderDetails![index].productDetails!.name!,
                                    style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall, ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeLarge),

                                Text(getTranslated('amount', context)!, style: rubikRegular),
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Row(
                                children: [
                                  Text('${getTranslated('quantity', context)}:',
                                      style: rubikRegular),
                                  Text(' ${order.orderDetails![index].quantity}',
                                      style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                                ],
                              ),
                              Text(
                                PriceConverterHelper_D.convertPrice(context, order.orderDetails![index].price),
                                style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                              ),
                            ]),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            order.orderDetails![index].variation!.isNotEmpty ?
                            Row(children: [
                              order.orderDetails![index].variation!.first.type != null ?
                              Container(height: 10, width: 10, decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).textTheme.bodyLarge!.color,
                              )) : const SizedBox.shrink(),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Text(order.orderDetails![index].variation!.first.type ?? '',
                                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                              ),
                            ]):const SizedBox() ,
                          ]),
                        ),
                      ]),
                      const Divider(height: 20),
                    ]);
                  },
                ),

                (orderModel!.orderNote != null && orderModel!.orderNote!.isNotEmpty) ? Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Theme.of(context).hintColor),
                  ),
                  child: Text(orderModel!.orderNote!, style: rubikRegular.copyWith(color: Theme.of(context).hintColor)),
                ) : const SizedBox(),

                // Total
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('items_price', context)!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  Text(PriceConverterHelper_D.convertPrice(context, itemsPrice), style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                ]),
                const SizedBox(height: 10),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('tax', context)!,
                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  Text('(+) ${PriceConverterHelper_D.convertPrice(context, tax)}',
                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                ]),
                const SizedBox(height: 10),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: CustomDividerWidget_D(),
                ),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('subtotal', context)!,
                      style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  Text(PriceConverterHelper_D.convertPrice(context, subTotal),
                      style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                ]),
                const SizedBox(height: 10),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('discount', context)!,
                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  Text('(-) ${PriceConverterHelper_D.convertPrice(context, discount)}',
                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                ]),
                const SizedBox(height: 10),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('coupon_discount', context)!,
                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  Text(
                    '(-) ${PriceConverterHelper_D.convertPrice(context, orderModel!.couponDiscountAmount)}',
                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),
                ]),
                const SizedBox(height: 10),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('delivery_fee', context)!,
                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  Text('(+) ${PriceConverterHelper_D.convertPrice(context, deliveryCharge)}',
                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                ]),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: CustomDividerWidget_D(),
                ),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('total_amount', context)!,
                      style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor)),
                  Text(
                    PriceConverterHelper_D.convertPrice(context, totalPrice),
                    style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor),
                  ),
                ]),
                const SizedBox(height: 30),
              ],
            )),

            orderModel!.orderStatus == 'processing' || orderModel!.orderStatus == 'out_for_delivery' ? Consumer<LocationProvider_D>(builder: (context, locationProvider, child) => Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CustomButtonWidget_D(
                btnTxt: getTranslated('direction', context),
                onTap: () {
                  MapHelper.openMap(
                      double.parse(orderModel!.deliveryAddress!.latitude!),
                      double.parse(orderModel!.deliveryAddress!.longitude!),
                      locationProvider.currentLocation.latitude,
                      locationProvider.currentLocation.longitude);
                },
              ),
            )) : const SizedBox.shrink(),

            orderModel!.orderStatus != 'delivered' ? Center(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomButtonWidget_D(btnTxt: getTranslated('chat_with_customer', context), onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen_D(orderModel: orderModel)));
                }),
              ),
            ) : const SizedBox(),

            orderModel!.orderStatus == 'processing' ? Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.05)),
                color: Theme.of(context).canvasColor,
              ),
              child: Transform.rotate(
                angle: Provider.of<LocalizationProvider_D>(context).isLtr ? pi * 2 : pi, // in radians
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: SliderButtonWidget_D(
                    action: () {
                      String token = Provider.of<AuthProvider_D>(context, listen: false).getUserToken();
                      Placemark address = Provider.of<LocationProvider_D>(context, listen: false).address;
                      TrackDataModel_D trackBody = TrackDataModel_D(
                          token: token,
                          latitude: Provider.of<LocationProvider_D>(context, listen: false).currentLocation.latitude,
                          longitude: Provider.of<LocationProvider_D>(context, listen: false).currentLocation.longitude,
                          location: '${address.name ?? ''}, ${address.subAdministrativeArea ?? ''}, ${address.isoCountryCode ?? ''}',
                          orderId: orderModel!.id.toString());
                      Provider.of<TrackerProvider_D>(context, listen: false).updateTrackStart(true);

                      Provider.of<TrackerProvider_D>(context, listen: false).addTrackData(trackBody: trackBody).then((value) {
                        Provider.of<OrderProvider_D>(context, listen: false)
                            .updateOrderStatus(token: token, orderId: orderModel!.id, status: 'out_for_delivery');
                        Provider.of<OrderProvider_D>(context, listen: false).getAllOrders();
                        Navigator.pop(context);
                      });
                    },

                    ///Put label over here
                    label: Text(
                      getTranslated('swip_to_deliver_order', context)!,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    dismissThresholds: 0.5,
                    icon: const Center(
                        child: Icon(
                          Icons.double_arrow_sharp,
                          color: Colors.white,
                          size: 20.0,
                          semanticLabel: 'Text to announce in accessibility modes',
                        )),

                    ///Change All the color and size from here.
                    radius: 10,
                    boxShadow: const BoxShadow(blurRadius: 0.0),
                    buttonColor: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    baseColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ) : orderModel!.orderStatus == 'out_for_delivery' ? Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.05)),
                color: Theme.of(context).canvasColor,
              ),
              child: Transform.rotate(
                angle: Provider.of<LocalizationProvider_D>(context).isLtr ? pi * 2 : pi, // in radians
                child: Directionality(
                  textDirection: TextDirection.ltr, // set it to rtl
                  child: SliderButtonWidget_D(
                    action: () {
                      String token = Provider.of<AuthProvider_D>(context, listen: false).getUserToken();

                      if (orderModel!.paymentStatus == 'paid') {
                        Provider.of<OrderProvider_D>(context, listen: false)
                            .updateOrderStatus(token: token, orderId: orderModel!.id, status: 'delivered');
                        Provider.of<TrackerProvider_D>(context, listen: false).updateTrackStart(false);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => OrderCompleteScreen_D(orderID: orderModel!.id.toString())));
                      } else {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                child: DeliveryDialogWidget_D(
                                  onTap: () {},
                                  totalPrice: totalPrice,
                                  orderModel: orderModel,
                                ),
                              );
                            });
                      }
                    },

                    ///Put label over here
                    label: Text(
                      getTranslated('swip_to_confirm_order', context)!,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    dismissThresholds: 0.5,
                    icon: const Center(
                        child: Icon(
                          Icons.double_arrow_sharp,
                          color: Colors.white,
                          size: 20.0,
                          semanticLabel: 'Text to announce in accessibility modes',
                        )),

                    ///Change All the color and size from here.
                    radius: 10,
                    boxShadow: const BoxShadow(blurRadius: 0.0),
                    buttonColor: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    baseColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ) : const SizedBox.shrink(),
          ]) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }


  void _loadData() {
    if(orderModel!.orderAmount == null) {
      Provider.of<OrderProvider_D>(context, listen: false).getOrderModel('${orderModel!.id}').then((OrderModel_D? value) {
        orderModel = value;
        if(orderModel!.orderType == 'delivery') {
          deliveryCharge = orderModel!.deliveryCharge;
        }
      }).then((value) {
        Provider.of<OrderProvider_D>(context, listen: false).getOrderDetails(orderModel!.id.toString());
      });
    }else{
      if(orderModel?.orderType == 'delivery') {
        deliveryCharge = orderModel?.deliveryCharge;
      }
      Provider.of<OrderProvider_D>(context, listen: false).getOrderDetails(orderModel!.id.toString());
    }
  }

}
