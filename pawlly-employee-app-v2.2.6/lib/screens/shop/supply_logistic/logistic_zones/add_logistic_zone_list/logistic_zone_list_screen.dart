import 'package:get/get.dart';
import 'logistic_zone_list_controller.dart';
import '../../../../../../utils/library.dart';
class LogisticZoneListScreen extends StatelessWidget {
  LogisticZoneListScreen({super.key});

  final LogisticZoneController logisticZoneController = Get.put(LogisticZoneController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        appBartitleText: locale.value.logisticZoneList,
        body: Stack(
          children: [
            SnapHelperWidget<List<LogisticZoneData>>(
              future: logisticZoneController.getLogisticZoneList.value,
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    logisticZoneController.page(1);
                    logisticZoneController.getLogisticsZone();
                  },
                );
              },
              onSuccess: (b) {
                return Obx(
                  () => AnimatedListView(
                    shrinkWrap: true,
                    itemCount: logisticZoneController.logisticZoneList.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    listAnimationType: ListAnimationType.FadeIn,
                    onSwipeRefresh: () async {
                      logisticZoneController.page(1);
                      logisticZoneController.getLogisticsZone(showLoader: false);
                      return await Future.delayed(const Duration(seconds: 2));
                    },
                    itemBuilder: (context, index) {
                      LogisticZoneData data = logisticZoneController.logisticZoneList[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        width: Get.width,
                        decoration: boxDecorationDefault(color: context.cardColor, shape: BoxShape.rectangle),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data.name.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(locale.value.zoneName, style: secondaryTextStyle()),
                                  Text(data.name.validate(), style: boldTextStyle(size: 15)),
                                ],
                              ),
                            if (data.logisticName.isNotEmpty) ...[
                              16.height,
                              Text(locale.value.logisticName, style: secondaryTextStyle()),
                              Text(data.logisticName.validate(), style: boldTextStyle(size: 15)),
                            ],
                            if (data.cities.isNotEmpty) ...[
                              16.height,
                              Text(locale.value.cities, style: secondaryTextStyle()),
                              Text(logisticZoneController.getCitiesName(data.cities.validate()), style: boldTextStyle(size: 15)),
                            ],
                            if (data.standardDeliveryCharge != 0) ...[
                              16.height,
                              Text(locale.value.standardDeliveryCharge, style: secondaryTextStyle()),
                              PriceWidget(price: data.standardDeliveryCharge.validate(), isBoldText: true, size: 15),
                            ],
                            if (data.standardDeliveryTime.isNotEmpty) ...[
                              16.height,
                              Text(locale.value.standardDeliveryTime, style: secondaryTextStyle()),
                              Text(data.standardDeliveryTime.validate(), style: boldTextStyle(size: 15)),
                            ],
                          ],
                        ),
                      );
                    },
                    onNextPage: () {
                      if (!logisticZoneController.isLastPage.value) {
                        logisticZoneController.page++;
                        logisticZoneController.getLogisticsZone();
                      }
                    },
                    emptyWidget: NoDataWidget(
                      title: locale.value.noLogisticZoneFound,
                      imageWidget: const EmptyStateWidget(),
                      subTitle: locale.value.thereAreCurrentlyNoLogisticZoneAvailable,
                      retryText: locale.value.reload,
                      onRetry: () {
                        logisticZoneController.page(1);
                        logisticZoneController.getLogisticsZone();
                      },
                    ).paddingSymmetric(horizontal: 16).visible(!logisticZoneController.isLoading.value),
                  ),
                );
              },
            ),
            const LoaderWidget().visible(logisticZoneController.isLoading.value)
          ],
        ),
      ),
    );
  }

  void handleFilterClick(BuildContext context) {
    doIfLoggedIn(context, () {
      serviceCommonBottomSheet(
        context,
        child: Obx(
          () => BottomSelectionSheet(
            heightRatio: 0.55,
            title: locale.value.filterBy,
            hideSearchBar: true,
            hintText: locale.value.searchForStatus,
            controller: TextEditingController(),
            hasError: false,
            isLoading: logisticZoneController.isLoading,
            isEmpty: logisticZoneController.allFilterStatus.isEmpty,
            noDataTitle: locale.value.statusListIsEmpty,
            noDataSubTitle: locale.value.thereAreNoStatus,
            listWidget: filterListWid(context),
          ),
        ),
      );
    });
  }

  //region Filter list
  Widget filterListWid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedWrap(
          runSpacing: 8,
          spacing: 8,
          itemCount: logisticZoneController.allFilterStatus.length,
          listAnimationType: ListAnimationType.FadeIn,
          itemBuilder: (_, index) {
            return Obx(
              () => GestureDetector(
                onTap: () {
                  logisticZoneController.selectedFilterStatus(logisticZoneController.allFilterStatus[index]);
                },
                child: Container(
                  width: Get.width / 2.7,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: boxDecorationDefault(
                    color: logisticZoneController.selectedFilterStatus.contains(logisticZoneController.allFilterStatus[index])
                        ? isDarkMode.value
                            ? primaryColor
                            : lightPrimaryColor
                        : isDarkMode.value
                            ? lightPrimaryColor2
                            : Colors.grey.shade100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        size: 14,
                        color: isDarkMode.value ? whiteColor : primaryColor,
                      ).visible(logisticZoneController.selectedFilterStatus.contains(logisticZoneController.allFilterStatus[index])),
                      4.width.visible(logisticZoneController.selectedFilterStatus.contains(logisticZoneController.allFilterStatus[index])),
                      Text(
                        getServiceFilterEmployee(status: logisticZoneController.allFilterStatus[index]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: secondaryTextStyle(
                          color: logisticZoneController.selectedFilterStatus.contains(logisticZoneController.allFilterStatus[index])
                              ? isDarkMode.value
                                  ? whiteColor
                                  : primaryColor
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ).paddingOnly(top: 8, bottom: 0).expand(),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppButton(
              text: locale.value.apply,
              textStyle: appButtonTextStyleWhite,
              onTap: () {
                Get.back();
                logisticZoneController.page(1);
                logisticZoneController.getLogisticsZone();
              },
            ).expand(),
          ],
        ),
      ],
    ).expand();
  }
}
