import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../../utils/library.dart';

class ServiceFormApis {
  static Future<RxList<ServiceData>> getServiceList({
    required String filterByServiceStatus,
    required int employeeId,
    String search = '',
    int page = 1,
    var perPage = Constants.perPageItem,
    required List<ServiceData> serviceList,
    Function(bool)? lastPageCallBack,
  }) async {
    String searchService = search.isNotEmpty ? '&search=$search' : '';
    String statusFilter = filterByServiceStatus.isNotEmpty ? '&service_type=$filterByServiceStatus' : '';

    var res = ServiceListResponse.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.serviceList}?employee_id=$employeeId$statusFilter$searchService&per_page=$perPage&page=$page", method: HttpMethodType.GET)));

    if (page == 1) serviceList.clear();
    serviceList.addAll(res.serviceData.validate());

    lastPageCallBack?.call(res.serviceData.validate().length != perPage);

    return serviceList.obs;
  }

  static Future<BaseResponseModel> removeService({required int serviceId}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.deleteService}?id=$serviceId', method: HttpMethodType.GET)));
  }

  static Future<CategoryRes> getCategory({required String categoryType}) async {
    return CategoryRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getCategory}?type=$categoryType", method: HttpMethodType.GET)));
  }

  static Future<dynamic> addServices({
    bool isEdit = false,
    String serviceId = '',
    String name = '',
    String durationMin = '',
    String defaultPrice = '',
    String type = '',
    String description = '',
    String categoryId = '',
    File? imageFile,
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      MultipartRequest multiPartRequest = await getMultiPartRequest(isEdit ? APIEndPoints.updateService : APIEndPoints.addService);
      if (serviceId.isNotEmpty) multiPartRequest.fields[ServiceConst.id] = serviceId;
      if (name.isNotEmpty) multiPartRequest.fields[ServiceConst.name] = name;
      if (durationMin.isNotEmpty) multiPartRequest.fields[ServiceConst.durationMin] = durationMin;
      if (defaultPrice.isNotEmpty) multiPartRequest.fields[ServiceConst.defaultPrice] = defaultPrice;
      if (description.isNotEmpty) multiPartRequest.fields[ServiceConst.description] = description;
      if (type.isNotEmpty) multiPartRequest.fields[ServiceConst.type] = type;
      if (categoryId.isNotEmpty) multiPartRequest.fields[ServiceConst.categoryId] = categoryId;
      if (imageFile != null) {
        // multiPartRequest.files.addAll(await getMultipartImages2(files: files.validate(), name: 'feature_image'));
        multiPartRequest.files.add(await MultipartFile.fromPath('feature_image', imageFile.path));
      }

      log("Multipart ${jsonEncode(multiPartRequest.fields)}");
      log("Multipart Images ${multiPartRequest.files.map((e) => e.filename)}");
      multiPartRequest.headers.addAll(buildHeaderTokens());

      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          onSuccess?.call(data);
        },
        onError: (error) {
          throw error;
        },
      ).catchError((error) {
        throw error;
      });
    }
  }

  static Future<dynamic> addServicesTraining({
    String name = '',
    String type = '',
    String description = '',
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoints.addServiceTraining);
      if (name.isNotEmpty) multiPartRequest.fields[ServiceConst.name] = name;
      if (description.isNotEmpty) multiPartRequest.fields[ServiceConst.description] = description;
      if (type.isNotEmpty) multiPartRequest.fields[ServiceConst.type] = type;
      multiPartRequest.headers.addAll(buildHeaderTokens());
      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          onSuccess?.call(data);
        },
        onError: (error) {
          throw error;
        },
      ).catchError((error) {
        throw error;
      });
    }
  }
}
