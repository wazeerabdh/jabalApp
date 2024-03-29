import 'package:souqexpress/utill/routes.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:souqexpress/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter/material.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/features/onboarding/providers/onboarding_provider.dart';
import 'package:souqexpress/utill/color_resources.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/common/widgets/custom_button_widget.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false).initBoardingList(context);

    return CustomPopScopeWidget(
      child: Scaffold(
        body: Consumer<OnBoardingProvider>(
          builder: (context, onBoardingList, child) => onBoardingList.onBoardingList.isNotEmpty ? SafeArea(
<<<<<<< HEAD
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                Column(
                  children: [
                    SizedBox(height: 20,),
                    onBoardingList.selectedIndex != onBoardingList.onBoardingList.length-1 ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {
                              onBoardingList.toggleShowOnBoardingStatus();
                              Navigator.pushReplacementNamed(context, Routes.getWelcomeRoute());
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color:Color(0xFF562E9C),borderRadius: BorderRadius.circular(10) ),
                              child: Text(
                                  getTranslated('skip', context),
                                  style: TextStyle(color: Colors.white)
                              ),
                            )),
                      ),
                    ) : const SizedBox(),

                    SizedBox(
                      height: 180,width:160 ,
                      child: PageView.builder(
                        itemCount: onBoardingList.onBoardingList.length,
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(30),
                            child: Image.asset(onBoardingList.onBoardingList[index].imageUrl),
                          );
                        },
                        onPageChanged: (index) {
                          onBoardingList.changeSelectIndex(index);
                        },
                      ),
                    ),
=======
            child: Column(
              children: [
SizedBox(height: 20,),
                onBoardingList.selectedIndex != onBoardingList.onBoardingList.length-1 ? Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          onBoardingList.toggleShowOnBoardingStatus();
                          Navigator.pushReplacementNamed(context, Routes.getWelcomeRoute());
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(color:Color(0xFF562E9C),borderRadius: BorderRadius.circular(10) ),
                          child: Text(
                            getTranslated('skip', context),
                            style: TextStyle(color: Colors.white)
                          ),
                        )),
                  ),
                ) : const SizedBox(),

                SizedBox(
                  height: 230,width:160 ,
                  child: PageView.builder(
                    itemCount: onBoardingList.onBoardingList.length,
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(30),
                        child: Image.asset(onBoardingList.onBoardingList[index].imageUrl),
                      );
                    },
                    onPageChanged: (index) {
                      onBoardingList.changeSelectIndex(index);
                    },
                  ),
                ),

                Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
>>>>>>> 6c53e34d80390c8a7d59fed5efa8d67c686f3e0c
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _getIndexList(onBoardingList.onBoardingList.length).map((i) => Container(
                            width: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? 16 : 7,
                            height: 7,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              color: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? Theme.of(context).primaryColor : ColorResources.getGrayColor(context),
                              borderRadius: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? BorderRadius.circular(50) : BorderRadius.circular(25),
                            ),
                          )).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60, right: 60, top: 50, bottom: 22),
                          child: Text(
                            onBoardingList.selectedIndex == 0
                                ? onBoardingList.onBoardingList[0].title
                                : onBoardingList.selectedIndex == 1
                                    ? onBoardingList.onBoardingList[1].title
                                    : onBoardingList.onBoardingList[2].title,
                            style: rubikRegular.copyWith(fontSize: 24.0, color: Theme.of(context).textTheme.bodyLarge!.color),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: Text(
                            onBoardingList.selectedIndex == 0
                                ? onBoardingList.onBoardingList[0].description
                                : onBoardingList.selectedIndex == 1
                                    ? onBoardingList.onBoardingList[1].description
                                    : onBoardingList.onBoardingList[2].description,
                            style: rubikMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: ColorResources.getGrayColor(context),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
<<<<<<< HEAD

=======
                    Container(
                      padding: EdgeInsets.all(onBoardingList.selectedIndex == 2 ? 0 : 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          onBoardingList.selectedIndex == 0 || onBoardingList.selectedIndex == 2
                              ? const SizedBox.shrink()
                              : TextButton(
                                  onPressed: () {
                                    _pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.ease);
                                  },
                                  child: Container(                       padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(color:Color(0xFF562E9C),borderRadius: BorderRadius.circular(10) ),
                                    child: Text(
                                      getTranslated('previous', context),
                                        style: TextStyle(color: Colors.white)
                                    ),
                                  )),
                          onBoardingList.selectedIndex == 2
                              ? const SizedBox.shrink()
                              : TextButton(
                                  onPressed: () {
                                    _pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.ease);
                                  },
                                  child: Container(                       padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(color:Color(0xFF562E9C),borderRadius: BorderRadius.circular(10)),
                                    child: Text(
                                      getTranslated('next', context),
                                      style: TextStyle(color: Colors.white)
                                    ),
                                  )),
                        ],
                      ),
                    ),
>>>>>>> 6c53e34d80390c8a7d59fed5efa8d67c686f3e0c
                    onBoardingList.selectedIndex == 2
                        ? Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                            child: CustomButtonWidget(
                              btnTxt: getTranslated('lets_start', context),
                              onTap: () {
                                Navigator.pushReplacementNamed(context, Routes.getWelcomeRoute());
                              },
                            ))
                        : const SizedBox.shrink(),
                  ],
                ),
<<<<<<< HEAD
                Container(
                  padding: EdgeInsets.all(onBoardingList.selectedIndex == 2 ? 0 : 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      onBoardingList.selectedIndex == 0 || onBoardingList.selectedIndex == 2
                          ? const SizedBox.shrink()
                          : TextButton(
                          onPressed: () {
                            _pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.ease);
                          },
                          child: Container(                       padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(color:Color(0xFF562E9C),borderRadius: BorderRadius.circular(10) ),
                            child: Text(
                                getTranslated('previous', context),
                                style: TextStyle(color: Colors.white)
                            ),
                          )),
                      onBoardingList.selectedIndex == 2
                          ? const SizedBox.shrink()
                          : TextButton(
                          onPressed: () {
                            _pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.ease);
                          },
                          child: Container(                       padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(color:Color(0xFF562E9C),borderRadius: BorderRadius.circular(10)),
                            child: Text(
                                getTranslated('next', context),
                                style: TextStyle(color: Colors.white)
                            ),
                          )),
                    ],
                  ),
                ),
=======
>>>>>>> 6c53e34d80390c8a7d59fed5efa8d67c686f3e0c
              ],
            ),
          ) : const SizedBox(),
        ),
      ),
    );
  }
  List<int> _getIndexList(int length) {
    List<int> list = [];
    for(int i = 0; i < length; i++) {
      list.add(i);
    }
    return list;
  }
}


