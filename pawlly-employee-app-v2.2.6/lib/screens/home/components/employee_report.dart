import 'package:get/get.dart';

import '../../../../utils/library.dart';

class EmployeeReports extends StatelessWidget {
  EmployeeReports({super.key});

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          EmployeeTotalWidget(
            title: locale.value.totalBookings,
            total: homeController.dashboardData.value.totalBooking.toString(),
            icon: Assets.iconsIcTotalBooking,
          ).onTap(() {
            DashboardController hCont = Get.find();
            hCont.currentIndex(1);
          }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
          if (loginUserData.value.userRole.contains(EmployeeKeyConst.petStore) || loginUserData.value.isEnableStore.getBoolInt())
            EmployeeTotalWidget(
              title: locale.value.totalProducts,
              total: homeController.dashboardData.value.petstoreDetail.productCount.toString(),
              icon: Assets.profileIconsIcShopUnit,
            ).onTap(() {
              Get.to(() => ShopProductListScreen(), duration: const Duration(milliseconds: 800));
            }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
          if (loginUserData.value.userRole.contains(EmployeeKeyConst.petStore) || loginUserData.value.isEnableStore.getBoolInt())
            EmployeeTotalWidget(
              title: locale.value.totalOrders,
              total: homeController.dashboardData.value.petstoreDetail.orderCount.toString(),
              icon: Assets.navigationIcShopOutlined,
            ).onTap(() {
              Get.to(() => OrderListScreen(), duration: const Duration(milliseconds: 800));
            }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
          if (loginUserData.value.userRole.contains(EmployeeKeyConst.petStore) || loginUserData.value.isEnableStore.getBoolInt())
            EmployeeTotalWidget(
              title: locale.value.pendingOrderPayout,
              total: homeController.dashboardData.value.petstoreDetail.pendingOrderPayout.toString(),
              icon: Assets.iconsIcPercentLine,
              isPrice: true,
            ),
          EmployeeTotalWidget(
            title: locale.value.pendingBookingPayout,
            total: homeController.dashboardData.value.pendingServicePayout.toString(),
            icon: Assets.iconsIcPercentLine,
            isPrice: true,
          ),
          EmployeeTotalWidget(
            title: locale.value.totalRevenue,
            total: homeController.dashboardData.value.totalRevenue.toString(),
            icon: Assets.iconsIcPercentLine,
            isPrice: true,
          ),
          if (loginUserData.value.userType.contains(EmployeeKeyConst.boarding))
            EmployeeTotalWidget(
              title: locale.value.totalFacilities,
              total: homeController.dashboardData.value.totalFacility.toString(),
              icon: Assets.iconsIcPercentLine,
            ).onTap(() {
              Get.to(() => FacilityListScreen(), duration: const Duration(milliseconds: 800));
            }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
          if (loginUserData.value.userType.contains(EmployeeKeyConst.training))
            EmployeeTotalWidget(
              title: locale.value.totalTrainingServices,
              total: homeController.dashboardData.value.totalTrainingService.toString(),
              icon: Assets.iconsIcPercentLine,
            ).onTap(() {
              Get.to(() => TrainingTypeListScreen(), duration: const Duration(milliseconds: 800));
            }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
          if (loginUserData.value.userType.contains(EmployeeKeyConst.walking))
            EmployeeTotalWidget(
              title: locale.value.totalDurations,
              total: homeController.dashboardData.value.totalWalkerDuration.toString(),
              icon: Assets.iconsIcPercentLine,
            ).onTap(() {
              Get.to(() => DurationListScreen(), duration: const Duration(milliseconds: 800));
            }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
        ],
      ).paddingAll(16),
    );
  }
}
