import 'package:get/get.dart';

import '../../../../utils/library.dart';

class PetStoreDashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  List screen = [
    StoreHomeScreen(),
    OrderListScreen(isHideBack: true),
    OrderReviewScreen(),
    ProfileScreen(),
  ];

  @override
  void onInit() {
    init();
    super.onInit();
  }

  @override
  void onReady() {
    if (Get.context != null) {
      View.of(Get.context!).platformDispatcher.onPlatformBrightnessChanged = () {
        WidgetsBinding.instance.handlePlatformBrightnessChanged();
        try {
          final getThemeFromLocal = getValueFromLocal(SettingsLocalConst.THEME_MODE);
          if (getThemeFromLocal is int) {
            toggleThemeMode(themeId: getThemeFromLocal);
          }
        } catch (e) {
          log('getThemeFromLocal from cache E: $e');
        }
      };
    }
    Future.delayed(const Duration(seconds: 2), () {
      if (Get.context != null) {
        showForceUpdateDialog(Get.context!);
      }
    });
    super.onReady();
  }

  void init() {
    try {
      final statusListResFromLocal = getValueFromLocal(APICacheConst.STATUS_RESPONSE);
      if (statusListResFromLocal != null) {
        allStatus(StatusListRes.fromJson(statusListResFromLocal).data);
      }
    } catch (e) {
      log('statusListResFromLocal from cache E: $e');
    }
    try {
      final petCenterResFromLocal = getValueFromLocal(APICacheConst.PET_CENTER_RESPONSE);
      if (petCenterResFromLocal != null) {
        petCenterDetail(PetCenterRes.fromJson(petCenterResFromLocal).data);
      }
    } catch (e) {
      log('petCenterResFromLocal from cache E: $e');
    }
    getPetCenterDetail();
    getAppConfigurations();
  }

  getPetCenterDetail() {
    isLoading(true);
    AuthServiceApis.getPetCenterDetail().then((value) {
      isLoading(false);
      petCenterDetail(value.data);
      setValueToLocal(APICacheConst.PET_CENTER_RESPONSE, value.toJson());
    }).onError((error, stackTrace) {
      isLoading(false);
      toast(error.toString());
    });
  }

  ///Get AppConfiguration
  getAppConfigurations() {
    AuthServiceApis.getAppConfigurations(forceConfigSync: true).onError((error, stackTrace) {
      toast(error.toString());
      log('configurationResFromLocal from cache E: ${error.toString()}');
    });
  }
}

void bottomNavigateByIndex(int index) {
  try {
    final PetStoreDashboardController dashboardController = Get.find();
    if (!index.isNegative && index < dashboardController.screen.length) {
      dashboardController.currentIndex(index);
      try {
        if (index == 0) {
          StoreHomeController hCont = Get.find();
          hCont.init();
        } else if (index == 1) {
          StoreHomeController hCont = Get.find();
          hCont.init();
        } else if (index == 2) {
          OrderReviewController rCont = Get.find();
          rCont.init();
        } else {
          ProfileController pCont = Get.find();
          pCont.getAboutPageData();
        }
      } catch (e) {
        log('onItemSelected Err: $e');
      }
    }
  } catch (e) {
    log('dashboardController = Get.find E: $e');
  }
}
