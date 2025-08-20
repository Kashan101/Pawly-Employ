import 'package:get/get.dart';

import '../../../../utils/library.dart';

class DurationListController extends RxController {
  Rx<Future<RxList<DurationListData>>> getDurationList = Future(() => RxList<DurationListData>()).obs;
  List<DurationListData> durationList = RxList();

  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;

  RxInt selectedFilter = 0.obs;

  @override
  void onReady() {
    getDurationListApi();
    super.onReady();
  }

  getDurationListApi({bool showLoader = true}) {
    if (showLoader) {
      isLoading(true);
    }
    getDurationList(
      DurationApis.getDurations(
        employeeId: loginUserData.value.id,
        isAddedByAdmin: selectedFilter.value,
        userType: ServicesKeyConst.walking,
        list: durationList,
        page: page.value,
        perPage: Constants.perPageItem,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      isLoading(false);
      log('durationListController Error: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> updateDuration({required Map req, required int id}) async {
    isLoading(true);

    DurationApis.addUpdateDuration(
      isEdit: true,
      durationId: id.toString(),
      request: req,
    ).then((value) {
      isLoading(false);
      getDurationListApi();
      toast(value.message);
    }).catchError((e) {
      isLoading(false);
      log("addDurationController Error: ${e.toString()}");
    });
  }
}
