
import 'package:souqexpress/common/models/order_model.dart';
import 'package:souqexpress/features/chat/providers/chat_provider.dart';
import 'package:souqexpress/features/chat/screens/chat_screen.dart';
import 'package:souqexpress/features/home/screens/home_screen.dart';
import 'package:souqexpress/features/order/screens/order_screen.dart';
import 'package:souqexpress/helper/cart_helper.dart';
import 'package:souqexpress/helper/network_info_helper.dart';
import 'package:souqexpress/helper/responsive_helper.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/main.dart';
import 'package:souqexpress/features/cart/providers/cart_provider.dart';
import 'package:souqexpress/features/splash/providers/splash_provider.dart';
import 'package:souqexpress/features/wishlist/providers/wishlist_provider.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/images.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:souqexpress/common/widgets/custom_pop_scope_widget.dart';
import 'package:souqexpress/common/widgets/third_party_chat_widget.dart';
import 'package:souqexpress/features/cart/screens/cart_screen.dart';
import 'package:souqexpress/features/menu/screens/menu_screen.dart';
import 'package:souqexpress/features/wishlist/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({Key? key, required this.pageIndex}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();


  @override
  void initState() {
    super.initState();

    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    if (splashProvider.policyModel == null) {
      Provider.of<SplashProvider>(context, listen: false).getPolicyPage();
    }
    HomeScreen.loadData(Get.context!, false);

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const ChatScreen(orderModel: null),
      const OrderScreen(shoo: false),
      const WishListScreen(),
      const MenuScreen(),
    ];

    if (ResponsiveHelper.isMobilePhone()) {
      NetworkInfoHelper.checkConnectivity(_scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        floatingActionButton: !ResponsiveHelper.isDesktop(context) &&
            _pageIndex == 0
            ? const ThirdPartyChatWidget()
            : const SizedBox(),
        bottomNavigationBar: !ResponsiveHelper.isDesktop(context)
            ? BottomAppBar(
          notchMargin: 0,elevation: 0,padding: EdgeInsets.all(0),
            // إزالة الظل هنا
          height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _barItem(Images.homeImage, getTranslated('home', context), 0),
                  _barItem(
                      Images.messageImage, getTranslated('live_chat', context), 1),
                  _barItem(
                      Images.shoppingImage, getTranslated('myorders', context),
                      2),
                  _barItem(
                      Images.favourite, getTranslated('favourite', context),
                      3),
                  _barItem(Images.moreImage, getTranslated('menu', context), 4),
                ],
              ),
            )
            : const SizedBox(),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomAppBar _barItem(String icon, String? label, int index) {
    bool isPressed = false; // حالة للإشارة إلى ما إذا تم الضغط على الأيقونة أم لا

    return BottomAppBar(    elevation: 0, // إزالة الظل هنا
 padding: EdgeInsets.symmetric(horizontal: 2),
      child: Consumer<WishListProvider>(
        builder: (context, wishListProvider, _) {
          return GestureDetector(
            onTap: () {
              _setPage(index);
            },
            onTapDown: (_) {
              setState(() {
                isPressed = true; // تم الضغط
              });
            },
            onTapUp: (_) {
              setState(() {
                isPressed = false; // تم رفع الإصبع بعد الضغط
              });
            },
            child: Column(
              children: [
SizedBox(height: 4,),
                Image.asset(
                  icon,
                  color: index == _pageIndex
                      ? Theme
                      .of(context)
                      .primaryColor
                      : isPressed
                      ? Theme
                      .of(context)
                      .primaryColor
                      :Colors.grey,
                  height: 20,
                  width: 20,
                ),
                SizedBox(height: 2,),
                Text(
                  label!,
                  style: TextStyle(
                    color: index == _pageIndex
                        ? Theme
                        .of(context)
                        .primaryColor
                        : isPressed
                        ? Theme
                        .of(context)
                        .primaryColor
                        : Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

}
