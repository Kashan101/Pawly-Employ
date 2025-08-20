import 'package:get/get.dart';

import '../../../../../utils/library.dart';

class SelectCategoryComponent extends StatefulWidget {
  final Function(List<ShopCategory> val) onSelectedList;

  const SelectCategoryComponent({super.key, required this.onSelectedList});

  @override
  State<SelectCategoryComponent> createState() => _SelectCategoryComponentState();
}

class _SelectCategoryComponentState extends State<SelectCategoryComponent> {
  final AddShopProductController addShopProductController = Get.put(AddShopProductController());

  bool isExpanded = false;
  bool selectedValue = false;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          AnimatedListView(
            itemCount: addShopProductController.shopCategoryList.length,
            shrinkWrap: true,
            itemBuilder: (_, i) {
              return CheckboxListTile(
                checkboxShape: RoundedRectangleBorder(borderRadius: radius(4)),
                autofocus: false,
                activeColor: context.primaryColor,
                checkColor: Get.isDarkMode ? Get.iconColor : context.cardColor,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  addShopProductController.shopCategoryList[i].name.validate(),
                  style: secondaryTextStyle(color: Get.iconColor),
                ),
                value: addShopProductController.shopCategoryList[i].isSelected,
                onChanged: (bool? val) {
                  addShopProductController.shopCategoryList[i].isSelected = !addShopProductController.shopCategoryList[i].isSelected.validate();
                  setState(() {});
                },
              );
            },
            onNextPage: () {
              if (!addShopProductController.isLastPage.value) {
                addShopProductController.categoryPage++;
                addShopProductController.getCategoryList(showLoader: true);
              }
            },
            onSwipeRefresh: () async {
              addShopProductController.categoryPage(1);
              addShopProductController.getCategoryList(showLoader: false);
              return await Future.delayed(const Duration(seconds: 2));
            },
          ).expand(),
          AppButton(
            text: locale.value.apply,
            textStyle: appButtonTextStyleWhite,
            width: Get.width,
            onTap: () {
              Get.back();
              widget.onSelectedList.call(addShopProductController.shopCategoryList.where((element) => element.isSelected == true).map((e) => e).toList()); //
            },
          )
        ],
      ).expand(),
    );
  }
}
