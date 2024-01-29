// ignore_for_file: deprecated_member_use


import 'package:flutter/material.dart';
import 'package:hexacom_user/deleviry/commons/providers/location_provider.dart';
import 'package:hexacom_user/deleviry/features/home/screens/home_screen.dart';
import 'package:hexacom_user/deleviry/features/order/providers/order_provider.dart';
import 'package:hexacom_user/deleviry/features/order/screens/order_history_screen.dart';
import 'package:hexacom_user/deleviry/features/profile/providers/profile_provider.dart';
import 'package:hexacom_user/deleviry/features/profile/screens/profile_screen.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:provider/provider.dart';

class DashboardScreen_D extends StatefulWidget {
  const DashboardScreen_D({Key? key}) : super(key: key);

  @override
  State<DashboardScreen_D> createState() => _DashboardScreen_DState();
}

class _DashboardScreen_DState extends State<DashboardScreen_D> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  late List<Widget> _screens;


  @override
  void initState() {
    super.initState();

    Provider.of<OrderProvider_D>(context, listen: false).getAllOrders();
    Provider.of<ProfileProvider_D>(context, listen: false).getUserInfo();
    Provider.of<LocationProvider_D>(context, listen: false).getUserLocation();

    _screens = [
      const HomeScreen_D(),
      const OrderHistoryScreen_D(),
      const ProfileScreen_D(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).hintColor,
          backgroundColor: Theme.of(context).cardColor,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            _getBarItem(Icons.home, getTranslated('home', context), 0),
            _getBarItem(Icons.history, getTranslated('order_history', context), 1),
            _getBarItem(Icons.person, getTranslated('profile', context), 2),
          ],
          onTap: (int index) {
            _setPage(index);
          },
        ),
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

  BottomNavigationBarItem _getBarItem(IconData icon, String? label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: index == _pageIndex ? Theme.of(context).primaryColor : Theme.of(context).hintColor, size: 20),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
