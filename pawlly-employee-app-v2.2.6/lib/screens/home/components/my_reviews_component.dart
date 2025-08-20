import 'package:get/get.dart';
import '../../../../utils/library.dart';
class MyReviews extends StatelessWidget {
  MyReviews({super.key});
  final HomeController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewAllLabel(
          label: locale.value.myReviews,
          onTap: () {
            bottomNavigateByIndex(2);
          },
          list: homeScreenController.dashboardData.value.review,
        ).paddingSymmetric(horizontal: 16),
        Obx(
          () => homeScreenController.isReviewLoading.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${locale.value.loading}.... ", style: secondaryTextStyle(size: 14, fontFamily: fontFamilyFontBold)).paddingSymmetric(vertical: Get.height * 0.12),
                  ],
                )
              : AnimatedListView(
                  shrinkWrap: true,
                  listAnimationType: ListAnimationType.None,
                  itemCount: homeScreenController.dashboardData.value.review.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  emptyWidget: NoDataWidget(
                    title: locale.value.noRatingsYet,
                    titleTextStyle: secondaryTextStyle(size: 14),
                  ).paddingSymmetric(horizontal: 32),
                  itemBuilder: (context, index) {
                    return EmployeeReviewComponents(employeeReview: homeScreenController.dashboardData.value.review[index]);
                  },
                ),
        ),
      ],
    );
  }
}
