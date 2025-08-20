// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import '../../../../utils/library.dart';
class ChangePassController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newpasswordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  saveForm() async {
    isLoading(true);
    if (getValueFromLocal(SharedPreferenceConst.USER_PASSWORD) != oldPasswordCont.text.trim()) {
      return toast(locale.value.yourOldPasswordDoesnT);
    } else if (newpasswordCont.text.trim() != confirmPasswordCont.text.trim()) {
      return toast(locale.value.yourNewPasswordDoesnT);
    }
    hideKeyBoardWithoutContext();

    Map<String, dynamic> req = {
      'old_password': getValueFromLocal(SharedPreferenceConst.USER_PASSWORD),
      'new_password': confirmPasswordCont.text.trim(),
    };

    await AuthServiceApis.changePasswordAPI(request: req).then((value) async {
      isLoading(false);
      setValueToLocal(SharedPreferenceConst.USER_PASSWORD, confirmPasswordCont.text.trim());
      Get.to(() => const PasswordSetSuccess());
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }
}
