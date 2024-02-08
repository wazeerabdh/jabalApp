import 'package:souqexpress/common/widgets/title_widget.dart';
import 'package:souqexpress/features/category/providers/category_provider.dart';
import 'package:souqexpress/features/home/widgets/categories_web_widget.dart';
import 'package:souqexpress/features/home/widgets/category_shimmer_widget.dart';
import 'package:souqexpress/helper/responsive_helper.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/images.dart';
import 'package:souqexpress/utill/routes.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return (category.categoryList == null ||
                (category.categoryList != null &&
                    category.categoryList!.isNotEmpty))
            ? Column(
                children: [
                  ResponsiveHelper.isDesktop(context)
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeExtraLarge,
                              bottom: Dimensions.paddingSizeLarge),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                getTranslated('all_categories', context),
                                style: rubikMedium.copyWith(
                                    fontSize: Dimensions.fontSizeOverLarge)),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: TitleWidget(
                            title: getTranslated('all_categories', context),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.getCategoryAllRoute());
                            },
                          ),
                        ),
                  ResponsiveHelper.isDesktop(context)
                      ? const CategoriesWebWidget()
                      : Row(children: [
                          Expanded(
                            child: SizedBox(
                              height: 90,
                              child: category.categoryList != null
                                  ? category.categoryList!.isNotEmpty
                                      ? ListView.builder(
                                          itemCount:
                                              category.categoryList!.length,
                                          padding: const EdgeInsets.only(
                                              left:
                                                  Dimensions.paddingSizeSmall),
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: Dimensions
                                                      .paddingSizeSmall),
                                              child: InkWell(
                                                onTap: () =>
                                                    Navigator.pushNamed(
                                                        context,
                                                        Routes.getCategoryRoute(
                                                          category.categoryList![
                                                              index],
                                                        )),
                                                child: Column(children: [
                                                  Container(
                                                    width: 65,
                                                    height: 65,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            width: .5,
                                                            color: Theme.of(
                                                                    context)
                                                                .dividerColor)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        placeholder:
                                                            Images.placeholder(
                                                                context),
                                                        image:
                                                            '${category.categoryList![index].image}',
                                                        width: 65,
                                                        height: 65,
                                                        fit: BoxFit.cover,
                                                        imageErrorBuilder:
                                                            (c, o, t) =>
                                                                Image.asset(
                                                          Images.placeholder(
                                                              context),
                                                          width: 65,
                                                          height: 65,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  SizedBox(
                                                    width: 60,
                                                    child: Center(
                                                      child: Text(
                                                        category
                                                            .categoryList![
                                                                index]
                                                            .name!,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: Text(getTranslated(
                                              'no_category_available',
                                              context)))
                                  : const CategoryShimmerWidget(),
                            ),
                          ),
                        ]),
                ],
              )
            : const SizedBox();
=======

    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return (category.categoryList == null || (category.categoryList != null && category.categoryList!.isNotEmpty)) ? Column(
          children: [

            ResponsiveHelper.isDesktop(context) ?
            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge,bottom: Dimensions.paddingSizeLarge),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(getTranslated('all_categories', context), style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
              ),
            ) : Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TitleWidget(
                title: getTranslated('all_categories', context),
                onTap: () {
                  Navigator.pushNamed(context, Routes.getCategoryAllRoute());
                },
              ),
            ),
            ResponsiveHelper.isDesktop(context) ? const CategoriesWebWidget() : Row(children: [
              Expanded(
                child: SizedBox(
                  height: 90,
                  child: category.categoryList != null ? category.categoryList!.isNotEmpty ? ListView.builder(
                    itemCount: category.categoryList!.length,
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, Routes.getCategoryRoute(
                            category.categoryList![index],
                          )),
                          child: Column(children: [

                            Container(
                              width: 65, height: 65,
                              decoration: BoxDecoration(
                                borderRadius:   BorderRadius.circular(10),
                                border: Border.all(width: .5,color: Theme.of(context).dividerColor)
                              ),
                              child: ClipRRect(
                                borderRadius:   BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder(context),
                                  image: '${category.categoryList![index].image}',
                                  width: 65, height: 65, fit: BoxFit.cover,
                                  imageErrorBuilder: (c,o,t)=> Image.asset(Images.placeholder(context),width: 65, height: 65, fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: Center(
                                child: Text(
                                  category.categoryList![index].name!,
                                  style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                          ]),
                        ),
                      );
                    },
                  ) : Center(child: Text(getTranslated('no_category_available', context))) : const CategoryShimmerWidget(),
                ),
              ),
            ]),
          ],
        ) : const SizedBox();
>>>>>>> 6c53e34d80390c8a7d59fed5efa8d67c686f3e0c
      },
    );
  }
}
<<<<<<< HEAD
=======

>>>>>>> 6c53e34d80390c8a7d59fed5efa8d67c686f3e0c
