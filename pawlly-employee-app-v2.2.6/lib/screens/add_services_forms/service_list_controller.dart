import 'package:get/get.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../utils/library.dart';

class ServiceListController extends GetxController {
  Rx<Future<RxList<ServiceData>>> getServices = Future(() => RxList<ServiceData>()).obs;
  RxList<ServiceData> serviceList = RxList();
  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxBool isSearchServiceText = false.obs;

  TextEditingController searchServiceCont = TextEditingController();
  RxString selectedFilterStatus = ServiceFilterStatusConst.all.obs;

  RxList<String> allServiceFilterStatus = RxList([
    ServiceFilterStatusConst.addedByMe,
    ServiceFilterStatusConst.assignByAdmin,
    ServiceFilterStatusConst.all,
  ]);

  StreamController<String> searchServiceStream = StreamController<String>();
  final _scrollController = ScrollController();

  @override
  void onReady() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchServiceStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getServiceList();
    });
    getServiceList();
    super.onReady();
  }

  getServiceList({bool showloader = true, String search = ""}) {
    if (showloader) {
      isLoading(true);
    }
    getServices(ServiceFormApis.getServiceList(
      filterByServiceStatus: selectedFilterStatus.value,
      employeeId: loginUserData.value.id,
      serviceList: serviceList,
      page: page.value,
      search: searchServiceCont.text.trim(),
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    )).whenComplete(() => isLoading(false));
  }

  @override
  void onClose() {
    searchServiceStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}
