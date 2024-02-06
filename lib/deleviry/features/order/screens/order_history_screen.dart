
import 'package:flutter/material.dart';
import 'package:souqexpress/deleviry/features/order/providers/order_provider.dart';
import 'package:souqexpress/deleviry/features/order/screens/order_details_screen.dart';
import 'package:souqexpress/deleviry/helper/date_converter_helper.dart';
import 'package:souqexpress/deleviry/helper/price_converter_helper.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:provider/provider.dart';

import '../../../../features/order/screens/order_details_screen.dart';

class OrderHistoryScreen_D extends StatefulWidget {

  const OrderHistoryScreen_D({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen_D> createState() => _OrderHistoryScreen_DState();
}

class _OrderHistoryScreen_DState extends State<OrderHistoryScreen_D> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    Provider.of<OrderProvider_D>(context, listen: false).getOrderHistory();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          getTranslated('order_history', context)!,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      body: Consumer<OrderProvider_D>(
        builder: (context, order, child) => order.allOrderHistory != null ? order.allOrderHistory!.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () => order.refresh(),
                displacement: 20,
                color: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                key: _refreshIndicatorKey,
                child: order.allOrderHistory!.isNotEmpty
                    ? ListView.builder(
                        itemCount: order.allOrderHistory!.length,
                        padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
                        itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) => OrderDetailsScreen_D(orderModelItem: order.allOrderHistory![index])));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context).shadowColor.withOpacity(.5), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                    Expanded(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${getTranslated('order_id', context)} #${order.allOrderHistory![index].id}',
                                                style:
                                                    rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(getTranslated('amount', context)!, style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                                          ],
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Row(
                                            children: [
                                              Text(getTranslated('status', context)!,
                                                  style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                                              Text(getTranslated('${order.allOrderHistory![index].orderStatus}', context)!,
                                                  style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                                            ],
                                          ),
                                          Text(PriceConverterHelper_D.convertPrice(context, order.allOrderHistory![index].orderAmount),
                                              style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                                        ]),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),
                                        Row(children: [
                                          Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).textTheme.bodyLarge!.color)),
                                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                          Text(
                                            '${getTranslated('order_at', context)}${DateConverterHelper_D.isoStringToLocalDateOnly(order.allOrderHistory![index].updatedAt!)}',
                                            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                                          ),
                                        ]),
                                      ]),
                                    ),
                                  ]),
                                ]),
                              ),
                            ))
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 130),
                          child: Text(
                            getTranslated('no_data_found', context)!,
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
              ) : Center(child: Text(
          getTranslated('no_history_available', context)!,
          style: Theme.of(context).textTheme.displaySmall,
        )) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
      ),
    );
  }
}
