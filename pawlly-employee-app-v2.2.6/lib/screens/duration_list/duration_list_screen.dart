import 'package:get/get.dart';

import '../../../../utils/library.dart';

class DurationListScreen extends StatelessWidget {
  final DurationListController durationListController = Get.put(DurationListController());

  DurationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.durationList,
      isLoading: durationListController.isLoading,
      actions: [
        PopupMenuButton(
          onSelected: (value) {
            if (durationListController.selectedFilter.value != value) {
              durationListController.selectedFilter.value = value;
              durationListController.page(1);
              durationListController.getDurationListApi(showLoader: true);
            }
          },
          icon: Image.asset(Assets.iconsIcFilterOutlined, height: 20, width: 20, color: iconColor),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 0,
                child: Text(
                  locale.value.myDurations,
                  style: primaryTextStyle(color: durationListController.selectedFilter.value == 0 ? switchActiveTrackColor : null),
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  locale.value.addedByAdmin,
                  style: primaryTextStyle(color: durationListController.selectedFilter.value == 1 ? switchActiveTrackColor : null),
                ),
              )
            ];
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            Get.to(() => AddDurationScreen())?.then((value) {
              if (value == true) {
                durationListController.page(1);
                durationListController.isLoading(true);
                durationListController.getDurationListApi();
              }
            });
          },
        ),
      ],
      body: SizedBox(
        height: Get.height,
        child: Obx(
          () => SnapHelperWidget<List<DurationListData>>(
            future: durationListController.getDurationList.value,
            loadingWidget: const LoaderWidget(),
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  durationListController.page(1);
                  durationListController.getDurationListApi();
                },
              );
            },
            onSuccess: (durationList) {
              return Obx(
                () => AnimatedListView(
                  shrinkWrap: true,
                  itemCount: durationList.length,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  scaleConfiguration: ScaleConfiguration(duration: const Duration(milliseconds: 400), delay: const Duration(milliseconds: 50)),
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: const Duration(seconds: 2)),
                  emptyWidget: NoDataWidget(
                    title: durationListController.selectedFilter.value.getBoolInt() ? locale.value.oppsThereAreCurrentlyNoDurationsAvailable : locale.value.oppsLooksLikeYouHaveNotAddedAnyDurationYet,
                    retryText: durationListController.selectedFilter.value.getBoolInt() ? locale.value.reload : locale.value.addNewDuration,
                    imageWidget: const EmptyStateWidget(),
                    onRetry: () async {
                      if (durationListController.selectedFilter.value.getBoolInt()) {
                        durationListController.page(1);
                        durationListController.isLoading(true);
                        durationListController.getDurationListApi();
                      } else {
                        Get.to(() => AddDurationScreen())?.then((result) {
                          if (result == true) {
                            durationListController.page(1);
                            durationListController.isLoading(true);
                            durationListController.getDurationListApi();
                          }
                        });
                      }
                    },
                  ).paddingSymmetric(horizontal: 32).visible(!durationListController.isLoading.value),
                  onSwipeRefresh: () async {
                    durationListController.page(1);
                    durationListController.getDurationListApi(showLoader: false);
                    return await Future.delayed(const Duration(seconds: 2));
                  },
                  onNextPage: () async {
                    if (!durationListController.isLastPage.value) {
                      durationListController.page++;
                      durationListController.isLoading(true);
                      durationListController.getDurationListApi();
                    }
                  },
                  itemBuilder: (ctx, index) {
                    DurationListData durationData = durationList[index];
                    return Obx(
                      () => Container(
                        width: Get.width,
                        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                        margin: const EdgeInsets.only(bottom: 12),
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
                                Text(durationData.duration.toFormattedDuration(showFullTitleHoursMinutes: true), style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                8.height,
                                PriceWidget(price: durationData.price, size: 14, color: primaryColor),
                              ],
                            ).expand(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildIconWidget(
                                  icon: Assets.iconsIcEditReview,
                                  onTap: () async {
                                    Get.to(() => AddDurationScreen(isEdit: true), arguments: durationData)?.then((value) {
                                      log('DurationListScreen VALUE: $value');
                                      if (value == true) {
                                        durationListController.page(1);
                                        durationListController.isLoading(true);
                                        durationListController.getDurationListApi();
                                      }
                                    });
                                  },
                                ),
                                buildIconWidget(
                                  icon: Assets.iconsIcDelete,
                                  iconColor: cancelStatusColor,
                                  onTap: () {
                                    handleDeleteDurationClick(durationList, index, context);
                                  },
                                ),
                              ],
                            ).visible(durationData.createdBy == loginUserData.value.id),
                            Obx(
                              () => Transform.scale(
                                scale: 0.6,
                                alignment: Alignment.center,
                                child: Switch.adaptive(
                                  value: durationData.durationStatus.value,
                                  activeColor: context.primaryColor,
                                  inactiveTrackColor: context.primaryColor.withOpacity(0.2),
                                  inactiveThumbColor: context.primaryColor.withOpacity(0.5),
                                  onChanged: (val) {
                                    durationData.durationStatus.value = !durationData.durationStatus.value;

                                    /// Update Duration APi
                                    Map request = {
                                      "hours": durationData.duration.split(':').first,
                                      "minutes": durationData.duration.split(':').last,
                                      "price": durationData.price,
                                      "status": durationData.durationStatus.value ? "1" : "0",
                                    };
                                    durationListController.updateDuration(id: durationData.id.value, req: request);
                                  },
                                ),
                              ).visible(durationData.createdBy == loginUserData.value.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ).paddingTop(16),
      ),
    );
  }

  Future<void> handleDeleteDurationClick(List<DurationListData> durationList, int index, BuildContext context) async {
    showConfirmDialogCustom(
      context,
      primaryColor: context.primaryColor,
      title: locale.value.areYouSureYouWantToDeleteThisDuration,
      positiveText: locale.value.delete,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        durationListController.isLoading(true);
        DurationApis.removeServiceDuration(durationId: durationList[index].id.value).then((value) {
          durationList.removeAt(index);
          if (value.message.trim().isNotEmpty) toast(value.message);
          durationListController.getDurationListApi();
        }).catchError((e) {
          durationListController.isLoading(false);
          toast(e.toString());
        }).whenComplete(() => durationListController.isLoading(false));
      },
    );
  }
}
