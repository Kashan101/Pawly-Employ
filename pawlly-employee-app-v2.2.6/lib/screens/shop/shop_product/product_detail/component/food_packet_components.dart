import 'package:get/get.dart';

import '../../../../../utils/library.dart';

class FoodPacketComponents extends StatelessWidget {
  final ProductItemDataResponse productData;

  FoodPacketComponents({super.key, required this.productData});

  final ProductDetailController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (productData.hasVariation != 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          ViewAllLabel(label: locale.value.productSize, isShowAll: false).paddingSymmetric(horizontal: 16),
          8.height,
          HorizontalList(
            wrapAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            itemCount: productData.variationData.length,
            spacing: 16,
            padding: const EdgeInsets.only(left: 16, right: 16),
            itemBuilder: (context, index) {
              VariationData variationData = productData.variationData[index];
              return Obx(
                () => InkWell(
                  onTap: () {
                    productController.selectedVariationData(variationData);
                    variationData.taxIncludeProductPrice = productController.selectedVariationData.value.taxIncludeProductPrice;
                  },
                  borderRadius: radius(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                    decoration: boxDecorationDefault(
                      color: productController.selectedVariationData.value.id == variationData.id ? lightPrimaryColor : context.cardColor,
                    ),
                    child: AnimatedWrap(
                      itemCount: variationData.combination.length,
                      itemBuilder: (context, index) {
                        Combination combinationData = variationData.combination[index];
                        return Text(
                          combinationData.productVariationName,
                          style: primaryTextStyle(color: productController.selectedVariationData.value.id == variationData.id ? primaryColor : null),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      return const Offstage();
    }
  }
}
