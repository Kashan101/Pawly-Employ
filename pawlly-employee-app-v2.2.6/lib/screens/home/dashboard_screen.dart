import 'package:get/get.dart';
import '../../../../utils/library.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);
  final DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: locale.value.pressBackAgainToExitApp,
      child: AppScaffold(
        hideAppBar: true,
        isLoading: dashboardController.isLoading,
        body: Obx(() => dashboardController.screen[dashboardController.currentIndex.value]),
        bottomNavBar: Obx(
          () => NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: context.cardColor,
              indicatorColor: context.primaryColor.withOpacity(0.1),
              labelTextStyle: WidgetStateProperty.all(primaryTextStyle(size: 12)),
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: NavigationBar(
              selectedIndex: dashboardController.currentIndex.value,
              onDestinationSelected: (v) {
                final BookingsController bookingController = Get.find();

                dashboardController.currentIndex(v);
                try {
                  if (v == 0) {
                    bookingController.searchCont.clear();
                    HomeController hCont = Get.find();
                    hCont.getDashboardDetail(isFromSwipeRefresh: true);
                  } else if (v == 1) {
                    BookingsController bCont = Get.find();
                    bCont.page(1);
                    bCont.getBookingList(showloader: false);
                  } else if (v == 2) {
                    bookingController.searchCont.clear();
                    EmployeeReviewController rCont = Get.find();
                    rCont.init();
                  } else {
                    bookingController.searchCont.clear();
                    ProfileController pCont = Get.find();
                    pCont.getOneDayServicePriceData();
                    pCont.getAboutPageData();
                  }
                } catch (e) {
                  log('onItemSelected Err: $e');
                }
              },
              destinations: [
                tab(
                  iconData: Assets.navigationIcHomeOutlined.iconImage(color: darkGray, size: 22),
                  activeIconData: Assets.navigationIcHomeFilled.iconImage(color: context.primaryColor, size: 22),
                  tabName: locale.value.home,
                ),
                tab(
                  iconData: Assets.navigationIcCalendarOutlined.iconImage(color: darkGray, size: 22),
                  activeIconData: Assets.navigationIcCalenderFilled.iconImage(color: context.primaryColor, size: 22),
                  tabName: locale.value.bookings,
                ),
                tab(
                  iconData: Assets.profileIconsIcStarOutlined.iconImage(color: darkGray, size: 22),
                  activeIconData: Assets.navigationIcStarFilled.iconImage(color: context.primaryColor, size: 22),
                  tabName: locale.value.myReviews,
                ),
                tab(
                  iconData: Assets.navigationIcUserOutlined.iconImage(color: darkGray, size: 22),
                  activeIconData: Assets.navigationIcUserFilled.iconImage(color: context.primaryColor, size: 22),
                  tabName: locale.value.profile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  NavigationDestination tab({required Widget iconData, required Widget activeIconData, required String tabName}) {
    return NavigationDestination(
      icon: iconData,
      selectedIcon: activeIconData,
      label: tabName,
    );
  }
}
