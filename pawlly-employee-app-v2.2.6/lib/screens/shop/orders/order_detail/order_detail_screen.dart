import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

import '../../../../../utils/library.dart';

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({Key? key}) : super(key: key);

  final OrderDetailController orderDetailController = Get.put(OrderDetailController());
  final OrderController orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: Obx(
        () => Text(
          "${orderDetailController.orderCode.value.isNotEmpty ? "#" : ""}${orderDetailController.orderCode.value}",
          style: primaryTextStyle(size: 16, decoration: TextDecoration.none),
        ),
      ),
      isLoading: orderDetailController.isLoading,
      body: Obx(
        () => SnapHelperWidget(
          future: orderDetailController.getOrderDetailFuture.value,
          loadingWidget: const LoaderWidget(),
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                orderDetailController.isLoading(true);

                orderDetailController.init();
              },
            );
          },
          onSuccess: (snap) {
            if (snap.data.id.isNegative) {
              return NoDataWidget(
                title: locale.value.noDetailFound,
                retryText: locale.value.reload,
                onRetry: () {
                  orderDetailController.isLoading(true);

                  orderDetailController.init();
                },
              );
            }

            return AnimatedScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                OrderInformationComponent(orderData: snap.data),
                16.height,
                AboutProductComponent(productData: snap.data.orderDetails.productDetails, deliveryStatus: snap.data.deliveryStatus),
                16.height,
                OrderPaymentInfoComponent(orderData: snap.data),
                16.height,
                if (snap.data.orderDetails.otherOrderItems.isNotEmpty)
                  OtherProductItemsComponent(
                    otherProductItemList: snap.data.orderDetails.otherOrderItems,
                  ).paddingBottom(16),
                if (snap.data.orderDetails.otherOrderItems.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${locale.value.grandTotal} ', style: primaryTextStyle(size: 14)),
                      PriceWidget(price: snap.data.orderDetails.grandTotal, size: 14),
                    ],
                  ),
                8.height,
                ShippingDetailComponent(shippingData: snap.data),
                16.height,
                if (snap.data.deliveryStatus.contains(OrderStatus.Processing)) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      25.height,
                      AppButton(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        text: locale.value.delivered,
                        width: Get.width,
                        color: primaryColor,
                        textStyle: appButtonTextStyleWhite,
                        onTap: () {
                          showConfirmDialogCustom(getContext, primaryColor: primaryColor, negativeText: locale.value.cancel, positiveText: locale.value.yes, onAccept: (_) {
                            orderDetailController.isLoading(true);
                            orderController.updateDeliveryStatus(
                              orderId: snap.data.orderDetails.productDetails.orderId,
                              orderItemId: snap.data.orderDetails.productDetails.id,
                              status: OrderStatus.Delivered,
                              onUpdateDeliveryStatus: () {
                                orderDetailController.init();
                                orderController.page(1);
                                orderController.getOrderList();
                                orderDetailController.isLoading(false);
                              },
                            );
                          }, dialogType: DialogType.ACCEPT, title: locale.value.haveYouDeliveredThe);
                        },
                      ),
                      25.height,
                    ],
                  ),
                ],
                Obx(
                  () => confirmPaymentBtn(
                    context,
                    orderId: snap.data.orderDetails.productDetails.orderId,
                    orderItemId: snap.data.orderDetails.productDetails.id,
                  ).visible(!snap.data.paymentStatus.contains(PaymentStatus.PAID) && snap.data.deliveryStatus.toLowerCase().contains(OrderStatus.Delivered.toLowerCase())),
                ),
              ],
              onSwipeRefresh: () async {
                orderDetailController.init();
                return await 2.seconds.delay;
              },
            );
          },
        ),
      ),
    );
  }

  Widget confirmPaymentBtn(BuildContext context, {required int orderId, required int orderItemId}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        25.height,
        AppButton(
          width: Get.width,
          text: locale.value.confirmCashPayment,
          textStyle: appButtonTextStyleWhite,
          color: completedStatusColor,
          onTap: () {
            showConfirmDialogCustom(getContext, primaryColor: primaryColor, negativeText: locale.value.cancel, positiveText: locale.value.yes, onAccept: (_) {
              orderDetailController.updatePaymentStatus(orderId: orderId, orderItemId: orderItemId);
            }, dialogType: DialogType.ACCEPT, title: "${locale.value.doYouWantToConfirmPayment}?");
          },
        ),
        25.height,
      ],
    );
  }
}
