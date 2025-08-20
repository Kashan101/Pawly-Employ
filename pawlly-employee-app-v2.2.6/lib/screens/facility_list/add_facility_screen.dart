import 'package:get/get.dart';

import '../../../../utils/library.dart';

class AddFacilityScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  final AddFacilityController addFacilityController = Get.put(AddFacilityController());

  final bool isEdit;

  AddFacilityScreen({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        appBartitleText: isEdit ? locale.value.editServiceFacility : locale.value.addServiceFacility,
        isLoading: addFacilityController.isLoading,
        body: Stack(
          children: [
            AnimatedScrollView(
              controller: scrollController,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 16),
              children: [
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        title: locale.value.name,
                        textStyle: primaryTextStyle(size: 12),
                        controller: addFacilityController.facilityNameCont,
                        focus: addFacilityController.facilityNameFocus,
                        nextFocus: addFacilityController.descriptionFocus,
                        textFieldType: TextFieldType.NAME,
                        suffix: Assets.iconsIcFacility.iconImage(fit: BoxFit.contain).paddingAll(14),
                        decoration: inputDecoration(
                          context,
                          hintText: locale.value.facilityName,
                          fillColor: context.cardColor,
                          filled: true,
                        ),
                      ),
                      16.height,
                      AppTextField(
                        title: locale.value.description,
                        textStyle: primaryTextStyle(size: 12),
                        controller: addFacilityController.descriptionCont,
                        focus: addFacilityController.descriptionFocus,
                        textFieldType: TextFieldType.MULTILINE,
                        textInputAction: TextInputAction.done,
                        isValidationRequired: false,
                        minLines: 4,
                        maxLines: 8,
                        suffix: Assets.iconsIcReason.iconImage(fit: BoxFit.contain).paddingAll(14),
                        decoration: inputDecoration(
                          context,
                          hintText: locale.value.enterFacilityDescription,
                          fillColor: context.cardColor,
                          filled: true,
                        ),
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(locale.value.status, style: primaryTextStyle()).expand(),
                          Obx(
                            () => Transform.scale(
                              scale: 0.8,
                              child: Switch.adaptive(
                                value: addFacilityController.isStatus.value,
                                activeColor: context.primaryColor,
                                inactiveTrackColor: context.primaryColor.withOpacity(0.2),
                                inactiveThumbColor: context.primaryColor.withOpacity(0.5),
                                onChanged: (val) {
                                  addFacilityController.isStatus.value = !addFacilityController.isStatus.value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: AppButton(
                text: locale.value.save,
                textStyle: appButtonTextStyleWhite,
                width: Get.width,
                onTap: () {
                  if (!addFacilityController.isLoading.value) {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      /// Add Or Edit Facility Api Call
                      addFacilityController.addFacility();
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
