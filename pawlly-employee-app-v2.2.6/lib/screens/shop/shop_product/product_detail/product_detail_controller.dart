import 'package:get/get.dart';

import '../../../../../utils/library.dart';

class ProductDetailController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<Future<ProductDetailResponse>> productDetailsFuture = Future(() => ProductDetailResponse(data: ProductItemDataResponse(inWishlist: false.obs, id: (-1).obs))).obs;
  Rx<ProductDetailResponse> productDetailRes = ProductDetailResponse(data: ProductItemDataResponse(inWishlist: false.obs, id: (-1).obs)).obs;
  Rx<VariationData> selectedVariationData = VariationData().obs;

  PageController pageController = PageController(keepPage: true, initialPage: 0);

  RxInt productId = (-1).obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    if (Get.arguments is int) {
      productId(Get.arguments as int);
    }
    getProductDetails();
  }

  getProductDetails({bool isFromSwipeRefresh = false}) {
    if (!isFromSwipeRefresh) {
      isLoading(true);
    }

    productDetailsFuture(ShopProductAPI.getProductDetails(productId: productId.value)).then((value) {
      productDetailRes(value);
      if (productDetailRes.value.data.variationData.isNotEmpty) {
        selectedVariationData(productDetailRes.value.data.variationData.first);
      }
    }).catchError((e) {
      log('Error: $e');
      throw errorSomethingWentWrong;
    }).whenComplete(() => isLoading(false));
  }
}
