import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medusa_admin/app/modules/components/scrolling_expandable_fab.dart';
import 'package:medusa_admin/app/modules/groups_module/groups/controllers/groups_controller.dart';
import 'package:medusa_admin/core/utils/extension.dart';
import 'package:medusa_admin/domain/use_case/group_details_use_case.dart';
import 'package:medusa_admin/route/app_router.dart';
import 'package:medusa_admin_flutter/medusa_admin.dart';
import '../../../../../core/utils/colors.dart';
import '../controllers/group_details_controller.dart';

@RoutePage()
class GroupDetailsView extends StatelessWidget {
  const GroupDetailsView(this.customerGroup, {super.key});
  final CustomerGroup customerGroup;
  @override
  Widget build(BuildContext context) {
    final smallTextStyle = context.bodySmall;
    final largeTextStyle = context.bodyLarge;

    return GetBuilder<GroupDetailsController>(
        init: GroupDetailsController(
            groupDetailsUseCase: GroupDetailsUseCase.instance,
            groupCustomer: customerGroup),
        builder: (controller) {
          return Scaffold(
              floatingActionButton: ScrollingExpandableFab(
                controller: controller.scrollController,
                label: 'Add Customers',
                icon: const Icon(CupertinoIcons.person_add_solid),
                onPressed: () async => await controller.addCustomers(context),
              ),
              body: CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: Text(customerGroup.name ?? ''),
                    actions: [
                      IconButton(
                          onPressed: () async {
                            await showModalActionSheet<int>(
                                title: 'Manage group',
                                message: customerGroup.name ?? '',
                                context: context,
                                actions: <SheetAction<int>>[
                                  const SheetAction(label: 'Edit', key: 0),
                                  const SheetAction(
                                      label: 'Delete',
                                      isDestructiveAction: true,
                                      key: 1),
                                ]).then((result) async {
                              switch (result) {
                                case 0:
                                  await context
                                      .pushRoute(CreateUpdateGroupRoute(
                                          customerGroup: customerGroup))
                                      .then((value) {
                                    if (value is CustomerGroup) {
                                      // customerGroup = value;
                                      GroupsController.instance.pagingController
                                          .refresh();
                                    }
                                  });
                                  break;
                                case 1:
                                  await showOkCancelAlertDialog(
                                    context: context,
                                    title: 'Delete the group',
                                    message:
                                        'Are you sure you want to delete this customer group?',
                                    okLabel: 'Yes, delete',
                                    isDestructiveAction: true,
                                  ).then((value) async {
                                    if (value == OkCancelResult.ok) {
                                      await controller.deleteGroup(context);
                                    }
                                  });

                                  break;
                              }
                            });
                          },
                          icon: const Icon(Icons.more_horiz))
                    ],
                  ),
                  PagedSliverList(
                    pagingController: controller.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Customer>(
                        itemBuilder: (context, customer, index) {
                          final name = customer.fullName;
                          return ListTile(
                            onTap: () => context.pushRoute(
                                CustomerDetailsRoute(customerId: customer.id!)),
                            leading: CircleAvatar(
                              backgroundColor:
                                  ColorManager.getAvatarColor(customer.email),
                              radius: 16,
                              child: Text(
                                  name?[0].capitalize ??
                                      customer.email[0].capitalize ??
                                      '',
                                  style: largeTextStyle?.copyWith(
                                      color: Colors.white)),
                            ),
                            title: Text(name ?? customer.email),
                            subtitle: name != null
                                ? Text(customer.email, style: smallTextStyle)
                                : null,
                            trailing: IconButton(
                                onPressed: () async {
                                  await showModalActionSheet<int>(
                                      context: context,
                                      actions: <SheetAction<int>>[
                                        const SheetAction(
                                            label: 'Customer details', key: 0),
                                        const SheetAction(
                                            label: 'Delete from the group',
                                            isDestructiveAction: true,
                                            key: 1),
                                      ]).then((result) async {
                                    switch (result) {
                                      case 0:
                                        context.pushRoute(CustomerDetailsRoute(
                                            customerId: customer.id!));
                                        break;
                                      case 1:
                                        await showOkCancelAlertDialog(
                                                context: context,
                                                title: 'Delete the group',
                                                message:
                                                    'Are you sure you want to delete this customer from  group?',
                                                okLabel: 'Yes, delete',
                                                cancelLabel: 'No, cancel',
                                                isDestructiveAction: true)
                                            .then((value) async {
                                          if (value == OkCancelResult.ok) {
                                            await controller
                                                .deleteCustomer(customer.id!);
                                          }
                                        });

                                        break;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.more_horiz)),
                          );
                        },
                        firstPageProgressIndicatorBuilder: (context) =>
                            const Center(
                                child: CircularProgressIndicator.adaptive()),
                        noItemsFoundIndicatorBuilder: (context) => const Center(
                            child: Text('No customers in this group yet'))),
                  ),
                ],
              ));
        });
  }
}
