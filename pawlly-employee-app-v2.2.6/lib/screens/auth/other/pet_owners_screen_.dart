import 'package:get/get.dart';

import '../../../../utils/library.dart';

class PetOwnersScreen extends StatelessWidget {
  PetOwnersScreen({super.key});

  final PetOwnersController petOwnersController = Get.put(PetOwnersController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: "Pet Owners",
      isLoading: petOwnersController.isLoading,
      body: Obx(
        () => SnapHelperWidget(
          future: petOwnersController.getPetOwners.value,
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                petOwnersController.page = 1;
                petOwnersController.init();
              },
            ).paddingSymmetric(horizontal: 32);
          },
          loadingWidget: const LoaderWidget(),
          onSuccess: (petOwners) {
            petOwners.removeWhere((element) => element.pets.isEmpty);
            return petOwners.isEmpty
                ? SizedBox(
                    height: Get.height * 0.7,
                    child: NoDataWidget(
                      title: locale.value.noDataFound,
                      subTitle: locale.value.currentlyThereAreNo,
                      titleTextStyle: primaryTextStyle(),
                      imageWidget: const EmptyStateWidget(),
                      retryText: locale.value.reload,
                      onRetry: () {
                        petOwnersController.page = 1;
                        petOwnersController.init();
                      },
                    ).paddingSymmetric(horizontal: 32),
                  )
                : AnimatedScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: petOwners.length,
                        itemBuilder: (context, index) {
                          PetOwner petOwner = petOwners[index];
                          List<String> petImgList = petOwner.pets.map((e) => e.petImage).toList();
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => MyPetsScreen(petOwner: petOwner));
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: context.cardColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: boxDecorationDefault(color: Colors.white, shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: CachedImageWidget(
                                      url: petOwner.profileImage,
                                      firstName: petOwner.firstName,
                                      lastName: petOwner.lastName,
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                      circle: true,
                                    ),
                                  ),
                                  8.height,
                                  Text(
                                    petOwner.fullName,
                                    style: primaryTextStyle(decoration: TextDecoration.none),
                                  ),
                                  8.height,
                                  FlutterImageStack(
                                    imageList: petImgList.reversed.toList(),
                                    totalCount: petImgList.length,
                                    itemCount: 3,
                                    showTotalCount: true,
                                    itemRadius: 35,
                                    itemBorderWidth: 2,
                                    itemBorderColor: primaryColor,
                                    onCallBack: () {},
                                    backgroundColor: context.scaffoldBackgroundColor,
                                    extraCountTextStyle: secondaryTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    onNextPage: () {
                      if (!petOwnersController.isLastPage.value) {
                        petOwnersController.page++;
                        petOwnersController.init(showLoader: false);
                      }
                    },
                    onSwipeRefresh: () async {
                      petOwnersController.page = 1;
                      return await petOwnersController.init(showLoader: false);
                    },
                  );
          },
        ),
      ),
    );
  }
}
