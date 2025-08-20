import 'package:get/get.dart';

import '../../../../utils/library.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isReviewLoading = false.obs;
  Rx<Future<DashboardRes>> getDashboardDetailFuture = Future(() => DashboardRes(data: DashboardData(petstoreDetail: PetStoreDetail()))).obs;
  Rx<DashboardData> dashboardData = DashboardData(petstoreDetail: PetStoreDetail()).obs;

  @override
  void onReady() {
    init();
    super.onReady();
  }

  void init() {
    try {
      final dashboardResFromLocal = getValueFromLocal(APICacheConst.DASHBOARD_RESPONSE);
      getAppConfigurations();
      if (dashboardResFromLocal != null) {
        handleDashboardRes(DashboardRes.fromJson(dashboardResFromLocal));
      }
    } catch (e) {
      log('handleDashboardRes from cache E: $e');
    }
    getDashboardDetail();
  }

  ///Get ChooseService List
  getDashboardDetail({bool isFromSwipeRefresh = false}) async {
    if (!isFromSwipeRefresh) {
      isLoading(true);
      isReviewLoading(true);
    }
    getAppConfigurations(forceConfigSync: isFromSwipeRefresh);
    await getDashboardDetailFuture(HomeServiceApi.getDashboard()).then((value) {
      handleDashboardRes(value);
      try {
        setValueToLocal(APICacheConst.DASHBOARD_RESPONSE, value.toJson());
      } catch (e) {
        log('store DASHBOARD_RESPONSE E: $e');
      }
    }).whenComplete(() {
      isLoading(false);
      isReviewLoading(false);
    });
  }

  void handleDashboardRes(DashboardRes value) {
    dashboardData(value.data);
  }
}
