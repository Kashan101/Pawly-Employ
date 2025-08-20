import 'package:get/get.dart';
import '../../../../utils/library.dart';
class BookingsRequest extends StatelessWidget {
  BookingsRequest({super.key});

  final HomeController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          ViewAllLabel(
            label: locale.value.bookingRequest,
            isShowAll: homeScreenController.dashboardData.value.bookingRequest.length >= 3,
            onTap: () {
              Get.to(() => BookingScreen(), binding: BindingsBuilder(() {
                try {
                  Get.find<BookingsController>().getBookingList();
                } catch (e) {
                  debugPrint('Get.find<BookingsController>() E: $e');
                }
              }));
            },
          ).paddingSymmetric(horizontal: 16),
          Obx(
            () => AnimatedListView(
              shrinkWrap: true,
              listAnimationType: ListAnimationType.None,
              itemCount: homeScreenController.dashboardData.value.bookingRequest.take(3).length,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return BookingsCard(booking: homeScreenController.dashboardData.value.bookingRequest[index]);
              },
            ),
          ),
        ],
      ).visible(homeScreenController.dashboardData.value.bookingRequest.isNotEmpty),
    );
  }
}
