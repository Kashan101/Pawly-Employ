import '../../../../utils/library.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      listAnimationType: ListAnimationType.None,
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        32.height,
        const GreetingsComponentShimmer(),
        const EmployeeReportShimmer().paddingSymmetric(horizontal: 16),
      ],
    );
  }
}
