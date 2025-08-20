
import 'package:get/get.dart';
import '../../../../utils/library.dart';
class AddFacilityController extends GetxController {
  TextEditingController facilityNameCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode facilityNameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  Rx<FacilityListData> facilityData = FacilityListData(id: (-1).obs, status: false.obs).obs;

  RxBool isLoading = false.obs;
  RxBool isEdit = false.obs;
  RxBool isStatus = true.obs;

  @override
  void onInit() {
    if (Get.arguments is FacilityListData) {
      facilityData(Get.arguments as FacilityListData);
      isEdit(true);
      facilityNameCont.text = facilityData.value.name;
      descriptionCont.text = facilityData.value.description;
      isStatus = facilityData.value.status.value ? true.obs : false.obs;
    }

    super.onInit();
  }

  Future<void> addFacility() async {
    String id = '';
    isLoading(true);
    hideKeyBoardWithoutContext();

    if (isEdit.value) {
      id = facilityData.value.id.value.toString();
    }

    Map request = {
      "name": facilityNameCont.text.trim(),
      "description": descriptionCont.text.trim(),
      "status": isStatus.value ? "1" : "0",
    };

    FacilityApis.addUpdateFacility(
      isEdit: isEdit.value,
      facilityId: id,
      request: request,
    ).then((value) {
      Get.back(result: true);
      isLoading(false);
      toast(value.message);
    }).catchError((e) {
      isLoading(false);
      log("addFacilityController Error: ${e.toString()}");
    });
  }
}
