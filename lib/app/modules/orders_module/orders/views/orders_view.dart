import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medusa_admin_flutter/medusa_admin.dart';
import 'package:medusa_admin/app/data/service/storage_service.dart';
import 'package:medusa_admin/app/modules/components/drawer_widget.dart';
import 'package:medusa_admin/app/modules/components/pagination_error_page.dart';
import 'package:medusa_admin/app/modules/components/scrolling_expandable_fab.dart';
import 'package:medusa_admin/app/modules/components/search_floating_action_button.dart';
import 'package:medusa_admin/app/modules/orders_module/orders/components/orders_filter_view.dart';
import 'package:medusa_admin/app/modules/orders_module/orders/components/orders_loading_page.dart';
import 'package:medusa_admin/core/utils/extension.dart';
import 'package:medusa_admin/core/utils/medusa_icons_icons.dart';
import 'package:medusa_admin/domain/use_case/orders_use_case.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../core/utils/enums.dart';
import '../components/order_card.dart';
import '../controllers/orders_controller.dart';
import 'package:gap/gap.dart';

@RoutePage()
class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
        init: OrdersController(ordersUseCase: OrdersUseCase.instance),
        builder: (controller) {
          final orderSettings = StorageService.orderSettings;
          return Scaffold(
            drawerEdgeDragWidth: context.drawerEdgeDragWidth,
            drawer: const AppDrawer(),
            endDrawer: Drawer(
              child: OrdersFilterView(
                orderFilter: controller.orderFilter,
                onResetTap: () {
                  controller.resetFilter();
                  context.popRoute();
                },
                onSubmitted: (result) {
                  if (result != null) {
                    controller.updateFilter(result);
                  }
                },
              ),
            ),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SearchFloatingActionButton(
                        searchCategory: SearchCategory.orders),
                    Gap(4.0),
                  ],
                ),
                const Gap(6.0),
                ScrollingExpandableFab(
                  heroTag: const ValueKey('orders fab'),
                  controller: controller.scrollController,
                  label: 'Export Orders',
                  icon: const Icon(MedusaIcons.arrow_up_tray),
                  onPressed: () {},
                ),
              ],
            ),
            body: SmartRefresher(
              controller: controller.refreshController,
              onRefresh: () async => await controller.refreshData(),
              header:  const MaterialClassicHeader(offset: 100),
              child: CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  SliverAppBar(
                    title: Obx(
                      () => Text(
                          controller.ordersCount.value != 0
                              ? 'Orders (${controller.ordersCount.value})'
                              : 'Orders',
                          overflow: TextOverflow.ellipsis),
                    ),
                    floating: true,
                    snap: true,
                    actions: [
                      Builder(builder: (context) {
                        return GetBuilder<OrdersController>(
                            builder: (controller) {
                          final iconColor =
                              (controller.orderFilter?.count() ?? -1) > 0
                                  ? Colors.red
                                  : null;
                          return IconButton(
                              onPressed: () {
                                context.openEndDrawer();
                              },
                              icon: Icon(Icons.sort, color: iconColor));
                        });
                      })
                    ],
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: 120,
                        top: orderSettings.padding,
                        left: orderSettings.padding,
                        right: orderSettings.padding),
                    sliver: PagedSliverList.separated(
                      separatorBuilder: (_, __) => const Gap(8.0),
                      pagingController: controller.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Order>(
                        itemBuilder: (context, order, index) {
                          if (orderSettings.alternativeCard) {
                            return AlternativeOrderCard(order);
                          }
                          return OrderCard(order);
                        },
                        noItemsFoundIndicatorBuilder: (_) {
                          if ((controller.orderFilter?.count() ?? -1) > 0) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('No Orders found'),
                                TextButton(
                                    onPressed: () => controller.resetFilter(),
                                    child: const Text('Clear filters'))
                              ],
                            );
                          }

                          return const Center(child: Text('No orders yet!'));
                        },
                        firstPageProgressIndicatorBuilder: (context) =>
                            const OrdersLoadingPage(),
                        firstPageErrorIndicatorBuilder: (context) =>
                            PaginationErrorPage(
                                pagingController: controller.pagingController),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
