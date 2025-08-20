import 'package:get/get.dart';
import '../../../../../utils/library.dart';
class DeliveryOptionComponents extends StatelessWidget {
  final ProductItemDataResponse productData;

  const DeliveryOptionComponents({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        12.height,
         ViewAllLabel(label: locale.value.productDetails, isShowAll: false).paddingSymmetric(horizontal: 16),
        ReadMoreText(
          parseHtmlString(productData.description),
          trimLines: 3,
          style: secondaryTextStyle(size: 13),
          colorClickableText: secondaryColor,
          trimMode: TrimMode.Line,
          trimCollapsedText: locale.value.readMore,
          trimExpandedText: locale.value.readLess,
          locale: Localizations.localeOf(context),
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }
}
