import 'package:get/get.dart';

import '../../../../utils/library.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);
  final ForgetPasswordController forgetPassController = Get.put(ForgetPasswordController());
  final GlobalKey<FormState> _forgotPassFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isCenterTitle: true,
      appBartitleText: locale.value.forgetPassword,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18, top: 4),
              child: Form(
                key: _forgotPassFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.authImagesForgotPassword,
                      height: Constants.appLogoSignUp,
                      width: Constants.appLogoSignUp,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const AppLogoWidget(),
                    ).paddingTop(2),
                    SizedBox(
                      width: Get.width * 0.8,
                      child: Text(
                        locale.value.toResetYourNew,
                        style: secondaryTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    32.height,
                    AppTextField(
                      title: locale.value.email,
                      controller: forgetPassController.emailCont,
                      // Optional
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecoration(context, fillColor: context.cardColor, filled: true, hintText: "${locale.value.eG}  merry_456@gmail.com"),
                      suffix: Assets.iconsIcMail.iconImage(fit: BoxFit.contain).paddingAll(14),
                    ),
                    64.height,
                    AppButton(
                      width: Get.width,
                      text: locale.value.submit,
                      textStyle: appButtonTextStyleWhite,
                      onTap: () {
                        if (_forgotPassFormKey.currentState!.validate()) {
                          _forgotPassFormKey.currentState!.save();
                          forgetPassController.saveForm();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => const LoaderWidget().center().visible(forgetPassController.isLoading.value)),
          ],
        ),
      ),
    );
  }
}
