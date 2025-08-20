import 'package:get/get.dart';

import '../../../../utils/library.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        hideAppBar: true,
        isLoading: profileController.isLoading,
        body: AnimatedScrollView(
          padding: const EdgeInsets.only(top: 39),
          children: [
            CommonAppBar(
              title: locale.value.profile,
              hasLeadingWidget: false,
              action: TextButton(
                onPressed: () {
                  profileController.getOneDayServicePriceData();
                  addOneDayPriceBottomSheet(context);
                },
                child: Text(
                  locale.value.oneDayPrice,
                  style: boldTextStyle(
                    size: 12,
                    color: primaryColor,
                    decorationColor: primaryColor,
                  ),
                ).paddingSymmetric(horizontal: 8),
              ).visible((loginUserData.value.userType.contains(EmployeeKeyConst.boarding) || loginUserData.value.userType.contains(EmployeeKeyConst.dayCare))),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => ProfilePicWidget(
                    heroTag: loginUserData.value.profileImage,
                    profileImage: loginUserData.value.profileImage,
                    firstName: loginUserData.value.firstName,
                    lastName: loginUserData.value.lastName,
                    userName: loginUserData.value.userName,
                    subInfo: loginUserData.value.email,
                    isEditIcon: true,
                    onEditTap: () {
                      Get.to(() => EditUserProfileScreen(), duration: const Duration(milliseconds: 800));
                    },
                  ),
                ),
                32.height,
                SettingSection(
                  title: Text(locale.value.serviceManagement, style: boldTextStyle(color: primaryColor)),
                  headingDecoration: BoxDecoration(color: context.primaryColor.withOpacity(0.1)),
                  headerPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  divider: const Offstage(),
                  items: [
                    SettingItemWidget(
                      title: locale.value.myServices,
                      subTitle: locale.value.manageYourServices,
                      splashColor: transparentColor,
                      onTap: () {
                        Get.to(() => ServiceListScreen());
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.iconsMyServices, icon: Icons.settings_outlined, color: secondaryColor),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ).visible(loginUserData.value.userType.contains(EmployeeKeyConst.veterinary) || loginUserData.value.userType.contains(EmployeeKeyConst.grooming)),
                    SettingItemWidget(
                      title: locale.value.facilityList,
                      subTitle: locale.value.manageYourFacilities,
                      splashColor: transparentColor,
                      onTap: () {
                        Get.to(() => FacilityListScreen());
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.iconsIcFacility, icon: Icons.settings_outlined, color: secondaryColor),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ).visible(loginUserData.value.userType.contains(EmployeeKeyConst.boarding)),
                    SettingItemWidget(
                      title: locale.value.trainingServiceList,
                      subTitle: locale.value.manageTrainingServices,
                      splashColor: transparentColor,
                      onTap: () {
                        Get.to(() => TrainingTypeListScreen());
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.serviceIconsIcTraining, icon: Icons.settings_outlined, color: secondaryColor),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ).visible(loginUserData.value.userType.contains(EmployeeKeyConst.training)),
                    SettingItemWidget(
                      title: locale.value.durationList,
                      subTitle: locale.value.manageYourDurations,
                      splashColor: transparentColor,
                      onTap: () {
                        Get.to(() => DurationListScreen());
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.iconsIcDuration, icon: Icons.settings_outlined, color: secondaryColor),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ).visible(loginUserData.value.userType.contains(EmployeeKeyConst.walking)),
                    commonDivider,
                    SettingItemWidget(
                      title: locale.value.petOwners,
                      subTitle: locale.value.manageNotesForPets,
                      splashColor: transparentColor,
                      onTap: () {
                        Get.to(() => PetOwnersScreen());
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.profileIconsIcUserOutlined, icon: Icons.settings_outlined, color: primaryColor),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ).visible(!loginUserData.value.userType.contains(EmployeeKeyConst.petStore)),
                  ],
                ).visible(!loginUserData.value.userType.contains(EmployeeKeyConst.petStore)),
                if (!loginUserData.value.userType.contains(EmployeeKeyConst.petSitter)) commonDivider,
                if ((loginUserData.value.userRole.contains(EmployeeKeyConst.petStore) && appConfigs.value.isMultiVendorEnable.getBoolInt()) || loginUserData.value.isEnableStore.getBoolInt()) ...[
                  SettingSection(
                    title: Text(locale.value.shop.toUpperCase(), style: boldTextStyle(color: primaryColor)),
                    headingDecoration: BoxDecoration(color: context.primaryColor.withOpacity(0.1)),
                    headerPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    divider: const Offstage(),
                    items: [
                      commonDivider,
                      SettingItemWidget(
                        title: locale.value.products,
                        subTitle: locale.value.manageShopProducts,
                        splashColor: transparentColor,
                        onTap: () {
                          Get.to(() => ShopProductListScreen(), duration: const Duration(milliseconds: 800));
                        },
                        titleTextStyle: primaryTextStyle(),
                        leading: commonLeadingWid(imgPath: Assets.serviceIconsIcPetStore, icon: Icons.settings_outlined, color: secondaryColor),
                        trailing: trailing,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      ),
                      if (!(loginUserData.value.userType.contains(EmployeeKeyConst.petStore)) || !(loginUserData.value.userRole.contains(EmployeeKeyConst.petStore))) commonDivider,
                      if (!(loginUserData.value.userType.contains(EmployeeKeyConst.petStore)) || !(loginUserData.value.userRole.contains(EmployeeKeyConst.petStore)))
                        SettingItemWidget(
                          title: locale.value.orders,
                          subTitle: locale.value.manageOrders,
                          splashColor: transparentColor,
                          onTap: () {
                            Get.to(() => OrderListScreen(), duration: const Duration(milliseconds: 800));
                          },
                          titleTextStyle: primaryTextStyle(),
                          leading: commonLeadingWid(imgPath: Assets.navigationIcShopOutlined, icon: Icons.settings_outlined, color: primaryColor),
                          trailing: trailing,
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                        ),
                      commonDivider,
                      SettingItemWidget(
                        title: locale.value.brands,
                        subTitle: locale.value.manageShopBrands,
                        splashColor: transparentColor,
                        onTap: () {
                          Get.to(() => BrandListScreen(), duration: const Duration(milliseconds: 800));
                        },
                        titleTextStyle: primaryTextStyle(),
                        leading: commonLeadingWid(imgPath: Assets.profileIconsIcBrand, icon: Icons.settings_outlined, color: secondaryColor),
                        trailing: trailing,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      ),
                      commonDivider,
                      SettingItemWidget(
                        title: locale.value.units,
                        subTitle: locale.value.manageShopUnits,
                        splashColor: transparentColor,
                        onTap: () {
                          Get.to(() => UnitsTagsScreen(), arguments: false, duration: const Duration(milliseconds: 800));
                        },
                        titleTextStyle: primaryTextStyle(),
                        leading: commonLeadingWid(imgPath: Assets.profileIconsIcShopUnit, icon: Icons.settings_outlined, color: primaryColor),
                        trailing: trailing,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      ),
                      commonDivider,
                      SettingItemWidget(
                        title: locale.value.tags,
                        subTitle: locale.value.manageShopTags,
                        splashColor: transparentColor,
                        onTap: () {
                          Get.to(() => UnitsTagsScreen(), arguments: true, duration: const Duration(milliseconds: 800));
                        },
                        titleTextStyle: primaryTextStyle(),
                        leading: commonLeadingWid(imgPath: Assets.profileIconsIcShopTag, icon: Icons.settings_outlined, color: secondaryColor),
                        trailing: trailing,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      ),
                    ],
                  ),
                ],
                SettingSection(
                  title: Text(locale.value.others.toUpperCase(), style: boldTextStyle(color: primaryColor)),
                  headingDecoration: BoxDecoration(color: context.primaryColor.withOpacity(0.1)),
                  headerPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  divider: const Offstage(),
                  items: [
                    SettingItemWidget(
                      title: locale.value.settings,
                      subTitle: "${locale.value.appLanguage}, ${locale.value.theme}, ${locale.value.deleteAccount}",
                      splashColor: transparentColor,
                      onTap: () {
                        Get.to(() => SettingScreen());
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.profileIconsIcSettingOutlined, icon: Icons.settings_outlined, color: primaryColor),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ),
                    commonDivider,
                    SettingItemWidget(
                      title: locale.value.rateApp,
                      subTitle: locale.value.showSomeLoveShare,
                      splashColor: transparentColor,
                      onTap: () {
                        handleRate();
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.profileIconsIcStarOutlined, icon: Icons.star_outline_rounded, color: secondaryColor),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ),
                    commonDivider,
                    SettingItemWidget(
                      title: locale.value.aboutApp,
                      subTitle: profileController.getAboutSubtitle(),
                      splashColor: transparentColor,
                      onTap: () {
                        Get.to(() => const AboutScreen());
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.profileIconsIcInfoOutlined, icon: Icons.info_outline_rounded, color: primaryColor),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ),
                    commonDivider,
                    SettingItemWidget(
                      title: locale.value.logout,
                      subTitle: locale.value.securelyLogOutOfAccount,
                      splashColor: transparentColor,
                      onTap: () {
                        profileController.handleLogout(context);
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.profileIconsIcLogoutOutlined, icon: Icons.logout_outlined, color: secondaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ),
                  ],
                ),
                30.height,
                SnapHelperWidget<PackageInfoData>(
                  future: getPackageInfo(),
                  onSuccess: (data) {
                    return VersionInfoWidget(prefixText: 'v', textStyle: primaryTextStyle()).center();
                  },
                ),
                32.height,
              ],
            ),
          ],
        ).visible(!updateUi.value),
      ),
    );
  }

  void addOneDayPriceBottomSheet(BuildContext context) {
    Get.bottomSheet(
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.value.bookingConfiguration,
                      style: primaryTextStyle(size: 18),
                    ),
                    appCloseIconButton(
                      context,
                      onPressed: () {
                        Get.back();
                      },
                      size: 11,
                    ),
                  ],
                ).paddingSymmetric(horizontal: 24),
                Divider(
                  indent: 3,
                  height: 0,
                  color: isDarkMode.value ? borderColor.withOpacity(0.2) : borderColor.withOpacity(0.5),
                ),
                24.height,
                AppTextField(
                  title: loginUserData.value.userType.contains(EmployeeKeyConst.boarding)
                      ? 'Pet Boarding Amount(${appConfigs.value.currency.currencySymbol})'
                      : 'Pet DayCare Amount(${appConfigs.value.currency.currencySymbol})',
                  textStyle: primaryTextStyle(size: 12),
                  controller: profileController.oneDayPriceCont,
                  textFieldType: TextFieldType.NUMBER,
                  focus: profileController.oneDayPriceFocus,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  suffix: Assets.iconsIcPrice.iconImage(fit: BoxFit.contain).paddingAll(14),
                  decoration: inputDecoration(
                    context,
                    hintText: "${locale.value.eG} ${appConfigs.value.currency.currencySymbol}90.00",
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return locale.value.thisFieldIsRequired;
                    } else if (value.startsWith('.') || value.startsWith('-')) {
                      return locale.value.theInputtedPriceIsInvalid;
                    } else if (value.toDouble() == 0.0) {
                      return locale.value.valueMustBeGreater;
                    }
                    return null;
                  },
                ).paddingSymmetric(horizontal: 24),
                8.height,
                Text(
                  loginUserData.value.userType.contains(EmployeeKeyConst.boarding) ? locale.value.enterTheAmountForOneDayBoardingService : locale.value.enterTheAmountForOneDayDaycareService,
                  style: secondaryTextStyle(color: secondaryColor, fontStyle: FontStyle.italic),
                ).paddingSymmetric(horizontal: 24),
                30.height,
                AppButton(
                  width: Get.width,
                  text: locale.value.submit,
                  textStyle: appButtonTextStyleWhite,
                  onTap: () async {
                    if (await isNetworkAvailable()) {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        /// Save One Day Service Price Api Call
                        profileController.saveOneDayServicePriceData();
                      }
                    } else {
                      toast(locale.value.yourInternetIsNotWorking);
                    }
                  },
                ).paddingSymmetric(horizontal: 24),
                16.height,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get trailing => Icon(Icons.arrow_forward_ios, size: 12, color: darkGray.withOpacity(0.5));
}
