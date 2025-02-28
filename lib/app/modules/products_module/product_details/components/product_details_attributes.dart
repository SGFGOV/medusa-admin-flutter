import 'package:auto_route/auto_route.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:medusa_admin_flutter/medusa_admin.dart';
import 'package:medusa_admin/app/modules/components/countries/components/countries.dart';
import 'package:medusa_admin/app/modules/products_module/add_update_product/controllers/add_update_product_controller.dart';
import 'package:medusa_admin/core/utils/colors.dart';
import 'package:medusa_admin/core/utils/extension.dart';
import 'package:medusa_admin/route/app_router.dart';
import '../controllers/product_details_controller.dart';
import 'package:flex_expansion_tile/flex_expansion_tile.dart';

class ProductDetailsAttributes extends GetView<ProductDetailsController> {
  const ProductDetailsAttributes(
      {super.key,
      required this.product,
      this.onExpansionChanged,
      this.expansionKey});
  final Product product;
  final void Function(bool)? onExpansionChanged;
  final Key? expansionKey;

  @override
  Widget build(BuildContext context) {
    const space = Gap(12);
    final manatee = ColorManager.manatee;
    final mediumTextStyle = context.bodyMedium;
    return FlexExpansionTile(
      key: expansionKey,
      onExpansionChanged: onExpansionChanged,
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text('Attributes'),
      trailing: TextButton(
          onPressed: () async {
            await context
                .pushRoute(AddUpdateProductRoute(
                    updateProductReq:
                        UpdateProductReq(product: product, number: 3)))
                .then((result) async {
              if (result != null) {
                await controller.fetchProduct();
              }
            });
          },
          child: const Text('Edit')),
      childPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dimensions', style: mediumTextStyle),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text('Height',
                          style: mediumTextStyle!.copyWith(color: manatee))),
                  Expanded(
                      flex: 2,
                      child: Text(product.height?.toString() ?? '-',
                          style: mediumTextStyle.copyWith(color: manatee),
                          textAlign: TextAlign.right)),
                ],
              ),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text('Width',
                          style: mediumTextStyle.copyWith(color: manatee))),
                  Expanded(
                      flex: 2,
                      child: Text(product.width?.toString() ?? '-',
                          style: mediumTextStyle.copyWith(color: manatee),
                          textAlign: TextAlign.right)),
                ],
              ),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text('Length',
                          style: mediumTextStyle.copyWith(color: manatee))),
                  Expanded(
                      flex: 2,
                      child: Text(product.length?.toString() ?? '-',
                          style: mediumTextStyle.copyWith(color: manatee),
                          textAlign: TextAlign.right)),
                ],
              ),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text('Weight',
                          style: mediumTextStyle.copyWith(color: manatee))),
                  Expanded(
                      flex: 2,
                      child: Text(product.weight?.toString() ?? '-',
                          style: mediumTextStyle.copyWith(color: manatee),
                          textAlign: TextAlign.right)),
                ],
              ),
              space,
              space,
              Text('Customs', style: mediumTextStyle),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text('MID Code',
                          style: mediumTextStyle.copyWith(color: manatee))),
                  Expanded(
                      flex: 2,
                      child: Text(product.midCode?.toString() ?? '-',
                          style: mediumTextStyle.copyWith(color: manatee),
                          textAlign: TextAlign.right)),
                ],
              ),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text('HS Code',
                          style: mediumTextStyle.copyWith(color: manatee))),
                  Expanded(
                      flex: 2,
                      child: Text(product.hsCode?.toString() ?? '-',
                          style: mediumTextStyle.copyWith(color: manatee),
                          textAlign: TextAlign.right)),
                ],
              ),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Country of origin',
                      style: mediumTextStyle.copyWith(color: manatee)),
                  Row(
                    children: [
                      Text(
                          countries
                              .firstWhereOrNull((element) =>
                          element.iso2 == product.originCountry)
                              ?.displayName ??
                              '-',
                          style: mediumTextStyle.copyWith(color: manatee),
                          textAlign: TextAlign.right),
                      Flag.fromString(product.originCountry ?? ' ',
                          height: 15, width: 30),
                    ],
                  ),
                ],
              ),
              space,
            ],
          )
        ],
      ),
    );
  }
}
