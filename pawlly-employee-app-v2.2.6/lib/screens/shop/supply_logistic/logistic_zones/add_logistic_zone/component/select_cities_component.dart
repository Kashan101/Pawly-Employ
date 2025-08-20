import 'package:get/get.dart';
import '../../../../../../utils/library.dart';
class SelectCitiesComponent extends StatefulWidget {
  final Function(List<CityData> val) onSelectedList;

  const SelectCitiesComponent({super.key, required this.onSelectedList});

  @override
  State<SelectCitiesComponent> createState() => _SelectCitiesComponentState();
}

class _SelectCitiesComponentState extends State<SelectCitiesComponent> {
  final AddLogisticZoneController addLogisticZoneController = Get.put(AddLogisticZoneController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          AnimatedListView(
            itemCount: addLogisticZoneController.cityList.length,
            shrinkWrap: true,
            itemBuilder: (_, i) {
              return CheckboxListTile(
                checkboxShape: RoundedRectangleBorder(borderRadius: radius(4)),
                autofocus: false,
                activeColor: context.primaryColor,
                checkColor: Get.isDarkMode ? Get.iconColor : context.cardColor,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  addLogisticZoneController.cityList[i].name.validate(),
                  style: secondaryTextStyle(color: Get.iconColor),
                ),
                value: addLogisticZoneController.cityList[i].isSelected,
                onChanged: (bool? val) {
                  addLogisticZoneController.cityList[i].isSelected = !addLogisticZoneController.cityList[i].isSelected.validate();
                  setState(() {});
                },
              );
            },
            onSwipeRefresh: () async {
              addLogisticZoneController.getCities(showLoader: false, stateId: addLogisticZoneController.selectedState.value.id);
              return await Future.delayed(const Duration(seconds: 2));
            },
          ).expand(),
          AppButton(
            text: locale.value.apply,
            textStyle: appButtonTextStyleWhite,
            width: Get.width,
            onTap: () {
              Get.back();
              widget.onSelectedList.call(addLogisticZoneController.cityList.where((element) => element.isSelected == true).map((e) => e).toList());
            },
          )
        ],
      ).expand(),
    );
  }
}
