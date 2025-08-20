// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';

import '../../../../utils/library.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController oneDayPriceCont = TextEditingController();

  FocusNode oneDayPriceFocus = FocusNode();

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    try {
      final aboutPageResFromLocal = getValueFromLocal(APICacheConst.ABOUT_RESPONSE);
      if (aboutPageResFromLocal != null) {
        aboutPages(AboutPageRes.fromJson(aboutPageResFromLocal).data);
      }
    } catch (e) {
      log('aboutPageResFromLocal from cache E: $e');
    }
    getAboutPageData();
    getOneDayServicePriceData();
  }

  handleLogout(BuildContext context) async {
    if (isLoading.value) return;
    showConfirmDialogCustom(
      primaryColor: primaryColor,
      context,
      negativeText: locale.value.cancel,
      positiveText: locale.value.logout,
      onAccept: (_) async {
        isLoading(true);
        log('HANDLELOGOUT: called');
        await AuthServiceApis.logoutApi().then((value) async {
          isLoading(false);
        }).catchError((e) {
          isLoading(false);
          toast(e.toString());
        }).whenComplete(() {
          AuthServiceApis.clearData();
          AuthServiceApis.getAppConfigurations(forceConfigSync: true).onError((error, stackTrace) {
            log('profileController: ${error.toString()}');
          });
          isLoading(false);
          Get.offAll(() => SignInScreen());
        });
      },
      dialogType: DialogType.CONFIRMATION,
      subTitle: locale.value.doYouWantToLogout,
      title: locale.value.ohNoYouAreLeaving,
    );
  }

  handleRate() async {
    if (isAndroid) {
      if (getStringAsync(APP_PLAY_STORE_URL).isNotEmpty) {
        commonLaunchUrl(getStringAsync(APP_PLAY_STORE_URL), launchMode: LaunchMode.externalApplication);
      } else {
        commonLaunchUrl('${getSocialMediaLink(LinkProvider.PLAY_STORE)}${await getPackageName()}', launchMode: LaunchMode.externalApplication);
      }
    } else if (isIOS) {
      if (getStringAsync(APP_APPSTORE_URL).isNotEmpty) {
        commonLaunchUrl(getStringAsync(APP_APPSTORE_URL), launchMode: LaunchMode.externalApplication);
      }
    }
  }

  String getAboutSubtitle() {
    List subtitle = [];
    String text = "";
    if (getPrivacyPolicySubtitle().isNotEmpty) {
      subtitle.add(getPrivacyPolicySubtitle());
    }
    if (getTermsAndConditionSubtitle().isNotEmpty) {
      subtitle.add(getTermsAndConditionSubtitle());
    }

    if (subtitle.length > 1) {
      text = subtitle.join(", ");
    } else {
      text = subtitle.join();
    }
    return text;
  }

  String getPrivacyPolicySubtitle() {
    String text = "";
    for (var element in aboutPages) {
      if (element.slug == PageType.PrivacyPolicy) {
        text = locale.value.privacyPolicy;
        break;
      } else {
        text = "";
      }
    }
    return text;
  }

  String getTermsAndConditionSubtitle() {
    String text = "";
    for (var element in aboutPages) {
      if (element.slug == PageType.TermsAndCondition) {
        text = locale.value.termsConditions;
        break;
      } else {
        text = "";
      }
    }
    return text;
  }

  ///Get ChooseService List
  getAboutPageData() {
    isLoading(true);
    HomeServiceApi.getAboutPageData().then((value) {
      isLoading(false);
      aboutPages(value.data);
      setValueToLocal(APICacheConst.ABOUT_RESPONSE, value.toJson());
    }).onError((error, stackTrace) {
      isLoading(false);
      toast(error.toString());
    });
  }

  ///Get One Day Service Price
  getOneDayServicePriceData() {
    isLoading(true);
    ProfileApis.getOneDayServicePrice().then((value) {
      isLoading(false);
      oneDayPriceCont.text = value.data.amount.toString();
    }).onError((error, stackTrace) {
      isLoading(false);
      log('getOneDayServicePrice  E: $error');
    });
  }

  ///Save One Day Service Price
  saveOneDayServicePriceData() async {
    isLoading(true);
    Get.back();

    Map req = {
      'amount': oneDayPriceCont.text.trim(),
    };

    ProfileApis.saveOneDayServicePrice(request: req).then((value) {
      isLoading(false);
      Get.back();
      toast(value.message);
    }).onError((error, stackTrace) {
      isLoading(false);
      log('getOneDayServicePrice  E: $error');
    });
  }
}
