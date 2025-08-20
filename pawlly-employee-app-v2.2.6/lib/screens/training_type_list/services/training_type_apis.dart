import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../../../utils/library.dart';

class TrainingTypeApis {
  //region Get Training TypeList
  static Future<RxList<TrainingTypeListData>> getTrainingTypeList({
    int? employeeId,
    String search = '',
    int page = 1,
    int perPage = Constants.perPageItem,
    int? isAddedByAdmin,
    required List<TrainingTypeListData> list,
    Function(bool)? lastPageCallBack,
  }) async {
    String empId = employeeId != null && employeeId != 0 ? 'employee_id=$employeeId' : "";
    String searchTrainingType = search.isNotEmpty ? '&search=$search' : '';
    String perPageQuery = '&per_page=$perPage';
    String pageQuery = '&page=$page';
    String addedByAdmin = isAddedByAdmin != null && isAddedByAdmin != 0
        ? search.isNotEmpty
            ? '&added_by_admin=$isAddedByAdmin'
            : 'added_by_admin=$isAddedByAdmin'
        : "";

    final trainingTypeRes = TrainingTypeListResponse.fromJson(await handleResponse(
      await buildHttpResponse(
        '${APIEndPoints.getTrainingTypeList}?$empId$addedByAdmin$searchTrainingType$pageQuery$perPageQuery',
        method: HttpMethodType.GET,
      ),
    ));

    if (page == 1) list.clear();
    list.addAll(trainingTypeRes.data.validate());
    lastPageCallBack?.call(trainingTypeRes.data.validate().length != perPage);

    return list.obs;
  }

// region Add Training Type
  static Future<BaseResponseModel> addUpdateTrainingType({String? trainingTypeId, required Map request, bool isEdit = false}) async {
    String id = trainingTypeId.validate().isNotEmpty ? trainingTypeId.validate() : '';
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      isEdit ? '${APIEndPoints.updateServiceTraining}/$id' : APIEndPoints.saveServiceTraining,
      request: request,
      method: HttpMethodType.POST,
    )));
  }

  //region Delete Training Type
  static Future<BaseResponseModel> removeTrainingType({required int trainingTypeId}) async {
    return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoints.deleteServiceTraining}/$trainingTypeId', method: HttpMethodType.POST),
    ));
  }
}
