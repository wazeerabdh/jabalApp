
import 'package:souqexpress/common/enums/footer_type_enum.dart';
import 'package:souqexpress/common/widgets/home_app_bar_widget.dart';
import 'package:souqexpress/helper/responsive_helper.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/features/category/providers/category_provider.dart';
import 'package:souqexpress/provider/localization_provider.dart';
import 'package:souqexpress/utill/color_resources.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/images.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:souqexpress/common/widgets/custom_image_widget.dart';
import 'package:souqexpress/common/widgets/footer_web_widget.dart';
import 'package:souqexpress/common/widgets/no_data_screen.dart';
import 'package:souqexpress/common/widgets/product_card_widget.dart';
import 'package:souqexpress/common/widgets/product_shimmer_widget.dart';
import 'package:souqexpress/common/widgets/web_app_bar_widget.dart';
import 'package:souqexpress/features/menu/widgets/options_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryScreen extends StatefulWidget {
  final int? categoryId;
  final int? subCategoryId;

  const CategoryScreen({Key? key, required this.categoryId, this.subCategoryId}) : super(key: key);


  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();

  int _tabIndex = 0;


  @override
  void initState() {
    _loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final double  width = MediaQuery.of(context).size.width - Dimensions.webScreenWidth ;
    final double marginWidth = width / 2;
    final bool isLtr = Provider.of<LocalizationProvider>(context, listen: false).isLtr;


    return Scaffold(
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      drawer: ResponsiveHelper.isTab(context) ? const Drawer(child: OptionsWidget(onTap: null)) : const SizedBox(),
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(90), child: WebAppBarWidget())  : null,
      body: Consumer<CategoryProvider>(
        builder: (context, category, child) {
          return category.subCategoryList != null && category.categoryList != null ?
          Center(
            child: CustomScrollView(
              physics: ResponsiveHelper.isDesktop(context) ? const AlwaysScrollableScrollPhysics() : const BouncingScrollPhysics(),
              slivers: [
               if(!ResponsiveHelper.isDesktop(context)) HomeAppBarWidget(drawerGlobalKey: drawerGlobalKey),

                SliverAppBar(
                  scrolledUnderElevation: 0,
                  backgroundColor: Theme.of(context).canvasColor,
                  expandedHeight: 250,
                  toolbarHeight: 80 + MediaQuery.of(context).padding.top,
                  pinned: true,
                  floating: false,
                  leading: ResponsiveHelper.isDesktop(context) ? const SizedBox() : SizedBox(
                    width:ResponsiveHelper.isDesktop(context) ? Dimensions.webScreenWidth : MediaQuery.of(context).size.width,
                    child: IconButton(icon: const Icon(Icons.chevron_left, color: Colors.white), onPressed: () => Navigator.pop(context)),
                  ),
                  flexibleSpace: Container(
                    color:Theme.of(context).canvasColor,
                    margin:ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(horizontal: marginWidth) : const EdgeInsets.symmetric(horizontal: 0),
                    width: ResponsiveHelper.isDesktop(context) ? Dimensions.webScreenWidth : MediaQuery.of(context).size.width,
                    child: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(
                        bottom: 54 + (MediaQuery.of(context).padding.top/2),
                        left: 50,
                        right: 50,
                      ),
                      background: Container(
                        width : ResponsiveHelper.isDesktop(context)
                            ? Dimensions.webScreenWidth : MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 50),
                        child: CustomImageWidget(
                          placeholder: Images.placeholder(context),
                          fit: BoxFit.cover,
                          image: category.selectedCategoryModel?.banner ?? '',
                        ),
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(30.0),
                    child: Container(
                      color: Theme.of(context).canvasColor,
                      width:  ResponsiveHelper.isDesktop(context) ? Dimensions.webScreenWidth : MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
<<<<<<< HEAD
                              vertical: 6,
                              horizontal: ResponsiveHelper.isDesktop(context) ? 0 :15
                            ),
                            child: Text(category.selectedCategoryModel?.name ?? '', style:TextStyle(
                              fontSize: 15,color: Color(0xFF562E9C),fontWeight: FontWeight.bold
=======
                              vertical: Dimensions.paddingSizeExtraSmall,
                              horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault
                            ),
                            child: Text(category.selectedCategoryModel?.name ?? '', style: rubikMedium.copyWith(
                              fontSize: Dimensions.fontSizeOverLarge,
>>>>>>> 6c53e34d80390c8a7d59fed5efa8d67c686f3e0c
                            )),
                          ),

                         if(category.subCategoryList != null) TabBar(
<<<<<<< HEAD
                           padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ?  0 : 12),
                            labelPadding:  EdgeInsets.only(
                              left: isLtr ? 0 : 12,
                              right: isLtr ? 12 : 0,
=======
                           padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ?  0 : Dimensions.paddingSizeDefault),
                            labelPadding:  EdgeInsets.only(
                              left: isLtr ? 0 : Dimensions.paddingSizeDefault,
                              right: isLtr ? Dimensions.paddingSizeDefault : 0,
>>>>>>> 6c53e34d80390c8a7d59fed5efa8d67c686f3e0c
                            ),
                            controller: TabController(
                                initialIndex: _tabIndex,
                                length: category.subCategoryList!.length + 1, vsync: this
                            ),

                            isScrollable: true,
<<<<<<< HEAD
                            indicatorPadding: EdgeInsets.only(  bottom:ResponsiveHelper.isDesktop(context) ? 10:5),
                            unselectedLabelColor: ColorResources.getGreyColor(context),
                            indicatorWeight: 2,
=======
                            unselectedLabelColor: ColorResources.getGreyColor(context),
                            indicatorWeight: 3,
>>>>>>> 6c53e34d80390c8a7d59fed5efa8d67c686f3e0c
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Theme.of(context).primaryColor,
                            labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                            // tabAlignment: TabAlignment.start,
                            tabs: _tabs(category),
                            onTap: (int index) {
                              _tabIndex = index;
                              if(index == 0) {
                                category.getCategoryProductList(widget.categoryId);
                              }else {
                                category.getCategoryProductList(category.subCategoryList![index-1].id);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height -560 : MediaQuery.of(context).size.height),
                        child: SizedBox(width: Dimensions.webScreenWidth,
                          child: category.categoryProductList != null ? category.categoryProductList!.isNotEmpty ?

                          ResponsiveHelper.isDesktop(context) ? GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                              mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                              childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : 4,
                              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 2 : 1,
                            ),
                            itemCount: category.categoryProductList!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            itemBuilder: (context, index) {
                              return ProductCardWidget(product: category.categoryProductList![index]);
                            },
                          ) : StaggeredGrid.count(
                            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : 2,
                            mainAxisSpacing: 4, crossAxisSpacing: 4,
                            children: category.categoryProductList!.map((product) => StaggeredGridTile.fit(
                              crossAxisCellCount: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                child: ProductCardWidget(product: product),
                              ),
                            ),).toList()) : const NoDataScreen(showFooter: false) : GridView.builder(
                              shrinkWrap: true,
                              itemCount: 10,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                                mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                                childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : 4,
                                crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 2 : 1,
                              ),
                              itemBuilder: (context, index) {
                                return ProductShimmerWidget(isEnabled: category.categoryProductList == null, isWeb:  ResponsiveHelper.isDesktop(context) ? true : false);
                              },
                          ),
                          ),
                      ),

                      const FooterWebWidget(footerType: FooterType.nonSliver),

                    ],
                  ),
                ),



              ],
            ),
          ) : SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: Dimensions.webScreenWidth,
                child: Column(
                  children: [
                    Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        child: Container(height: 200,width: double.infinity,color: Theme.of(context).shadowColor)),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                        childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : 4,
                        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 2 : 1,
                      ),
                      itemBuilder: (context, index) {
                        return ProductShimmerWidget(isEnabled: category.categoryProductList == null,isWeb:  ResponsiveHelper.isDesktop(context) ? true : false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Tab> _tabs(CategoryProvider category) {
    List<Tab> tabList = [];
<<<<<<< HEAD
    tabList.add(Tab(text: getTranslated('all', context),), );
=======
    tabList.add(Tab(text: getTranslated('all', context)));
>>>>>>> 6c53e34d80390c8a7d59fed5efa8d67c686f3e0c
    for (var subCategory in category.subCategoryList!) {
      tabList.add(Tab(text: subCategory.name!.length >= 30 ? '${subCategory.name!.substring(0,30 )}...' : subCategory.name));
    }
    return tabList;
  }

  void _loadData() async {
    final CategoryProvider categoryProvider =  Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.getCategoryList(true).then((value){
      categoryProvider.selectCategoryById(widget.categoryId);
    });

    await categoryProvider.getSubCategoryList(
      widget.categoryId!,
      subCategoryId: widget.subCategoryId,
    );


    if(widget.subCategoryId != null && categoryProvider.subCategoryList != null){
      for(int i = 0; i < categoryProvider.subCategoryList!.length; i++){
        if(categoryProvider.subCategoryList![i].id == widget.subCategoryId){
          _tabIndex = i + 1;
          break;
        }
      }
    }
  }

}
