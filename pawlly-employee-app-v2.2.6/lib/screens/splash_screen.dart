import 'package:get/get.dart';

import '../../../../../../utils/library.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashScreenController splashController = Get.put(SplashScreenController());

  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        hideAppBar: true,
        scaffoldBackgroundColor: isDarkMode.value ? const Color(0xFF0C0910) : const Color(0xFFFCFCFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isDarkMode.value ? Assets.imagesPawllyLoaderDark : Assets.imagesPawllyLoaderLight,
                height: Constants.appLogoSize,
                width: Constants.appLogoSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const AppLogoWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
