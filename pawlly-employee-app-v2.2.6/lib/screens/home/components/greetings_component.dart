import 'package:get/get.dart';

import '../../../../utils/library.dart';

class GreetingsComponent extends StatelessWidget {
  final HomeController homeController = Get.find();

  GreetingsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => Text(
            '${locale.value.hello}, ${loginUserData.value.userName.isNotEmpty ? loginUserData.value.userName : locale.value.guest} 👋',
            style: primaryTextStyle(size: 20),
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => NotificationScreen());
              },
              behavior: HitTestBehavior.translucent,
              child: Image.asset(Assets.iconsIcNotification, width: 26, height: 26),
            ),
            Positioned(
              top: homeController.dashboardData.value.notificationCount < 10 ? -8 : -4,
              right: homeController.dashboardData.value.notificationCount < 10 ? 0 : 0,
              child: Obx(() => Container(
                    padding: const EdgeInsets.all(4),
                    decoration: boxDecorationDefault(color: primaryColor, shape: BoxShape.circle),
                    child: Text(
                      '${homeController.dashboardData.value.notificationCount}',
                      style: primaryTextStyle(size: homeController.dashboardData.value.notificationCount < 10 ? 10 : 8, color: white),
                    ),
                  ).visible(homeController.dashboardData.value.notificationCount > 0)),
            ),
          ],
        ),
      ],
    ).paddingOnly(left: 16, right: 16, top: 16);
  }
}
