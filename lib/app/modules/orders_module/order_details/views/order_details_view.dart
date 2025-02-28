import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:medusa_admin/core/utils/extension.dart';
import 'package:medusa_admin/domain/use_case/order_details_use_case.dart';
import 'package:medusa_admin_flutter/medusa_admin.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../components/index.dart';
import '../controllers/order_details_controller.dart';

@RoutePage()
class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView(this.orderId, {super.key});
  final String orderId;

  @override
  Widget build(BuildContext context) {
    const space = Gap(12);
    final tr = context.tr;

    return GetBuilder<OrderDetailsController>(
      init: OrderDetailsController(
          orderDetailsUseCase: OrderDetailsUseCase.instance, orderId: orderId),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: context.defaultSystemUiOverlayStyle,
            title: Hero(tag: 'order', child: Text(tr.orderTableOrder)),
            actions: [
              if (controller.state?.status != OrderStatus.canceled)
                IconButton(
                    onPressed: () async {
                      await showModalActionSheet<int>(
                          context: context,
                          actions: <SheetAction<int>>[
                            SheetAction(
                              label: tr.detailsCancelOrderHeading,
                              key: 0,
                              isDestructiveAction: true,
                            ),
                          ]).then((result) async {
                        switch (result) {
                          case 0:
                            final order = controller.state!;
                            await showTextAnswerDialog(
                              title: tr.detailsCancelOrderHeading,
                              message:
                                  tr.detailsAreYouSureYouWantToCancelTheOrder,
                              retryMessage:
                                  'Make sure to type the name "order #${order.displayId!}" to confirm order deletion.',
                              retryOkLabel: 'Retry',
                              context: context,
                              keyword: 'order #${order.displayId!}',
                              isDestructiveAction: true,
                              hintText: 'order #${order.displayId!}',
                              okLabel: 'Yes, confirm',
                            ).then((value) async {
                              if (value) {
                                await controller.cancelOrder();
                              }
                            });
                            return;
                        }
                      });
                    },
                    icon: const Icon(Icons.more_horiz)),
            ],
          ),
          body: SafeArea(
            child: SmartRefresher(
              controller: controller.refreshController,
              onRefresh: () async {
                await controller.fetchOrderDetails();
                controller.timeLineFuture = controller.fetchTimeLine();
              },
              header: const MaterialClassicHeader(),
              child: controller.obx(
                (order) => SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10.0),
                    child: Column(
                      children: [
                        OrderOverview(order: order!),
                        space,
                        OrderSummery(
                          order,
                          onExpansionChanged: (expanded) async {
                            if (expanded) {
                              await controller.summeryKey.currentContext!
                                  .ensureVisibility();
                            }
                          },
                          key: controller.summeryKey,
                        ),
                        space,
                        OrderPayment(
                          order,
                          onExpansionChanged: (expanded) async {
                            if (expanded) {
                              await controller.paymentKey.currentContext
                                  .ensureVisibility();
                            }
                          },
                        ),
                        space,
                        OrderFulfillment(
                          order,
                          onExpansionChanged: (expanded) async {
                            if (expanded) {
                              await controller.fulfillmentKey.currentContext
                                  .ensureVisibility();
                            }
                          },
                        ),
                        space,
                        OrderCustomer(
                          order,
                          onExpansionChanged: (expanded) async {
                            if (expanded) {
                              await controller.customerKey.currentContext
                                  .ensureVisibility();
                            }
                          },
                        ),
                        space,
                        OrderTimeline(
                          order,
                          onExpansionChanged: (expanded) async {
                            if (expanded) {
                              await controller.timelineKey.currentContext
                                  .ensureVisibility();
                            }
                          },
                        ),
                        const SizedBox(height: 25.0),
                      ],
                    ),
                  ),
                ),
                onError: (e) =>
                    OrderDetailsErrorPage(e ?? '', onRetryTap: () async {
                  await controller.fetchOrderDetails();
                  controller.timeLineFuture = controller.fetchTimeLine();
                }),
                onLoading: const OrderDetailsLoadingPage(),
              ),
            ),
          ),
        );
      },
    );
  }
}
