import 'package:get/get.dart';

import '../../../../../../utils/library.dart';
class AddTrainingTypeScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  final AddTrainingTypeController addTrainingTypeController = Get.put(AddTrainingTypeController());

  final bool isEdit;

  AddTrainingTypeScreen({super.key, this.isEdit = false});

  /// region Duration List Widget
  Widget durationListWidget(BuildContext ctx, {required int index}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(locale.value.addDuration, style: primaryTextStyle()),
            if (index != 0)
              buildIconWidget(
                icon: Assets.iconsIcDelete,
                iconColor: cancelStatusColor,
                onTap: () {
                  addTrainingTypeController.addDurationListWidget[index].durationHourCont!.text = '';
                  addTrainingTypeController.addDurationListWidget[index].durationMinuteCont!.text = '';
                  addTrainingTypeController.addDurationListWidget[index].durationPriceCont!.text = '';
                  addTrainingTypeController.addDurationListWidget.removeAt(index);
                },
              ),
          ],
        ),
        if (index == 0) 8.height,
        Container(
          width: Get.width,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: radius(),
            backgroundColor: ctx.cardColor,
            border: Border.all(color: ctx.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    title: locale.value.hours,
                    textStyle: primaryTextStyle(size: 12),
                    controller: addTrainingTypeController.addDurationListWidget[index].durationHourCont,
                    focus: addTrainingTypeController.addDurationListWidget[index].durationHourFocus,
                    textFieldType: TextFieldType.OTHER,
                    textInputAction: TextInputAction.done,
                    readOnly: true,
                    suffix: Assets.iconsIcDuration.iconImage(fit: BoxFit.contain).paddingAll(14),
                    decoration: inputDecoration(
                      ctx,
                      hintText: '${locale.value.eG} 01',
                      fillColor: ctx.cardColor,
                      filled: true,
                    ),
                    onTap: () async {
                      if (addTrainingTypeController.addDurationListWidget[index].durationHourCont!.text.isNotEmpty) {
                        /// Show Time Picker
                        final DateTime? dateTime = await showDurationTimePicker(
                          ctx,
                          selectedDateTime: addTrainingTypeController.isEdit.value
                              ? addTrainingTypeController.addDurationListWidget[index].fullDuration.dateInHHmm24HourFormat
                              : null,
                        );

                        if (dateTime != null) {
                          addTrainingTypeController.addDurationListWidget[index].durationHourCont?.text = dateTime.formatTimeHour();
                        }
                      } else {
                        /// Show Time Picker
                        final DateTime? dateTime = await showDurationTimePicker(ctx);

                        if (dateTime != null) {
                          addTrainingTypeController.addDurationListWidget[index].durationHourCont?.text = dateTime.formatTimeHour();
                        }
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return locale.value.thisFieldIsRequired;
                      }
                      return null;
                    },
                  ).expand(),
                  16.width,
                  AppTextField(
                    title: locale.value.minutes,
                    textStyle: primaryTextStyle(size: 12),
                    controller: addTrainingTypeController.addDurationListWidget[index].durationMinuteCont,
                    focus: addTrainingTypeController.addDurationListWidget[index].durationMinuteFocus,
                    textInputAction: TextInputAction.done,
                    textFieldType: TextFieldType.OTHER,
                    readOnly: true,
                    suffix: Assets.iconsIcDuration.iconImage(fit: BoxFit.contain).paddingAll(14),
                    decoration: inputDecoration(
                      ctx,
                      hintText: '${locale.value.eG} 20',
                      fillColor: ctx.cardColor,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return locale.value.thisFieldIsRequired;
                      }
                      return null;
                    },
                    onTap: () async {
                      if (addTrainingTypeController.addDurationListWidget[index].durationMinuteCont!.text.isNotEmpty) {
                        /// Show Time Picker
                        final DateTime? dateTime = await showDurationTimePicker(
                          ctx,
                          selectedDateTime: addTrainingTypeController.isEdit.value
                              ? addTrainingTypeController.addDurationListWidget[index].fullDuration.dateInHHmm24HourFormat
                              : null,
                        );
                        if (dateTime != null) {
                          addTrainingTypeController.addDurationListWidget[index].durationMinuteCont?.text = dateTime.formatTimeMinute();
                        }
                      } else {
                        /// Show Time Picker
                        final DateTime? dateTime = await showDurationTimePicker(ctx);
                        if (dateTime != null) {
                          addTrainingTypeController.addDurationListWidget[index].durationMinuteCont?.text = dateTime.formatTimeMinute();
                        }
                      }
                    },
                  ).expand(),
                ],
              ),
              16.height,
              AppTextField(
                title: locale.value.price,
                textStyle: primaryTextStyle(size: 12),
                controller: addTrainingTypeController.addDurationListWidget[index].durationPriceCont,
                textFieldType: TextFieldType.NUMBER,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                focus: addTrainingTypeController.addDurationListWidget[index].durationPriceFocus,
                textInputAction: TextInputAction.done,
                suffix: Assets.iconsIcPrice.iconImage(fit: BoxFit.contain).paddingAll(14),
                decoration: inputDecoration(
                  ctx,
                  hintText: "${locale.value.eG} ${appConfigs.value.currency.currencySymbol}20.00",
                  fillColor: ctx.cardColor,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return locale.value.thisFieldIsRequired;
                  } else if (value.startsWith('.') || value.startsWith('-')) {
                    return locale.value.theInputtedPriceIsInvalid;
                  } else if (value.toDouble() == 0.0) {
                    return locale.value.valueMustBeGreater;
                  }
                  return null;
                },
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
                        value: addTrainingTypeController.addDurationListWidget[index].durationStatus.value,
                        activeColor: ctx.primaryColor,
                        inactiveTrackColor: ctx.primaryColor.withOpacity(0.2),
                        inactiveThumbColor: ctx.primaryColor.withOpacity(0.5),
                        onChanged: (val) {
                          addTrainingTypeController.addDurationListWidget[index].durationStatus.value = !addTrainingTypeController.addDurationListWidget[index].durationStatus.value;
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        appBartitleText: isEdit ? locale.value.editTrainingService : locale.value.addTrainingService,
        isLoading: addTrainingTypeController.isLoading,
        body: Stack(
          children: [
            AnimatedScrollView(
              controller: scrollController,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80, top: 16),
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
                        controller: addTrainingTypeController.trainingTypeNameCont,
                        focus: addTrainingTypeController.trainingTypeNameFocus,
                        nextFocus: addTrainingTypeController.descriptionFocus,
                        textFieldType: TextFieldType.NAME,
                        suffix: Assets.iconsIcFacility.iconImage(fit: BoxFit.contain).paddingAll(14),
                        decoration: inputDecoration(
                          context,
                          hintText: locale.value.trainingTypeName,
                          fillColor: context.cardColor,
                          filled: true,
                        ),
                      ),
                      16.height,
                      AppTextField(
                        title: locale.value.description,
                        textStyle: primaryTextStyle(size: 12),
                        controller: addTrainingTypeController.descriptionCont,
                        focus: addTrainingTypeController.descriptionFocus,
                        textFieldType: TextFieldType.MULTILINE,
                        textInputAction: TextInputAction.done,
                        isValidationRequired: false,
                        minLines: 4,
                        maxLines: 8,
                        suffix: Assets.iconsIcReason.iconImage(fit: BoxFit.contain).paddingAll(14),
                        decoration: inputDecoration(
                          context,
                          hintText: locale.value.enterServiceDescription,
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
                                value: addTrainingTypeController.isStatus.value,
                                activeColor: context.primaryColor,
                                inactiveTrackColor: context.primaryColor.withOpacity(0.2),
                                inactiveThumbColor: context.primaryColor.withOpacity(0.5),
                                onChanged: (val) {
                                  addTrainingTypeController.isStatus.value = !addTrainingTypeController.isStatus.value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Duration', style: primaryTextStyle()),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () {
                              addTrainingTypeController.isLoading(true);
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                addTrainingTypeController.addDurationListWidget.add(
                                  DurationListData(
                                    id: (-1).obs,
                                    index: addTrainingTypeController.addDurationListWidget.length,
                                    addDurationCount: addTrainingTypeController.addDurationListWidget.length + 1,
                                    durationHourCont: TextEditingController(),
                                    durationHourFocus: FocusNode(),
                                    durationMinuteCont: TextEditingController(),
                                    durationMinuteFocus: FocusNode(),
                                    durationPriceCont: TextEditingController(),
                                    durationPriceFocus: FocusNode(),
                                    durationStatus: true.obs,
                                  ),
                                );
                              }
                              addTrainingTypeController.isLoading(false);
                            },
                            child: Text(
                              addTrainingTypeController.addDurationListWidget.isNotEmpty ? 'Add More' : 'Add',
                              style: primaryTextStyle(color: primaryColor, decorationColor: primaryColor),
                            ),
                          )
                        ],
                      ),
                      Obx(
                        () => AnimatedListView(
                          listAnimationType: ListAnimationType.None,
                          itemCount: addTrainingTypeController.addDurationListWidget.length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) {
                            return durationListWidget(ctx, index: i);
                          },
                        ),
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
                  if (!addTrainingTypeController.isLoading.value) {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      /// Check for duplicate durations
                      if (!addTrainingTypeController.checkForDuplicateDurations()) {
                        toast(locale.value.youCanNotAddSameDataForDurationsPleaseUpdateT, length: Toast.LENGTH_SHORT);
                      } else {
                        /// Add Or Edit Facility Api Call
                        addTrainingTypeController.addTrainingType();
                      }
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
