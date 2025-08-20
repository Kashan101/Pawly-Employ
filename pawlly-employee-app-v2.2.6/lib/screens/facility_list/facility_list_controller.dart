import 'package:get/get.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../../utils/library.dart';

class FacilityListController extends RxController {
  Rx<Future<RxList<FacilityListData>>> getFacilityList = Future(() => RxList<FacilityListData>()).obs;
  List<FacilityListData> facilityList = RxList();

  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxBool isSearchFacilityText = false.obs;

  RxInt selectedFilter = 0.obs;

  TextEditingController searchFacilityCont = TextEditingController();

  StreamController<String> searchFacilityStream = StreamController<String>();
  final _scrollController = ScrollController();

  @override
  void onReady() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchFacilityStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getFacilityListApi();
    });
    getFacilityListApi();
    super.onReady();
  }

  getFacilityListApi({bool showLoader = true, String search = ""}) {
    if (showLoader) {
      isLoading(true);
    }

    bool isSearch = false;

    if (searchFacilityCont.text.isNotEmpty) {
      isSearch = true;
    } else {
      isSearch = false;
    }

    getFacilityList(
      FacilityApis.getFacility(
        employeeId: isSearch
            ? loginUserData.value.id
            : selectedFilter.value == 1
                ? null
                : loginUserData.value.id,
        isAddedByAdmin: isSearch ? 1 : selectedFilter.value,
        list: facilityList,
        page: page.value,
        perPage: Constants.perPageItem,
        search: searchFacilityCont.text.trim(),
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      isLoading(false);
      log('facilityListController Error: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> updateFacility({required Map req, required int id}) async {
    isLoading(true);

    FacilityApis.addUpdateFacility(
      isEdit: true,
      facilityId: id.toString(),
      request: req,
    ).then((value) {
      isLoading(false);
      getFacilityListApi();
      toast(value.message);
    }).catchError((e) {
      isLoading(false);
      log("addFacilityController Error: ${e.toString()}");
    });
  }

  @override
  void onClose() {
    searchFacilityStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}
