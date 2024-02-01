import 'package:souqexpress/common/widgets/cart_count_widget.dart';
import 'package:souqexpress/common/widgets/custom_asset_image_widget.dart';
import 'package:souqexpress/features/cart/providers/cart_provider.dart';
import 'package:souqexpress/features/cart/screens/cart_screen.dart';
import 'package:souqexpress/features/notification/providers/notification_provider.dart';
import 'package:souqexpress/features/notification/screens/notification_screen.dart';
import 'package:souqexpress/features/splash/providers/splash_provider.dart';
import 'package:souqexpress/helper/cart_helper.dart';
import 'package:souqexpress/helper/responsive_helper.dart';
import 'package:souqexpress/utill/app_constants.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/images.dart';
import 'package:souqexpress/utill/routes.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({
    Key? key,
    required this.drawerGlobalKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> drawerGlobalKey;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).cardColor,
      pinned: ResponsiveHelper.isTab(context) ? true : false,
      leading: ResponsiveHelper.isTab(context) ? IconButton(
        onPressed: () => drawerGlobalKey.currentState!.openDrawer(),
        icon: const Icon(Icons.menu,color: Colors.black),
      ): null,
      title: Consumer<SplashProvider>(builder:(context, splash, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CustomAssetImageWidget(Images.logocir, width: 45, height: 45),
          const SizedBox(width: 10),

          Expanded(
            child: Text(AppConstants.appName,
              style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      )),
      actions: [

        InkWell(
          borderRadius: BorderRadius.circular(50),
          hoverColor: Colors.transparent,
          onTap: () => Navigator.pushNamed(context, Routes.getCouponRoute()),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              shape: BoxShape.circle,
            ),

            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(Images.coupon, height: 16, width: 16),
            ),
          ),
        ),
        const SizedBox(width: 5),
        ResponsiveHelper.isWeb()?   IconButton(
          onPressed: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
          icon: Icon(Icons.notifications, color: Theme.of(context).focusColor, size: 30),
        ):Text("data"),
        ResponsiveHelper.isMobile(context)? Row(
          children: [
            Consumer<NotificationProvider>(
                builder: (context, notificationProvider, _) {
                  return IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
                    icon: Stack(clipBehavior: Clip.none, children: [
                      Image.asset(Images.notification,
                          height: 25,
                          width: 25,
                          color: const Color(0xFF562E9C)),
                      Positioned(top: -5, right: -5,
                        child: CircleAvatar(radius: 8, backgroundColor: const Color(0xFF562E9C),
                          child: Text(notificationProvider.notificationList.toString() ,
                              style: const TextStyle(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall,
                              )),
                        ),
                      ),

                    ]),
                  );
                }
            ),

            Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                icon: Stack(clipBehavior: Clip.none, children: [
                  Image.asset(Images.cartArrowDownImage,
                      height: 25,
                      width: 25,
                      color: const Color(0xFF562E9C)),
                  Positioned(top: -4, right: -4,
                    child: Consumer<CartProvider>(builder: (context, cart, child) {
                      return CircleAvatar(radius: 7, backgroundColor: const Color(0xFF562E9C),
                        child: Text(cart.cartList.length.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall,
                            )),
                      );
                    }),
                  ),
                ]),
              ),
            ),
          ],
        ):Text(""),
        if(ResponsiveHelper.isTab(context))IconButton(
          onPressed: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
          icon: Consumer<CartProvider>(builder: (context, cartProvider, _)=> CartCountWidget(
            count: CartHelper.getCartItemCount(cartProvider.cartList), icon: Icons.shopping_cart,
          )),
        ),
      ],
    );
  }
}
