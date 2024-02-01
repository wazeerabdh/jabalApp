import 'package:souqexpress/features/cart/widgets/cart_bottom_sheet_widget.dart';
import 'package:souqexpress/helper/product_helper.dart';
import 'package:souqexpress/helper/responsive_helper.dart';
import 'package:souqexpress/features/coupon/providers/coupon_provider.dart';
import 'package:souqexpress/common/widgets/custom_directionality_widget.dart';
import 'package:souqexpress/common/widgets/custom_image_widget.dart';
import 'package:souqexpress/helper/custom_snackbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:souqexpress/common/models/cart_model.dart';
import 'package:souqexpress/helper/price_converter_helper.dart';
import 'package:souqexpress/localization/language_constrants.dart';
import 'package:souqexpress/features/cart/providers/cart_provider.dart';
import 'package:souqexpress/features/splash/providers/splash_provider.dart';
import 'package:souqexpress/utill/color_resources.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:provider/provider.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel? cart;
  final int cartIndex;
  const CartProductWidget({Key? key, required this.cart, required this.cartIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? variationText = getVariationText();

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);


    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () {
      ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (con) => CartBottomSheetWidget(
          product: cart!.product,
          cart: cart,
          cartIndex: cartIndex,
          callback: (CartModel cartModel) {
            showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
          },
        ),
      ): showDialog(context: context, builder: (con) => Dialog(
        child: SizedBox(
          width: 500,
          child: CartBottomSheetWidget(
            cart: cart,
            product: cart!.product,
            cartIndex: cartIndex,
            callback: (CartModel cartModel) {
              showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
            },
          ),
        ),
      )) ;
    },

      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          const Positioned(
            top: 0, bottom: 0, right: 0, left: 0,
            child: Icon(Icons.delete, color: Colors.white, size: 50),
          ),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) => Provider.of<CartProvider>(context, listen: false).removeFromCart(cart!),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 5, spreadRadius: 1,
                )],
              ),
              child: Column(
                children: [

                  Row(crossAxisAlignment: ResponsiveHelper.isDesktop(context) ? CrossAxisAlignment.center : CrossAxisAlignment.start, children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomImageWidget(
                        image: '${splashProvider.baseUrls?.productImageUrl}/${cart?.product?.image?[0]}',
                        height: 100, width: 100, fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                        Text(cart!.product!.name!, style: rubikRegular, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),

                        if(ProductHelper.getProductRatingValue(cart?.product) != null) Row(children: [

                          Icon(Icons.star_rounded, color: ColorResources.getRatingColor(context), size: 20),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Padding(
                            padding: const EdgeInsets.only(top:4),
                            child: Text(
                              ProductHelper.getProductRatingValue(cart?.product)!.toStringAsFixed(1),
                              style: rubikMedium.copyWith(color: ColorResources.getGrayColor(context), fontSize: Dimensions.fontSizeDefault),
                            ),
                          ),

                        ]),


                        const SizedBox(height: 3),

                         Row(children: [
                          Text('${getTranslated('unit_price', context)}: ', style: rubikRegular.copyWith(fontSize: 10,fontFamily: "Tajawal")),


                          cart!.discountAmount! > 0 ? CustomDirectionalityWidget(
                            child: Text(PriceConverterHelper.convertPrice(cart!.discountedPrice!+cart!.discountAmount!), style: rubikRegular.copyWith(
                              color: ColorResources.colorGrey,
                              fontSize: Dimensions.fontSizeExtraSmall,
                              decoration: TextDecoration.lineThrough,overflow: TextOverflow.ellipsis
                            ),),
                          ) : const SizedBox(),
                           const SizedBox(width: Dimensions.paddingSizeExtraSmall),


                           CustomDirectionalityWidget(child: Text(
                            PriceConverterHelper.convertPrice(cart!.discountedPrice),
                            style: rubikBold,
                          )),

                        ]),

                       if(!ResponsiveHelper.isDesktop(context)) const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                       if(!ResponsiveHelper.isDesktop(context)) Row(children: [


                          cart!.discountAmount! > 0 ? CustomDirectionalityWidget(
                            child: Text(PriceConverterHelper.convertPrice((cart?.discountedPrice ?? 0) + (cart?.discountAmount ?? 0) * (cart?.quantity ?? 1)), style: rubikRegular.copyWith(
                              color: ColorResources.colorGrey,
                              fontSize: Dimensions.fontSizeExtraSmall,
                              decoration: TextDecoration.lineThrough,
                            )),
                          ) : const SizedBox(),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          CustomDirectionalityWidget(child: Text(
                            PriceConverterHelper.convertPrice((cart?.discountedPrice ?? 0) * (cart?.quantity ?? 1)),
                            style: rubikBold,
                          )),

                        ]),


                        cart?.product?.variations != null && cart!.product!.variations!.isNotEmpty ? Padding(
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                          child: Row(children: [
                            Text('${getTranslated('variation', context)} : ', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                            Expanded(
                              child: Text(
                                variationText!,
                                overflow: TextOverflow.ellipsis,
                                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Color(0xFF562E9C)),
                              ),
                            ),
                          ]),
                        ) : const SizedBox(),



                      ]),
                    ),
                    SizedBox(width: ResponsiveHelper.isMobile(context) ? 0 : 30),
                    if(ResponsiveHelper.isDesktop(context)) Row(children: [
                      cart!.discountAmount! > 0 ? CustomDirectionalityWidget(
                        child: Expanded(
                          child: Text(PriceConverterHelper.convertPrice(((cart?.discountedPrice ?? 0) + (cart?.discountAmount ?? 0) * (cart?.quantity ?? 1))), style: rubikRegular.copyWith(
                            color: Color(0xFF562E9C),
                            fontSize: Dimensions.fontSizeExtraSmall,
                            decoration: TextDecoration.lineThrough,overflow: TextOverflow.ellipsis
                          )),
                        ),
                      ) : const SizedBox(),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),


                      CustomDirectionalityWidget(child: Text(
                        PriceConverterHelper.convertPrice((cart?.discountedPrice ?? 0) * (cart?.quantity ?? 1)),
                        style: rubikBold,
                      )),
                    ]),
                     SizedBox(width: ResponsiveHelper.isMobile(context) ? 0 : 20),


                    RotatedBox(
                      quarterTurns: ResponsiveHelper.isDesktop(context) ? 0 : 5,
                      child: Container(   // عرض مخصص
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            if (!ResponsiveHelper.isDesktop(context))
                              InkWell(
                                onTap: () => Provider.of<CartProvider>(context, listen: false)
                                    .setQuantity(true, cart, cart!.stock, context, false, null),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  child: Icon(Icons.add, size: 16),
                                ),
                              ),

                            if (!ResponsiveHelper.isDesktop(context))
                              RotatedBox(
                                quarterTurns: ResponsiveHelper.isDesktop(context) ? 0 : 3,
                                child: Text(
                                  cart!.quantity.toString(),
                                  style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                                ),
                              ),

                            if (cart!.quantity == 1)
                              Padding(
                                padding: EdgeInsets.only(
                                  left: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0,
                                ),
                                child: RotatedBox(
                                  quarterTurns: ResponsiveHelper.isDesktop(context) ? 0 : 3,
                                  child: IconButton(
                                    onPressed: () {
                                      Provider.of<CartProvider>(context, listen: false).removeFromCart(cart!);
                                    },
                                    icon: const Icon(CupertinoIcons.delete, color: Colors.red, size: 16),
                                  ),
                                ),
                              )
                            else
                              InkWell(
                                onTap: () {
                                  if (cart!.quantity! > 1) {
                                    Provider.of<CartProvider>(context, listen: false).setQuantity(false, cart, cart!.stock, context, false, null);
                                    Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                                  } else if (cart!.quantity == 1) {
                                    Provider.of<CartProvider>(context, listen: false).removeFromCart(cart!);
                                    Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                                  }
                                },
                                child: RotatedBox(
                                  quarterTurns: ResponsiveHelper.isDesktop(context) ? 0 : 3,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeSmall,
                                      vertical: Dimensions.paddingSizeSmall,
                                    ),
                                    child: Icon(Icons.remove, size: 16),
                                  ),
                                ),
                              ),

                            if (ResponsiveHelper.isDesktop(context))
                              RotatedBox(
                                quarterTurns: ResponsiveHelper.isDesktop(context) ? 0 : 3,
                                child: Text(
                                  cart!.quantity.toString(),
                                  style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                                ),
                              ),

                            if (ResponsiveHelper.isDesktop(context))
                              InkWell(
                                onTap: () => Provider.of<CartProvider>(context, listen: false)
                                    .setQuantity(true, cart, cart!.stock, context, false, null),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  child: Icon(Icons.add, size: 16),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),


                  ]),

                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  String? getVariationText() {
    String? variationText = '';
    if(cart?.variation != null && cart!.variation!.isNotEmpty && cart!.variation!.first.type != null) {
      List<String> variationTypes =  cart!.variation!.first.type!.split('-');
      if(variationTypes.length == cart!.product!.choiceOptions!.length) {
        int index = 0;
        for (var choice in cart!.product!.choiceOptions!) {
          variationText = '${variationText!}${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
          index = index + 1;
        }
      }else {
        variationText = cart!.product!.variations![0].type;
      }
    }
    return variationText;
  }
}
