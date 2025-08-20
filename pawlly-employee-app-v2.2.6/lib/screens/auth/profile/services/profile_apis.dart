import '../../../../utils/library.dart';

class ProfileApis {
  /// Get One Day Service Price
  static Future<OneDayServicePriceRes> getOneDayServicePrice() async {
    return OneDayServicePriceRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.getOneDayServicePrice, method: HttpMethodType.GET)));
  }

  /// Save One Day Service Price
  static Future<BaseResponseModel> saveOneDayServicePrice({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(
      APIEndPoints.saveOneDayServicePrice,
      request: request,
      method: HttpMethodType.POST,
    )));
  }
}
