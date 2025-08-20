import 'package:get/get.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../../../../utils/library.dart';

class TrainingTypeListController extends RxController {
  Rx<Future<RxList<TrainingTypeListData>>> getTrainingTypeList = Future(() => RxList<TrainingTypeListData>()).obs;
  List<TrainingTypeListData> trainingTypeList = RxList();

  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxBool isSearchTrainingTypeText = false.obs;

  RxInt selectedFilter = 0.obs;

  TextEditingController searchTrainingTypeCont = TextEditingController();

  StreamController<String> searchTrainingTypeStream = StreamController<String>();
  final _scrollController = ScrollController();

  @override
  void onReady() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchTrainingTypeStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getTrainingTypeListApi();
    });
    getTrainingTypeListApi();
    super.onReady();
  }

  getTrainingTypeListApi({bool showLoader = true, String search = ""}) {
    if (showLoader) {
      isLoading(true);
    }

    bool isSearch = false;

    if (searchTrainingTypeCont.text.isNotEmpty) {
      isSearch = true;
    } else {
      isSearch = false;
    }

    getTrainingTypeList(
      TrainingTypeApis.getTrainingTypeList(
        employeeId: isSearch
            ? loginUserData.value.id
            : selectedFilter.value == 1
                ? null
                : loginUserData.value.id,
        isAddedByAdmin: isSearch ? 1 : selectedFilter.value,
        list: trainingTypeList,
        page: page.value,
        perPage: Constants.perPageItem,
        search: searchTrainingTypeCont.text.trim(),
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      isLoading(false);
      log('trainingTypeListController Error: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> updateTrainingType({required Map req, required int id}) async {
    isLoading(true);

    TrainingTypeApis.addUpdateTrainingType(
      isEdit: true,
      trainingTypeId: id.toString(),
      request: req,
    ).then((value) {
      isLoading(false);
      getTrainingTypeListApi();
      toast(value.message);
    }).catchError((e) {
      isLoading(false);
      log("addTrainingTypeListController Error: ${e.toString()}");
    });
  }

  @override
  void onClose() {
    searchTrainingTypeStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}
