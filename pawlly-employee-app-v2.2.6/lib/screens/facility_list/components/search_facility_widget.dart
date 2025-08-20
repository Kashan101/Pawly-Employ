import 'package:get/get.dart';
import '../../../../utils/library.dart';

class SearchFacilityWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final FacilityListController facilityController;

  const SearchFacilityWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.facilityController,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: facilityController.searchFacilityCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        facilityController.isSearchFacilityText(facilityController.searchFacilityCont.text.trim().isNotEmpty);
        facilityController.searchFacilityStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            facilityController.searchFacilityCont.clear();
            facilityController.isSearchFacilityText(facilityController.searchFacilityCont.text.trim().isNotEmpty);
            facilityController.page(1);
            facilityController.getFacilityListApi();
          },
          size: 11,
        ).visible(facilityController.isSearchFacilityText.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? locale.value.searchHere,
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, icon: Icons.search_outlined, size: 18).paddingAll(14),
      ),
    );
  }
}
