import 'package:get/get.dart';

import '../../../../utils/library.dart';

class FacilityListScreen extends StatelessWidget {
  final FacilityListController facilityListController = Get.put(FacilityListController());

  FacilityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.serviceFacility,
      isLoading: facilityListController.isLoading,
      actions: [
        PopupMenuButton(
          onSelected: (value) {
            hideKeyboard(context);
            if (facilityListController.selectedFilter.value != value) {
              facilityListController.selectedFilter.value = value;
              facilityListController.page(1);
              facilityListController.getFacilityListApi(showLoader: true);
            }
          },
          icon: Image.asset(Assets.iconsIcFilterOutlined, height: 20, width: 20, color: iconColor),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 0,
                child: Text(
                  locale.value.myFacilities,
                  style: primaryTextStyle(color: facilityListController.selectedFilter.value == 0 ? switchActiveTrackColor : null),
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  locale.value.addedByAdmin,
                  style: primaryTextStyle(color: facilityListController.selectedFilter.value == 1 ? switchActiveTrackColor : null),
                ),
              )
            ];
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            hideKeyboard(context);
            Get.to(() => AddFacilityScreen())?.then((value) {
              if (value == true) {
                facilityListController.page(1);
                facilityListController.isLoading(true);
                facilityListController.getFacilityListApi();
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
              SearchFacilityWidget(
                facilityController: facilityListController,
                onFieldSubmitted: (p0) {
                  hideKeyboard(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              SnapHelperWidget<List<FacilityListData>>(
                future: facilityListController.getFacilityList.value,
                loadingWidget: const LoaderWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      facilityListController.page(1);
                      facilityListController.getFacilityListApi();
                    },
                  );
                },
                onSuccess: (facilityList) {
                  return Obx(
                    () => AnimatedListView(
                      shrinkWrap: true,
                      itemCount: facilityList.length,
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      scaleConfiguration: ScaleConfiguration(duration: const Duration(milliseconds: 400), delay: const Duration(milliseconds: 50)),
                      listAnimationType: ListAnimationType.FadeIn,
                      fadeInConfiguration: FadeInConfiguration(duration: const Duration(seconds: 2)),
                      emptyWidget: NoDataWidget(
                        title: facilityListController.selectedFilter.value.getBoolInt() || facilityListController.isSearchFacilityText.value
                            ? locale.value.oppsThereAreCurrentlyNoFacilitiesAvailable
                            : locale.value.oppsLooksLikeYouHaveNotAddedAnyFacilityYet,
                        retryText: (facilityListController.isSearchFacilityText.value || facilityListController.selectedFilter.value.getBoolInt()) ? locale.value.reload : locale.value.addNewFacility,
                        imageWidget: const EmptyStateWidget(),
                        onRetry: () async {
                          hideKeyboard(context);
                          if (facilityListController.isSearchFacilityText.value || facilityListController.selectedFilter.value.getBoolInt()) {
                            facilityListController.page(1);
                            facilityListController.isLoading(true);
                            facilityListController.getFacilityListApi();
                          } else {
                            Get.to(() => AddFacilityScreen())?.then((result) {
                              if (result == true) {
                                facilityListController.page(1);
                                facilityListController.isLoading(true);
                                facilityListController.getFacilityListApi();
                              }
                            });
                          }
                        },
                      ).paddingSymmetric(horizontal: 32).visible(!facilityListController.isLoading.value),
                      onSwipeRefresh: () async {
                        facilityListController.page(1);
                        facilityListController.getFacilityListApi(showLoader: false);
                        return await Future.delayed(const Duration(seconds: 2));
                      },
                      onNextPage: () async {
                        if (!facilityListController.isLastPage.value) {
                          facilityListController.page++;
                          facilityListController.isLoading(true);
                          facilityListController.getFacilityListApi();
                        }
                      },
                      itemBuilder: (ctx, index) {
                        FacilityListData facilityData = facilityList[index];
                        return Obx(
                          () => Container(
                            width: Get.width,
                            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: radius(),
                              backgroundColor: context.cardColor,
                              border: isDarkMode.value ? Border.all(color: context.dividerColor) : null,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  facilityData.name,
                                  style: primaryTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ).expand(),
                                16.width,
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    buildIconWidget(
                                      icon: Assets.iconsIcEditReview,
                                      onTap: () async {
                                        hideKeyboard(context);
                                        Get.to(() => AddFacilityScreen(isEdit: true), arguments: facilityData)?.then((value) {
                                          log('FacilityListScreen VALUE: $value');
                                          if (value == true) {
                                            facilityListController.page(1);
                                            facilityListController.isLoading(true);
                                            facilityListController.getFacilityListApi();
                                          }
                                        });
                                      },
                                    ),
                                    buildIconWidget(
                                      icon: Assets.iconsIcDelete,
                                      iconColor: cancelStatusColor,
                                      onTap: () {
                                        handleDeleteFacilityClick(facilityList, index, context);
                                      },
                                    ),
                                  ],
                                ).visible(facilityData.createdBy == loginUserData.value.id),
                                Obx(
                                  () => Transform.scale(
                                    scale: 0.6,
                                    alignment: Alignment.center,
                                    child: Switch.adaptive(
                                      value: facilityData.status.value,
                                      activeColor: context.primaryColor,
                                      inactiveTrackColor: context.primaryColor.withOpacity(0.2),
                                      inactiveThumbColor: context.primaryColor.withOpacity(0.5),
                                      onChanged: (val) {
                                        hideKeyboard(context);
                                        facilityData.status.value = !facilityData.status.value;

                                        /// Update Facility APi
                                        Map request = {
                                          "name": facilityData.name,
                                          "description": facilityData.description,
                                          "status": facilityData.status.value ? "1" : "0",
                                        };
                                        facilityListController.updateFacility(id: facilityData.id.value, req: request);
                                      },
                                    ),
                                  ).visible(facilityData.createdBy == loginUserData.value.id),
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

  Future<void> handleDeleteFacilityClick(List<FacilityListData> facilityList, int index, BuildContext context) async {
    showConfirmDialogCustom(
      context,
      primaryColor: context.primaryColor,
      title: locale.value.areYouSureYouWantToDeleteThisFacility,
      positiveText: locale.value.delete,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        hideKeyboard(context);
        facilityListController.isLoading(true);
        FacilityApis.removeFacility(facilityId: facilityList[index].id.value).then((value) {
          facilityList.removeAt(index);
          if (value.message.trim().isNotEmpty) toast(value.message);
          facilityListController.getFacilityListApi();
        }).catchError((e) {
          facilityListController.isLoading(false);
          toast(e.toString());
        }).whenComplete(() => facilityListController.isLoading(false));
      },
    );
  }
}
