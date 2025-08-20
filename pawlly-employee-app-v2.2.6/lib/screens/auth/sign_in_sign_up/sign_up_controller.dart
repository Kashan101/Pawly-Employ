// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart' as dio;

import '../../../../utils/library.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool agree = false.obs;
  RxBool isAcceptedTc = false.obs;
  TextEditingController emailCont = TextEditingController();
  TextEditingController fisrtNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController userTypeCont = TextEditingController();
  RxList<File> licensesFilesList = <File>[].obs;
  RxList<File> certificationFilesList = <File>[].obs;

  FocusNode emailFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode userTypeFocus = FocusNode();

  // Rx<File> licensesFile = File("").obs;
  // Rx<File> certificationFile = File("").obs;

  Rx<DemoLoginData> selectedUserTypeForLogin = DemoLoginData().obs;

  // Map<String, dynamic> formDataToMap(dio.FormData formData) {
  //   return {for (var entry in formData.fields) entry.key: entry.value};
  // }

  saveForm() async {
    if (isAcceptedTc.value) {
      if (licensesFilesList.isNotEmpty && certificationFilesList.isNotEmpty) {
        isLoading(true);
        hideKeyBoardWithoutContext();
        dio.FormData req = dio.FormData();
        req.fields.add(MapEntry('email', emailCont.text.trim()));
        req.fields.add(MapEntry('first_name', fisrtNameCont.text.trim()));
        req.fields.add(MapEntry('last_name', lastNameCont.text.trim()));
        req.fields.add(MapEntry('mobile', mobileCont.text.trim()));
        req.fields.add(MapEntry('password', passwordCont.text.trim()));
        req.fields.add(MapEntry(UserKeys.userType, selectedUserTypeForLogin.value.userType));
        for (File fileData in certificationFilesList) {
          if (await fileData.exists()) {
            req.files.add(
              MapEntry(
                'certificates',
                await dio.MultipartFile.fromFile(fileData.path),
              ),
            );
          } else {
            print("File does not exist: ${fileData.path}");
          }
        }
        for (File fileData in licensesFilesList) {
          if (await fileData.exists()) {
            req.files.add(
              MapEntry(
                'licenses',
                await dio.MultipartFile.fromFile(
                  fileData.path,
                ),
              ),
            );
          } else {
            print("File does not exist: ${fileData.path}");
          }
        }

        debugPrint("UploadFileRequestModel: ${req.files}");
        debugPrint("UploadFileRequestModel: ${req.fields}");

        await AuthServiceApis.createUser(request: req,isFormData: true).then((value) async {
          try {
            final SignInController sCont = Get.find();
            sCont.emailCont.text = emailCont.text.trim();
            sCont.passwordCont.text = passwordCont.text.trim();
          } catch (e) {
            log('E: $e');
            isLoading(false);
            toast(e.toString(), print: true);
          }
          Get.back();
          toast(value.message.toString(), print: true);
        }).catchError((e) {
        isLoading(false);
          toast(e.toString(), print: true);
        }).whenComplete(() => isLoading(false));
      } else {
        toast("Please check ${locale.value.licenses} and ${locale.value.certifications}");
      }
    } else {
      toast(locale.value.pleaseAcceptTermsAnd);
    }
  }

  Future<void> _handleGalleryClick({bool isCertification = false}) async {
    // Request storage permission before picking an image

    var status = await Permission.storage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      print("Storage permission denied");
      return;
    }
    Get.back();
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      isCertification
          ? certificationFilesList.add(File(pickedFile.path))
          : licensesFilesList.value = [File(pickedFile.path)];
    }
  }

  Future<void> _handleCameraClick({bool isCertification = false}) async {
    // Request storage permission before picking an image

    var status = await Permission.camera.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      print("Storage permission denied");
      return;
    }
    Get.back();
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      isCertification
          ? certificationFilesList.add(File(pickedFile.path))
          : licensesFilesList.value = [File(pickedFile.path)];
    }
  }

  void showBottomSheet(BuildContext context, {bool isCertification = false}) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: locale.value.gallery,
              leading: const Icon(Icons.image, color: primaryColor),
              onTap: () async {
                _handleGalleryClick(isCertification: isCertification);
              },
            ),
            SettingItemWidget(
              title: locale.value.camera,
              leading: const Icon(Icons.camera, color: primaryColor),
              onTap: () {
                _handleCameraClick(isCertification: isCertification);
              },
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }
}
