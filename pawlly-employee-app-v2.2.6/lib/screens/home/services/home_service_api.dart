import '../../../../utils/library.dart';

class HomeServiceApi {
  static Future<DashboardRes> getDashboard() async {
    return DashboardRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.getEmployeeDashboard, method: HttpMethodType.GET)));
  }

  static Future<AboutPageRes> getAboutPageData() async {
    return AboutPageRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.aboutPages, method: HttpMethodType.GET)));
  }

  static Future<StatusListRes> getAllStatusUsedForBooking() async {
    return StatusListRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.bookingStatus, method: HttpMethodType.GET)));
  }
}
