import 'package:get/get.dart';

import '../../../../../../utils/library.dart';
class AddTrainingTypeController extends GetxController {
  TextEditingController trainingTypeNameCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode trainingTypeNameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  Rx<TrainingTypeListData> trainingTypeData = TrainingTypeListData(id: (-1).obs, status: false.obs).obs;

  RxBool isLoading = false.obs;
  RxBool isEdit = false.obs;
  RxBool isStatus = true.obs;

  RxList<DurationListData> addDurationListWidget = RxList();

  @override
  void onInit() {
    if (Get.arguments is TrainingTypeListData) {
      trainingTypeData(Get.arguments as TrainingTypeListData);
      isEdit(true);
      trainingTypeNameCont.text = trainingTypeData.value.name;
      descriptionCont.text = trainingTypeData.value.description;
      isStatus = trainingTypeData.value.status.value ? true.obs : false.obs;
      trainingTypeData.value.duration.forEach((element) {
        DurationListData durationListData = DurationListData(
          id: (-1).obs,
          index: addDurationListWidget.length,
          addDurationCount: addDurationListWidget.length + 1,
          durationHourCont: TextEditingController(text: element.duration.split(':').first),
          durationHourFocus: FocusNode(),
          durationMinuteCont: TextEditingController(text: element.duration.split(':').last),
          durationMinuteFocus: FocusNode(),
          durationPriceCont: TextEditingController(text: element.amount.toString()),
          durationPriceFocus: FocusNode(),
          durationStatus: element.durationStatus,
        );

        // Add the durations to addDurationListWidget
        addDurationListWidget.add(durationListData);
      });
    } else {
      // Add first Element of Duration List
      addDurationListWidget.add(
        DurationListData(
          id: (-1).obs,
          index: addDurationListWidget.length,
          addDurationCount: addDurationListWidget.length + 1,
          durationHourCont: TextEditingController(),
          durationHourFocus: FocusNode(),
          durationMinuteCont: TextEditingController(),
          durationMinuteFocus: FocusNode(),
          durationPriceCont: TextEditingController(),
          durationPriceFocus: FocusNode(),
          durationStatus: true.obs,
        ),
      );
    }
    super.onInit();
  }

  bool checkForDuplicateDurations() {
    Set<String> durations = {};
    for (var element in addDurationListWidget) {
      String duration = '${element.durationHourCont!.text}:${element.durationMinuteCont!.text}';
      if (durations.contains(duration)) {
        return false;
      }
      durations.add(duration);
    }
    return true;
  }

  Future<void> addTrainingType() async {
    String id = '';
    isLoading(true);
    hideKeyBoardWithoutContext();

    if (isEdit.value) {
      id = trainingTypeData.value.id.value.toString();
    }

    Map request = {
      "name": trainingTypeNameCont.text.trim(),
      "description": descriptionCont.text.trim(),
      "status": isStatus.value ? "1" : "0",
      "durations": jsonEncode(addDurationListWidget.map((e) => e.toJsonRequest()).toList()),
    };

    TrainingTypeApis.addUpdateTrainingType(
      isEdit: isEdit.value,
      trainingTypeId: id,
      request: request,
    ).then((value) {
      Get.back(result: true);
      isLoading(false);
      toast(value.message);
    }).catchError((e) {
      isLoading(false);
      log("addTrainingController Error: ${e.toString()}");
    });
  }
}
