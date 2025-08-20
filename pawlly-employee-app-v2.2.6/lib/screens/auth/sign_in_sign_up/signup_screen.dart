import 'package:get/get.dart';
import 'package:pawlly_employee/components/event_file_widget.dart';

import '../../../../utils/library.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final SignUpController signUpController = Get.put(SignUpController());
  final GlobalKey<FormState> _signUpformKey = GlobalKey();
  final ValueNotifier _valueNotifier = ValueNotifier(true);

  Country selectedCountry = defaultCountry();

  String buildMobileNumber() {
    if (signUpController.mobileCont.text.isEmpty) {
      return '';
    } else {
      return '${selectedCountry.phoneCode}-${signUpController.mobileCont.text.trim()}';
    }
  }

  Future<void> changeCountry(BuildContext context) async {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        textStyle: secondaryTextStyle(color: textSecondaryColorGlobal),
        searchTextStyle: primaryTextStyle(),
        margin: EdgeInsets.only(top: 100),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        inputDecoration: InputDecoration(
          labelText: "search",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),

      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      isLoading: signUpController.isLoading,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.authImagesCreateYourAccount,
                    height: Constants.appLogoSignUp,
                    width: Constants.appLogoSignUp,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const AppLogoWidget(),
                  ).paddingTop(46),
                  Text(
                    locale.value.createYourAccount,
                    style: primaryTextStyle(size: 24),
                  ).paddingTop(2),
                  Text(
                    locale.value.createYourAccountFor,
                    style: secondaryTextStyle(size: 14),
                  ).paddingTop(8),
                  Form(
                    key: _signUpformKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppTextField(
                          title: locale.value.firstName,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.fisrtNameCont,
                          focus: signUpController.firstNameFocus,
                          nextFocus: signUpController.lastNameFocus,
                          textFieldType: TextFieldType.NAME,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: "${locale.value.eG} ${locale.value.merry}",
                          ),
                          suffix:
                              Assets.profileIconsIcUserOutlined.iconImage(fit: BoxFit.contain).paddingAll(14),
                        ).paddingTop(16),
                        AppTextField(
                          title: locale.value.lastName,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.lastNameCont,
                          focus: signUpController.lastNameFocus,
                          nextFocus: signUpController.emailFocus,
                          textFieldType: TextFieldType.NAME,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: "${locale.value.eG}  ${locale.value.doe}",
                          ),
                          suffix:
                              Assets.profileIconsIcUserOutlined.iconImage(fit: BoxFit.contain).paddingAll(14),
                        ).paddingTop(16),
                        AppTextField(
                          title: locale.value.email,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.emailCont,
                          focus: signUpController.emailFocus,
                          nextFocus: signUpController.passwordFocus,
                          textFieldType: TextFieldType.EMAIL_ENHANCED,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: "${locale.value.eG} merry_456@gmail.com",
                          ),
                          suffix: Assets.iconsIcMail.iconImage(fit: BoxFit.contain).paddingAll(14),
                        ).paddingTop(16),
                        Obx(
                          () => AppTextField(
                            title: locale.value.selectUserType,
                            textStyle: primaryTextStyle(size: 12),
                            controller: signUpController.userTypeCont,
                            focus: signUpController.userTypeFocus,
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            onTap: () async {
                              chooseEmployeeType(
                                context,
                                isLoading: signUpController.isLoading,
                                onChange: (p0) {
                                  signUpController.selectedUserTypeForLogin(p0);
                                  signUpController.userTypeCont.text = p0.serviceName;
                                },
                              );
                            },
                            decoration: inputDecoration(
                              context,
                              fillColor: context.cardColor,
                              filled: true,
                              prefixIconConstraints: BoxConstraints.loose(const Size.square(60)),
                              prefixIcon: signUpController.selectedUserTypeForLogin.value.icon.isEmpty &&
                                      signUpController.selectedUserTypeForLogin.value.id.isNegative
                                  ? null
                                  : CachedImageWidget(
                                          url: signUpController.selectedUserTypeForLogin.value.icon,
                                          color: signUpController.selectedUserTypeForLogin.value.id.isEven
                                              ? secondaryColor
                                              : primaryColor,
                                          height: 22,
                                          fit: BoxFit.cover,
                                          width: 22)
                                      .paddingOnly(left: 12, top: 8, bottom: 8, right: 12),
                              hintText: "${locale.value.eG} ${EmployeeKeyConst.grooming}",
                              suffixIcon: Icon(Icons.keyboard_arrow_down_rounded,
                                  size: 24, color: darkGray.withOpacity(0.5)),
                            ),
                          ).paddingTop(16),
                        ),
                        AppTextField(
                          title: locale.value.password,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.passwordCont,
                          focus: signUpController.passwordFocus,
                          textFieldType: TextFieldType.PASSWORD,
                          nextFocus: signUpController.mobileFocus,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: "${locale.value.eG} #123@156",
                          ),
                          suffixPasswordVisibleWidget: commonLeadingWid(
                                  imgPath: Assets.iconsIcEye, icon: Icons.password_outlined, size: 14)
                              .paddingAll(12),
                          suffixPasswordInvisibleWidget: commonLeadingWid(
                                  imgPath: Assets.iconsIcEyeSlash, icon: Icons.password_outlined, size: 14)
                              .paddingAll(12),
                        ).paddingTop(16),
                        16.height,
                        Text(locale.value.contactNumber, style: primaryTextStyle()),
                        4.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Country code ...
                            Container(
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Center(
                                child: ValueListenableBuilder(
                                  valueListenable: _valueNotifier,
                                  builder: (context, value, child) => Row(
                                    children: [
                                      Text(
                                        "+${selectedCountry.phoneCode}",
                                        style: primaryTextStyle(size: 12),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: textSecondaryColorGlobal,
                                      )
                                    ],
                                  ).paddingOnly(left: 8),
                                ),
                              ),
                            ).onTap(() => changeCountry(context)),
                            10.width,

                            /// Mobile number text field...
                            AppTextField(
                              textFieldType: isAndroid ? TextFieldType.PHONE : TextFieldType.NAME,
                              controller: signUpController.mobileCont,
                              focus: signUpController.mobileFocus,
                              isValidationRequired: false,
                              maxLength: 15,
                              suffix: Assets.iconsIcCall.iconImage(fit: BoxFit.contain).paddingAll(14),
                              buildCounter: (context,
                                      {required currentLength, required isFocused, required maxLength}) =>
                                  Offstage(),
                              decoration: inputDecoration(
                                context,
                                hintText: "${locale.value.eG}  1-2188219848",
                                fillColor: context.cardColor,
                                filled: true,
                              ),
                            ).expand(),
                          ],
                        ),
                        16.height,
                        Text(locale.value.licenses, style: primaryTextStyle()),
                        4.height,
                        AddFilesWidget(
                          horizontalPadding: 0,
                          fileList: signUpController.licensesFilesList,
                          onFilePick: () {
                            hideKeyboard(context);
                            signUpController.showBottomSheet(context);
                          },
                          onFilePathRemove: (int) {
                            signUpController.licensesFilesList.removeAt(int);
                          },
                        ),
                        16.height,
                        Text(locale.value.certifications, style: primaryTextStyle()),
                        4.height,
                        AddFilesWidget(
                          isCertification: true,
                          horizontalPadding: 0,
                          fileList: signUpController.certificationFilesList,
                          onFilePick: () {
                            hideKeyboard(context);
                            signUpController.showBottomSheet(context,isCertification: true);
                          },
                          onFilePathRemove: (int) {
                            signUpController.certificationFilesList.removeAt(int);
                          },
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Obx(
                                  () => CheckboxListTile(
                                    checkColor: whiteColor,
                                    value: signUpController.isAcceptedTc.value,
                                    activeColor: primaryColor,
                                    visualDensity: VisualDensity.compact,
                                    dense: true,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    contentPadding: EdgeInsets.zero,
                                    onChanged: (val) async {
                                      signUpController.isAcceptedTc.value =
                                          !signUpController.isAcceptedTc.value;
                                    },
                                    checkboxShape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5))),
                                    side: const BorderSide(color: secondaryTextColor, width: 1.5),
                                    title: RichTextWidget(
                                      list: [
                                        TextSpan(
                                            text: '${locale.value.iAgreeToThe} ',
                                            style: secondaryTextStyle()),
                                        TextSpan(
                                          text: locale.value.termsOfService,
                                          style: primaryTextStyle(
                                              color: primaryColor,
                                              size: 12,
                                              decoration: TextDecoration.underline,
                                              decorationColor: primaryColor),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              commonLaunchUrl(TERMS_CONDITION_URL,
                                                  launchMode: LaunchMode.externalApplication);
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ).expand(),
                              ],
                            ),
                          ],
                        ).paddingTop(16),
                        AppButton(
                          width: Get.width,
                          text: locale.value.signUp,
                          textStyle: const TextStyle(fontSize: 14, color: containerColor),
                          onTap: () {
                            if (_signUpformKey.currentState!.validate()) {
                              _signUpformKey.currentState!.save();
                              signUpController.saveForm();
                            }
                          },
                        ).paddingTop(16),
                      ],
                    ),
                  ).paddingTop(30),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(locale.value.alreadyHaveAnAccount, style: secondaryTextStyle()),
                      4.width,
                      TextButton(
                        style:
                            TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                        onPressed: () {
                          Get.back();
                          // Get.offUntil(GetPageRoute(page: () => SignInScreen()), (route) => route.isFirst || route.settings.name == '/OptionScreen');
                        },
                        child: Text(
                          locale.value.signIn,
                          style: primaryTextStyle(
                            color: primaryColor,
                            size: 12,
                            decoration: TextDecoration.underline,
                            decorationColor: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ).paddingTop(8),
                  8.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
