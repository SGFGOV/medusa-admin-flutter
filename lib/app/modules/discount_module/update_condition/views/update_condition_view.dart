import 'dart:io';
import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medusa_admin/app/modules/discount_module/discount_conditions/components/condition_product_list_tile.dart';
import 'package:medusa_admin/core/utils/extension.dart';
import 'package:medusa_admin/domain/use_case/update_condition_use_case.dart';
import 'package:medusa_admin_flutter/medusa_admin.dart';
import '../../discount_conditions/components/condition_collection_list_tile.dart';
import '../../discount_conditions/components/condition_customer_group_list_tile.dart';
import '../../discount_conditions/components/condition_tag_list_tile.dart';
import '../../discount_conditions/components/condition_type_list_tile.dart';
import '../controllers/update_condition_controller.dart';

@RoutePage()
class UpdateConditionView extends StatelessWidget {
  const UpdateConditionView(this.updateConditionReq, {super.key});
  final UpdateConditionReq updateConditionReq;

  @override
  Widget build(BuildContext context) {
    final bottomViewPadding = context.bottomViewPadding == 0
        ? 12.0
        : context.bottomViewPadding;
    final topPadding = context.bottomViewPadding == 0
        ? 12.0
        : context.bottomViewPadding/ 2;
    final smallTextStyle = context.bodySmall;

    return GetBuilder<UpdateConditionController>(
      init: UpdateConditionController(updateConditionReq, UpdateConditionUseCase.instance),
      builder: (controller) {
        final buttonText = AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: controller.selectedItems.isEmpty
                ? const Text('Delete condition',
                    style: TextStyle(color: Colors.white), key: Key('delete'))
                : const Text('Update',
                    style: TextStyle(color: Colors.white), key: Key('update')));
        return Scaffold(
          appBar: AppBar(
            title: const Text('Update Condition'),
            actions: [
              TextButton(
                onPressed: () async => await controller.add(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (Platform.isIOS) const Icon(CupertinoIcons.add),
                    if (Platform.isAndroid) const Icon(Icons.add),
                    const Text('Add'),
                  ],
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight / 2),
              child: SizedBox(
                height: kToolbarHeight / 2,
                child: Text(controller.operatorText,
                    style: smallTextStyle, maxLines: 1),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(
                bottom: bottomViewPadding,
                left: 22.0,
                right: 22.0,
                top: topPadding),
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: FilledButton(
              style: FilledButton.styleFrom(
                 backgroundColor: controller.selectedItems.isEmpty ? Colors.redAccent : null,
              ),
              onPressed: () => controller.save(context),
              child: buttonText,
            ),
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                switch (controller.updateConditionReq.discountConditionType) {
                  case DiscountConditionType.products:
                    final item = controller.items[index] as Product;
                    return ProductListTileWithVariantCount(
                      product: item,
                      value: (controller.selectedItems as List<Product>)
                          .map((e) => e.id!)
                          .toList()
                          .contains(item.id),
                      onChanged: (val) {
                        if (val == null) return;
                        if (val) {
                          (controller.selectedItems as List<Product>).add(item);
                        } else {
                          (controller.selectedItems as List<Product>)
                              .removeWhere((element) => element.id == item.id);
                        }
                        controller.update();
                      },
                    );
                  case DiscountConditionType.productType:
                    final item = controller.items[index] as ProductType;
                    return ConditionTypeListTile(
                      type: item,
                      value: (controller.selectedItems as List<ProductType>)
                          .map((e) => e.id!)
                          .toList()
                          .contains(item.id),
                      onChanged: (val) {
                        if (val == null) return;
                        if (val) {
                          (controller.selectedItems as List<ProductType>)
                              .add(item);
                        } else {
                          (controller.selectedItems as List<ProductType>)
                              .removeWhere((element) => element.id == item.id);
                        }
                        controller.update();
                      },
                    );
                  case DiscountConditionType.productCollections:
                    final item = controller.items[index] as ProductCollection;
                    return ConditionCollectionListTile(
                      collection: item,
                      value:
                          (controller.selectedItems as List<ProductCollection>)
                              .map((e) => e.id!)
                              .toList()
                              .contains(item.id),
                      onChanged: (val) {
                        if (val == null) return;
                        if (val) {
                          (controller.selectedItems as List<ProductCollection>)
                              .add(item);
                        } else {
                          (controller.selectedItems as List<ProductCollection>)
                              .removeWhere((element) => element.id == item.id);
                        }
                        controller.update();
                      },
                    );

                  case DiscountConditionType.productTags:
                    final item = controller.items[index] as ProductTag;
                    return ConditionTagListTile(
                      tag: item,
                      value: (controller.selectedItems as List<ProductTag>)
                          .map((e) => e.id!)
                          .toList()
                          .contains(item.id),
                      onChanged: (val) {
                        if (val == null) return;
                        if (val) {
                          (controller.selectedItems as List<ProductTag>)
                              .add(item);
                        } else {
                          (controller.selectedItems as List<ProductTag>)
                              .removeWhere((element) => element.id == item.id);
                        }
                        controller.update();
                      },
                    );

                  case DiscountConditionType.customerGroups:
                    final item = controller.items[index] as CustomerGroup;
                    return ConditionCustomerGroupListTile(
                      customerGroup: item,
                      value: (controller.selectedItems as List<CustomerGroup>)
                          .map((e) => e.id!)
                          .toList()
                          .contains(item.id),
                      onChanged: (val) {
                        if (val == null) return;
                        if (val) {
                          (controller.selectedItems as List<CustomerGroup>)
                              .add(item);
                        } else {
                          (controller.selectedItems as List<CustomerGroup>)
                              .removeWhere((element) => element.id == item.id);
                        }
                        controller.update();
                      },
                    );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
