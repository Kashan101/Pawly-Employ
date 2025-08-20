import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly_employee/components/app_scaffold.dart';
import 'package:pawlly_employee/screens/training_type_list/services/training_type_apis.dart';
import 'package:pawlly_employee/screens/training_type_list/training_type_list_controller.dart';

import '../../components/bottom_selection_widget.dart';
import '../../components/loader_widget.dart';
import '../../components/price_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/empty_error_state_widget.dart';
import '../duration_list/model/duration_list_response.dart';
import 'add_training_type_screen.dart';
import 'components/search_training_type_widget.dart';
import 'model/training_type_list_response.dart';

class TrainingTypeListScreen extends StatelessWidget {
  final TrainingTypeListController trainingListController = Get.put(TrainingTypeListController());

  TrainingTypeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.trainingServices,
      isLoading: trainingListController.isLoading,
      actions: [
        PopupMenuButton(
          onSelected: (value) {
            hideKeyboard(context);
            if (trainingListController.selectedFilter.value != value) {
              trainingListController.selectedFilter.value = value;
              trainingListController.page(1);
              trainingListController.getTrainingTypeListApi(showLoader: true);
            }
          },
          icon: Image.asset(Assets.iconsIcFilterOutlined, height: 20, width: 20, color: iconColor),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 0,
                child: Text(
                  locale.value.myTrainingTypes,
                  style: primaryTextStyle(color: trainingListController.selectedFilter.value == 0 ? switchActiveTrackColor : null),
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  locale.value.addedByAdmin,
                  style: primaryTextStyle(color: trainingListController.selectedFilter.value == 1 ? switchActiveTrackColor : null),
                ),
              )
            ];
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            hideKeyboard(context);
            Get.to(() => AddTrainingTypeScreen())?.then((value) {
              if (value == true) {
                trainingListController.page(1);
                trainingListController.isLoading(true);
                trainingListController.getTrainingTypeListApi();
              }
            });
          },
        ),
      ],
      body: SizedBox(
        height: Get.height,
        child: Obx(
          () => Column(
            children: [
              SearchTrainingTypeWidget(
                trainingTypeListController: trainingListController,
                onFieldSubmitted: (p0) {
                  hideKeyboard(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              SnapHelperWidget<List<TrainingTypeListData>>(
                future: trainingListController.getTrainingTypeList.value,
                loadingWidget: const LoaderWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      trainingListController.page(1);
                      trainingListController.getTrainingTypeListApi();
                    },
                  );
                },
                onSuccess: (trainingTypeList) {
                  return Obx(
                    () => AnimatedListView(
                      shrinkWrap: true,
                      itemCount: trainingTypeList.length,
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      scaleConfiguration: ScaleConfiguration(duration: const Duration(milliseconds: 400), delay: const Duration(milliseconds: 50)),
                      listAnimationType: ListAnimationType.FadeIn,
                      fadeInConfiguration: FadeInConfiguration(duration: const Duration(seconds: 2)),
                      emptyWidget: NoDataWidget(
                        title: trainingListController.selectedFilter.value.getBoolInt() || trainingListController.isSearchTrainingTypeText.value
                            ? locale.value.oppsThereAreCurrentlyNoTrainingTypesAvailable
                            : locale.value.oppsLooksLikeYouHaveNotAddedAnyTrainingTypeYe,
                        retryText: (trainingListController.isSearchTrainingTypeText.value || trainingListController.selectedFilter.value.getBoolInt()) ? locale.value.reload : locale.value.addNewTrainingService,
                        imageWidget: const EmptyStateWidget(),
                        onRetry: () async {
                          hideKeyboard(context);
                          if (trainingListController.isSearchTrainingTypeText.value || trainingListController.selectedFilter.value.getBoolInt()) {
                            trainingListController.page(1);
                            trainingListController.isLoading(true);
                            trainingListController.getTrainingTypeListApi();
                          } else {
                            Get.to(() => AddTrainingTypeScreen())?.then((result) {
                              if (result == true) {
                                trainingListController.page(1);
                                trainingListController.isLoading(true);
                                trainingListController.getTrainingTypeListApi();
                              }
                            });
                          }
                        },
                      ).paddingSymmetric(horizontal: 32).visible(!trainingListController.isLoading.value),
                      onSwipeRefresh: () async {
                        trainingListController.page(1);
                        trainingListController.getTrainingTypeListApi(showLoader: false);
                        return await Future.delayed(const Duration(seconds: 2));
                      },
                      onNextPage: () async {
                        if (!trainingListController.isLastPage.value) {
                          trainingListController.page++;
                          trainingListController.isLoading(true);
                          trainingListController.getTrainingTypeListApi();
                        }
                      },
                      itemBuilder: (ctx, index) {
                        TrainingTypeListData trainingTypeData = trainingTypeList[index];
                        return Obx(
                          () => Container(
                            width: Get.width,
                            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: radius(),
                              backgroundColor: context.cardColor,
                              border: isDarkMode.value ? Border.all(color: context.dividerColor) : null,
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trainingTypeData.name,
                                      style: primaryTextStyle(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    8.height,
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      onPressed: () {
                                        viewMoreBottomSheet(context, trainingTypeListData: trainingTypeData);
                                      },
                                      child: Text(
                                        locale.value.viewDetail,
                                        style: primaryTextStyle(
                                          size: 12,
                                          color: primaryColor,
                                          decorationColor: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ).expand(),
                                16.width,
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    buildIconWidget(
                                      icon: Assets.iconsIcEditReview,
                                      onTap: () async {
                                        hideKeyboard(context);
                                        Get.to(() => AddTrainingTypeScreen(isEdit: true), arguments: trainingTypeData)?.then((value) {
                                          log('TrainingTypeListScreen VALUE: $value');
                                          if (value == true) {
                                            trainingListController.page(1);
                                            trainingListController.isLoading(true);
                                            trainingListController.getTrainingTypeListApi();
                                          }
                                        });
                                      },
                                    ),
                                    buildIconWidget(
                                      icon: Assets.iconsIcDelete,
                                      iconColor: cancelStatusColor,
                                      onTap: () {
                                        handleDeleteTrainingTypeClick(trainingTypeList, index, context);
                                      },
                                    ),
                                  ],
                                ).visible(trainingTypeData.createdBy == loginUserData.value.id),
                                Obx(
                                  () => Transform.scale(
                                    scale: 0.6,
                                    alignment: Alignment.center,
                                    child: Switch.adaptive(
                                      value: trainingTypeData.status.value,
                                      activeColor: context.primaryColor,
                                      inactiveTrackColor: context.primaryColor.withOpacity(0.2),
                                      inactiveThumbColor: context.primaryColor.withOpacity(0.5),
                                      onChanged: (val) {
                                        hideKeyboard(context);
                                        trainingTypeData.status.value = !trainingTypeData.status.value;

                                        List<DurationListData> durationsData = [];

                                        trainingTypeData.duration.forEach((element) {
                                          DurationListData durationListData = DurationListData(
                                            id: (-1).obs,
                                            durationHourCont: TextEditingController(text: element.duration.split(':').first),
                                            durationHourFocus: FocusNode(),
                                            durationMinuteCont: TextEditingController(text: element.duration.split(':').last),
                                            durationMinuteFocus: FocusNode(),
                                            durationPriceCont: TextEditingController(text: element.amount.toString()),
                                            durationPriceFocus: FocusNode(),
                                            durationStatus: element.durationStatus,
                                          );

                                          durationsData.add(durationListData);
                                        });

                                        /// Update Training Type APi
                                        Map request = {
                                          "name": trainingTypeData.name,
                                          "description": trainingTypeData.description,
                                          "status": trainingTypeData.status.value ? "1" : "0",
                                          "durations": jsonEncode(durationsData.map((e) => e.toJsonRequest()).toList()),
                                        };

                                        trainingListController.updateTrainingType(id: trainingTypeData.id.value, req: request);
                                      },
                                    ),
                                  ).visible(trainingTypeData.createdBy == loginUserData.value.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ).expand(),
            ],
          ),
        ).paddingTop(16),
      ),
    );
  }

  Future<void> handleDeleteTrainingTypeClick(List<TrainingTypeListData> trainingTypeList, int index, BuildContext context) async {
    showConfirmDialogCustom(
      context,
      primaryColor: context.primaryColor,
      title: locale.value.areYouSureYouWantToDeleteIt,
      positiveText: locale.value.delete,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        hideKeyboard(context);
        trainingListController.isLoading(true);
        TrainingTypeApis.removeTrainingType(trainingTypeId: trainingTypeList[index].id.value).then((value) {
          trainingTypeList.removeAt(index);
          if (value.message.trim().isNotEmpty) toast(value.message);
          trainingListController.getTrainingTypeListApi();
        }).catchError((e) {
          trainingListController.isLoading(false);
          toast(e.toString());
        }).whenComplete(() => trainingListController.isLoading(false));
      },
    );
  }

  void viewMoreBottomSheet(BuildContext ctx, {required TrainingTypeListData trainingTypeListData}) {
    serviceCommonBottomSheet(
      ctx,
      backgroundColor: ctx.cardColor,
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.75,
        minChildSize: 0.25,
        expand: false,
        builder: (context, controller) {
          return SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                16.height,
                Row(
                  children: [
                    Text(
                      trainingTypeListData.name,
                      style: primaryTextStyle(size: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).expand(),
                    appCloseIconButton(
                      ctx,
                      onPressed: () {
                        Get.back();
                      },
                      size: 11,
                    ),
                  ],
                ),
                if (trainingTypeListData.description.isNotEmpty)
                  ReadMoreText(
                    trainingTypeListData.description,
                    style: secondaryTextStyle(),
                    textAlign: TextAlign.left,
                  ).paddingTop(8),
                if (trainingTypeListData.duration.isNotEmpty)
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            locale.value.durationsAndPrice,
                            style: primaryTextStyle(size: 14, decoration: TextDecoration.none, weight: FontWeight.normal),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ).expand(),
                        ],
                      ),
                      8.height,
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(16),
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: radius(),
                          backgroundColor: isDarkMode.value ? appButtonColorDark : bottomSheetCardColor,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: trainingTypeListData.duration.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            DurationListData durationListData = trainingTypeListData.duration[i];
                            return Row(
                              children: [
                                Text(
                                  durationListData.duration.toFormattedDuration(showFullTitleHoursMinutes: true),
                                  style: secondaryTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ).expand(),
                                16.width,
                                PriceWidget(price: durationListData.amount, size: 14, color: primaryColor),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              indent: 3,
                              height: 16,
                              color: isDarkMode.value ? borderColor.withOpacity(0.2) : borderColor.withOpacity(0.5),
                            );
                          },
                        ),
                      ),
                    ],
                  ).paddingTop(30),
              ],
            ),
          );
        },
      ),
    );
  }
}
