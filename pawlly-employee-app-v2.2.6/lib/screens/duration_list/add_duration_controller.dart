import 'package:get/get.dart';
import '../../../../utils/library.dart';

class AddDurationController extends GetxController {
  TextEditingController durationHourCont = TextEditingController();
  TextEditingController durationMinuteCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();

  RxList<String> durationList = RxList<String>(['30 Minutes', '1 Hours']);
  RxString duration = ''.obs;

  FocusNode durationHourFocus = FocusNode();
  FocusNode durationMinuteFocus = FocusNode();
  FocusNode priceFocus = FocusNode();

  Rx<DurationListData> durationData = DurationListData(id: (-1).obs, durationStatus: false.obs).obs;

  RxBool isLoading = false.obs;
  RxBool isEdit = false.obs;
  RxBool isStatus = true.obs;

  @override
  void onInit() {
    if (Get.arguments is DurationListData) {
      durationData(Get.arguments as DurationListData);
      isEdit(true);
      durationHourCont.text = durationData.value.duration.split(':').first;
      durationMinuteCont.text = durationData.value.duration.split(':').last;
      priceCont.text = durationData.value.price.toString();
      isStatus = durationData.value.durationStatus.value ? true.obs : false.obs;
    }
    duration.value = durationList.first;
    super.onInit();
  }

  Future<void> addDuration() async {
    String id = '';
    isLoading(true);
    hideKeyBoardWithoutContext();

    if (isEdit.value) {
      id = durationData.value.id.value.toString();
    }

    Map request = {
      "hours": durationHourCont.text.trim(),
      "minutes": durationMinuteCont.text.trim(),
      "price": priceCont.text.trim(),
      "status": isStatus.value ? "1" : "0",
    };

    DurationApis.addUpdateDuration(
      isEdit: isEdit.value,
      durationId: id,
      request: request,
    ).then((value) {
      Get.back(result: true);
      isLoading(false);
      toast(value.message);
    }).catchError((e) {
      isLoading(false);
      log("addDurationController Error: ${e.toString()}");
    });
  }
}
