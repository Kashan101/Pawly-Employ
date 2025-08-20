import 'package:get/get.dart';
import '../../../../utils/library.dart';
class AboutProductComponent extends StatelessWidget {
  final ProductDetails productData;
  final String? deliveryStatus;

  const AboutProductComponent({super.key, this.deliveryStatus, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.aboutProduct, style: primaryTextStyle()),
        8.height,
        GestureDetector(
          onTap: () {
            Get.to(() => const ProductDetailScreen(), arguments: productData.productId);
          },
          child: Container(
            decoration: boxDecorationDefault(color: context.cardColor),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedImageWidget(
                      url: productData.productImage,
                      height: 75,
                      width: 75,
                      fit: BoxFit.cover,
                      radius: defaultRadius,
                    ),
                    12.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(productData.productName, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                        if (productData.productVariationType.isNotEmpty && productData.productVariationName.isNotEmpty)
                          Row(
                            children: [
                              Text('${productData.productVariationType} : ', style: secondaryTextStyle()),
                              Text(productData.productVariationName, style: primaryTextStyle(size: 12, color: textPrimaryColorGlobal, fontFamily: fontFamilyFontWeight600)),
                            ],
                          ),
                        Row(
                          children: [
                            Text('${locale.value.qty} : ', style: secondaryTextStyle()),
                            Text(productData.qty.toString(), style: primaryTextStyle(size: 12, color: textPrimaryColorGlobal, fontFamily: fontFamilyFontWeight600)),
                          ],
                        ),
                        PriceWidget(price: productData.getProductPrice, size: 12),
                      ],
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
