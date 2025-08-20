import 'package:get/get.dart';

import '../../../../utils/library.dart';

class StoreHomeController extends GetxController with GetSingleTickerProviderStateMixin {
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    await getAllStatusUsedForOrder();
  }

  getAllStatusUsedForOrder() {
    isLoading(true);
    OrderAPIs.getOrderFilterStatus().then((value) {
      isLoading(false);
      allOrderStatus(value.data);
    }).onError((error, stackTrace) {
      isLoading(false);
      toast(error.toString());
    });
  }
}
