import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../utils/library.dart';

class FacilityApis {
  //region Get Product
  static Future<RxList<FacilityListData>> getFacility({
    int? employeeId,
    String search = '',
    int page = 1,
    int perPage = Constants.perPageItem,
    int? isAddedByAdmin,
    required List<FacilityListData> list,
    Function(bool)? lastPageCallBack,
  }) async {
    String empId = employeeId != null && employeeId != 0 ? 'employee_id=$employeeId' : "";
    String searchFacility = search.isNotEmpty ? '&search=$search' : '';
    String perPageQuery = '&per_page=$perPage';
    String pageQuery = '&page=$page';
    String addedByAdmin = isAddedByAdmin != null && isAddedByAdmin != 0
        ? search.isNotEmpty
            ? '&added_by_admin=$isAddedByAdmin'
            : 'added_by_admin=$isAddedByAdmin'
        : "";

    final facilityRes = FacilityListResponse.fromJson(await handleResponse(
      await buildHttpResponse(
        '${APIEndPoints.getFacility}?$empId$addedByAdmin$searchFacility$pageQuery$perPageQuery',
        method: HttpMethodType.GET,
      ),
    ));

    if (page == 1) list.clear();
    list.addAll(facilityRes.data.validate());
    lastPageCallBack?.call(facilityRes.data.validate().length != perPage);

    return list.obs;
  }

  // region Add Facility
  static Future<BaseResponseModel> addUpdateFacility({String? facilityId, required Map request, bool isEdit = false}) async {
    String id = facilityId.validate().isNotEmpty ? facilityId.validate() : '';
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      isEdit ? '${APIEndPoints.updateServiceFacility}/$id' : APIEndPoints.saveServiceFacility,
      request: request,
      method: HttpMethodType.POST,
    )));
  }

  //region Get Facility
  static Future<BaseResponseModel> removeFacility({required int facilityId}) async {
    return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoints.deleteServiceFacility}/$facilityId', method: HttpMethodType.POST),
    ));
  }
}
