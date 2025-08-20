import 'package:get/get.dart';

import '../../../../../../utils/library.dart';

class ProductVariationListScreen extends StatelessWidget {
  ProductVariationListScreen({super.key});

  final ProductVariationListController variationListController = Get.put(ProductVariationListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        appBartitleText: locale.value.variation,
        isLoading: variationListController.isLoading,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              bool? res = await Get.to(() => AddVariationScreen(), duration: const Duration(milliseconds: 800));
              if (res ?? false) {
                variationListController.page(1);
                variationListController.isLoading(true);
                variationListController.getVariationList(showLoader: true);
              }
            },
          )
        ],
        body: Stack(
          children: [
            SnapHelperWidget<List<VariationData>>(
              future: variationListController.getVariations.value,
              loadingWidget: const LoaderWidget(),
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    variationListController.page(1);
                    variationListController.getVariationList(showLoader: true);
                  },
                );
              },
              onSuccess: (data) {
                return AnimatedListView(
                  shrinkWrap: true,
                  itemCount: variationListController.variationList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onSwipeRefresh: () async {
                    variationListController.page(1);
                    variationListController.getVariationList(showLoader: false);
                    return await Future.delayed(const Duration(seconds: 2));
                  },
                  itemBuilder: (context, index) {
                    VariationData variationData = variationListController.variationList[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      width: Get.width,
                      decoration: boxDecorationDefault(color: context.cardColor, shape: BoxShape.rectangle),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (variationData.name.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(locale.value.variationName, style: secondaryTextStyle()),
                                    Text(variationData.name.validate(), style: primaryTextStyle()),
                                  ],
                                ),
                              if (variationData.type.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    16.height,
                                    Text(locale.value.variationType, style: secondaryTextStyle()),
                                    Text(variationData.type.validate(), style: primaryTextStyle(size: 15)),
                                  ],
                                ),
                            ],
                          ).expand(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildIconWidget(
                                icon: Assets.iconsIcEditReview,
                                onTap: () async {
                                  Get.to(() => AddVariationScreen(isEdit: true), arguments: variationData)?.then(
                                    (value) {
                                      if (value == true) {
                                        variationListController.page(1);
                                        variationListController.getVariationList(showLoader: true);
                                      }
                                    },
                                  );
                                },
                              ),
                              buildIconWidget(
                                icon: Assets.iconsIcDelete,
                                iconColor: cancelStatusColor,
                                onTap: () => handleDeleteBrandClick(variationListController.variationList, index, context),
                              ),
                            ],
                          ).visible(variationData.createdBy == loginUserData.value.id),
                        ],
                      ),
                    );
                  },
                  onNextPage: () {
                    if (!variationListController.isLastPage.value) {
                      variationListController.page++;
                      variationListController.getVariationList(showLoader: true);
                    }
                  },
                  emptyWidget: NoDataWidget(
                    title: locale.value.noVariationsFound,
                    imageWidget: const EmptyStateWidget(),
                    subTitle: locale.value.thereAreCurrentlyNoVariationsAvailable,
                    retryText: locale.value.reload,
                    onRetry: () {
                      variationListController.page(1);
                      variationListController.getVariationList(showLoader: true);
                    },
                  ).paddingSymmetric(horizontal: 16).visible(!variationListController.isLoading.value),
                );
              },
            ),
            Obx(() => const LoaderWidget().visible(variationListController.isLoading.value)),
          ],
        ),
      ),
    );
  }

  //region Delete the Brand
  Future<void> handleDeleteBrandClick(List<VariationData> variation, int index, BuildContext context) async {
    showConfirmDialogCustom(
      context,
      primaryColor: context.primaryColor,
      title: locale.value.areYouSureYouDeleteBrand,
      positiveText: locale.value.delete,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        variationListController.isLoading(true);
        VariationAPI.removeVariation(variationId: variation[index].id).then((value) {
          variation.removeAt(index);
          toast(value.message.trim());
          variationListController.page(1);
          variationListController.getVariationList();
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => variationListController.isLoading(false));
      },
    );
  }

//endregion
}
