import 'package:souqexpress/common/models/language_model.dart';
import 'package:souqexpress/common/widgets/custom_asset_image_widget.dart';
import 'package:souqexpress/common/widgets/custom_single_child_list_widget.dart';
import 'package:souqexpress/provider/language_provider.dart';
import 'package:souqexpress/utill/dimensions.dart';
import 'package:souqexpress/utill/images.dart';
import 'package:souqexpress/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelectWidget extends StatelessWidget {
  final bool fromMenu;
  const LanguageSelectWidget({
    Key? key, required this.fromMenu,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) => Center(child: SizedBox(
        width: Dimensions.webScreenWidth,
        child: CustomSingleChildListWidget(
            itemCount: languageProvider.languages.length,
            itemBuilder: (index) => _LanguageItemWidget(
              fromMenu: fromMenu,
              languageModel: languageProvider.languages[index],
              index: index,
            )),
      )),
    );
  }
}

class _LanguageItemWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final int index;
  final bool fromMenu;
  const _LanguageItemWidget({Key? key, required this.languageModel, required this.index, required this.fromMenu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, languageProvider, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
          onTap: () => languageProvider.setSelectIndex(index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
              border: languageProvider.selectIndex == index ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.15), width: 1) : null,
              color: languageProvider.selectIndex == index ? Theme.of(context).secondaryHeaderColor.withOpacity(0.3) : null,

            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(languageModel.imageUrl!, width: 34, height: 34),
                    ),
                    const SizedBox(width: 30),

                    Text(
                      languageModel.languageName!,
                      style: rubikMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                  ],
                ),

                !fromMenu && languageProvider.selectIndex == index ? CustomAssetImageWidget(
                  Images.done,
                  width: 17,
                  height: 17,
                  color: Theme.of(context).primaryColor,
                ) : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      );
    });
  }
}

