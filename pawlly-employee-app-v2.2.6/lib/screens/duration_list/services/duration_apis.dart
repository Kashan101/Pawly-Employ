import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/base_response_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/constants.dart';
import '../model/duration_list_response.dart';

class DurationApis {
  //region Get Durations
  static Future<RxList<DurationListData>> getDurations({
    required int employeeId,
    String userType = '',
    int page = 1,
    int perPage = Constants.perPageItem,
    int? isAddedByAdmin,
    required List<DurationListData> list,
    Function(bool)? lastPageCallBack,
  }) async {
    String userRole = userType.isNotEmpty ? 'type=$userType' : '';
    String perPageQuery = '&per_page=$perPage';
    String pageQuery = '&page=$page';
    String addedByAdmin = isAddedByAdmin != null && isAddedByAdmin != 0 ? '&added_by_admin=$isAddedByAdmin' : "";

    final durationRes = DurationListResponse.fromJson(await handleResponse(
      await buildHttpResponse(
        '${APIEndPoints.getDurationList}?$userRole&employee_id=$employeeId$pageQuery$perPageQuery$addedByAdmin',
        method: HttpMethodType.GET,
      ),
    ));

    if (page == 1) list.clear();
    list.addAll(durationRes.data.validate());
    lastPageCallBack?.call(durationRes.data.validate().length != perPage);

    return list.obs;
  }

// region Add Duration
  static Future<BaseResponseModel> addUpdateDuration({String? durationId, required Map request, bool isEdit = false}) async {
    String id = durationId.validate().isNotEmpty ? durationId.validate() : '';
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      isEdit ? '${APIEndPoints.updateServiceDuration}/$id' : APIEndPoints.saveServiceDuration,
      request: request,
      method: HttpMethodType.POST,
    )));
  }

//region Delete Duration
  static Future<BaseResponseModel> removeServiceDuration({required int durationId}) async {
    return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('${APIEndPoints.deleteServiceDuration}/$durationId', method: HttpMethodType.POST),
    ));
  }
}
