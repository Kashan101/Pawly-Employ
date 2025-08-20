import '../../../../utils/library.dart';

class GreetingsComponentShimmer extends StatelessWidget {
  const GreetingsComponentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShimmerWidget(
          baseColor: isDarkMode.value ? shimmerDarkBaseColor : shimmerPrimaryBaseColor,
          padding: const EdgeInsets.symmetric(horizontal: 108, vertical: 8),
        ),
        ShimmerWidget(
          baseColor: isDarkMode.value ? shimmerDarkBaseColor : shimmerLightBaseColor,
          child: const CircleWidget(height: 26, width: 26),
        )
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
