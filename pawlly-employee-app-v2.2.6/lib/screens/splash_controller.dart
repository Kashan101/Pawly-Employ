// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';

import '../../../../../../utils/library.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    init();
    try {
      final getThemeFromLocal = getValueFromLocal(SettingsLocalConst.THEME_MODE);
      if (getThemeFromLocal is int) {
        toggleThemeMode(themeId: getThemeFromLocal);
      } else {
        toggleThemeMode(themeId: THEME_MODE_SYSTEM);
      }
      if (Get.context != null) {
        isDarkMode.value
            ? setStatusBarColor(scaffoldDarkColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light)
            : setStatusBarColor(Get.context!.scaffoldBackgroundColor, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light);
      }
    } catch (e) {
      log('getThemeFromLocal from cache E: $e');
    }

    super.onReady();
  }

  void init() {
    getAppConfigurations();
  }
}

///Get ChooseService List
getAppConfigurations() {
  AuthServiceApis.getAppConfigurations(forceConfigSync: true).onError((error, stackTrace) {
    /// Take last configuration data
    try {
      final configurationResFromLocal = getValueFromLocal(APICacheConst.APP_CONFIGURATION_RESPONSE);
      if (configurationResFromLocal != null) {
        appConfigs(ConfigurationResponse.fromJson(configurationResFromLocal));
        appCurrency(appConfigs.value.currency);
      }
    } catch (e) {
      log('configurationResFromLocal from cache E: $e');
    }
  }).whenComplete(() => navigationLogic());
}

void navigationLogic() {
  ///Navigation logic
  if (getValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN) == true) {
    try {
      final userData = getValueFromLocal(SharedPreferenceConst.USER_DATA);
      isLoggedIn(true);
      loginUserData.value = UserData.fromJson(userData);
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.petSitter)) {
        Get.offAll(() => ProfileScreen());
      } else if (loginUserData.value.userRole.contains(EmployeeKeyConst.petStore) && (loginUserData.value.userType.contains(EmployeeKeyConst.petStore))) {
        Get.offAll(() => PetStoreDashboardScreen(), binding: BindingsBuilder(() {
          Get.put(OrderController());
        }));
      } else {
        Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
          Get.put(BookingsController());
        }));
      }
    } catch (e) {
      log('SplashScreenController Err: $e');

      Get.offAll(() => SignInScreen());
    }
  } else {
    Get.offAll(() => SignInScreen());
  }
}
