import 'package:get/get.dart';

import '../../../../utils/library.dart';

class EmployeeReportShimmer extends StatelessWidget {
  const EmployeeReportShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      spacing: 16,
      runSpacing: 16,
      itemCount: 6,
      listAnimationType: ListAnimationType.FadeIn,
      itemBuilder: (ctx, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: Get.width / 2 - 24,
          decoration: boxDecorationDefault(color: context.cardColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShimmerWidget(
                    baseColor: shimmerLightBaseColor,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(8)),
                    ),
                  ).expand(),
                  36.width,
                  ShimmerWidget(
                    baseColor: shimmerLightBaseColor,
                    child: CircleWidget(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(16)),
                    ),
                  )
                ],
              ),
              24.height,
              ShimmerWidget(
                baseColor: shimmerLightBaseColor,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 8),
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(8)),
                ),
              )
            ],
          ).expand(),
        );
      },
    );
  }
}
