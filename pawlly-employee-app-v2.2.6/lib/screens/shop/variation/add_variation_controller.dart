import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../../../utils/library.dart';

class AddVariationController extends RxController {
  RxBool isLoading = false.obs;
  RxBool isStatus = true.obs;
  RxBool hasError = false.obs;

  RxString errorMessage = "".obs;

  List<String> variationTypeList = ["Text", "Color"];
  RxList<VariationData> addVariationsTypeList = RxList();

  Rx<String> selectedVariationType = ''.obs;

  TextEditingController variationNameCont = TextEditingController();
  TextEditingController variationTypeCont = TextEditingController();

  @override
  void onInit() {
    variationNameCont.text = '';
    variationTypeCont.text = '';
    selectedVariationType('');
    super.onInit();
  }
}
