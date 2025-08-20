import 'package:get/get.dart';

import '../../../../../../utils/library.dart';

class SearchTrainingTypeWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final TrainingTypeListController trainingTypeListController;

  const SearchTrainingTypeWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.trainingTypeListController,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: trainingTypeListController.searchTrainingTypeCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        trainingTypeListController.isSearchTrainingTypeText(trainingTypeListController.searchTrainingTypeCont.text.trim().isNotEmpty);
        trainingTypeListController.searchTrainingTypeStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            trainingTypeListController.searchTrainingTypeCont.clear();
            trainingTypeListController.isSearchTrainingTypeText(trainingTypeListController.searchTrainingTypeCont.text.trim().isNotEmpty);
            trainingTypeListController.page(1);
            trainingTypeListController.getTrainingTypeListApi();
          },
          size: 11,
        ).visible(trainingTypeListController.isSearchTrainingTypeText.value),
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
