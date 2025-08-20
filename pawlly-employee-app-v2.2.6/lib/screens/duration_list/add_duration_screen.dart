import 'package:get/get.dart';

import '../../../../utils/library.dart';

class AddDurationScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  final AddDurationController addDurationController = Get.put(AddDurationController());

  final bool isEdit;

  AddDurationScreen({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: isEdit ? locale.value.editDuration : locale.value.editDuration,
      isLoading: addDurationController.isLoading,
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
                    Text("Duration", style: primaryTextStyle()),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return DropdownButton<String>(
                              borderRadius: BorderRadius.circular(10),
                              iconEnabledColor: primaryColor,
                              value: addDurationController.duration.value,
                              onChanged: (value) {
                                addDurationController.duration.value = value.toString();
                              },
                              items: addDurationController.durationList.map((time) {
                                return DropdownMenuItem<String>(
                                  value: time,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text("${time}"),
                                  ),
                                );
                              }).toList());
                        })
                        /*  AppTextField(
                          title: locale.value.hours,
                          textStyle: primaryTextStyle(size: 12),
                          controller: addDurationController.durationHourCont,
                          focus: addDurationController.durationHourFocus,
                          textFieldType: TextFieldType.OTHER,
                          textInputAction: TextInputAction.done,
                          readOnly: true,
                          suffix: Assets.iconsIcDuration.iconImage(fit: BoxFit.contain).paddingAll(14),
                          decoration: inputDecoration(
                            context,
                            hintText: '${locale.value.eG} 01',
                            fillColor: context.cardColor,
                            filled: true,
                          ),
                          onTap: () async {
                            /// Show Time Picker
                            final DateTime? dateTime = await showDurationTimePicker(
                              context,
                              selectedDateTime: addDurationController.isEdit.value
                                  ? addDurationController.durationData.value.duration.dateInHHmm24HourFormat
                                  : null,
                            );
                            if (dateTime != null) {
                              addDurationController.durationHourCont.text = dateTime.formatTimeHour();
                              log('HOUR: ${addDurationController.durationHourCont.text}');
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
                          controller: addDurationController.durationMinuteCont,
                          focus: addDurationController.durationMinuteFocus,
                          textInputAction: TextInputAction.done,
                          textFieldType: TextFieldType.OTHER,
                          readOnly: true,
                          suffix: Assets.iconsIcDuration.iconImage(fit: BoxFit.contain).paddingAll(14),
                          decoration: inputDecoration(
                            context,
                            hintText: '${locale.value.eG} 20',
                            fillColor: context.cardColor,
                            filled: true,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return locale.value.thisFieldIsRequired;
                            }
                            return null;
                          },
                          onTap: () async {
                            /// Show Time Picker
                            final DateTime? dateTime = await showDurationTimePicker(
                              context,
                              selectedDateTime: addDurationController.isEdit.value
                                  ? addDurationController.durationData.value.duration.dateInHHmm24HourFormat
                                  : null,
                            );
                            if (dateTime != null) {
                              addDurationController.durationMinuteCont.text = dateTime.formatTimeMinute();
                              log('MINUTE: ${addDurationController.durationMinuteCont.text}');
                            }
                          },
                        ).expand(),*/
                      ],
                    ),
                    16.height,
                    AppTextField(
                      title: locale.value.price,
                      textStyle: primaryTextStyle(size: 12),
                      controller: addDurationController.priceCont,
                      textFieldType: TextFieldType.NUMBER,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      focus: addDurationController.priceFocus,
                      textInputAction: TextInputAction.done,
                      suffix: Assets.iconsIcPrice.iconImage(fit: BoxFit.contain).paddingAll(14),
                      decoration: inputDecoration(
                        context,
                        hintText: "${locale.value.eG} ${appConfigs.value.currency.currencySymbol}20.00",
                        fillColor: context.cardColor,
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
                              value: addDurationController.isStatus.value,
                              activeColor: context.primaryColor,
                              inactiveTrackColor: context.primaryColor.withOpacity(0.2),
                              inactiveThumbColor: context.primaryColor.withOpacity(0.5),
                              onChanged: (val) {
                                addDurationController.isStatus.value = !addDurationController.isStatus.value;
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
                if (!addDurationController.isLoading.value) {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();

                    /// Add Or Edit Duration Api Call
                    addDurationController.addDuration();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
