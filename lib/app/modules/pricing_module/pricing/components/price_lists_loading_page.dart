import 'package:flutter/material.dart';
import 'package:medusa_admin_flutter/medusa_admin.dart';
import 'package:medusa_admin/app/modules/pricing_module/pricing/components/price_list_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PriceListsLoadingPage extends StatelessWidget {
  const PriceListsLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const priceList = PriceList(
        name: 'Medusa Js',
        description: 'Medusa Js Price List',
        type: PriceListType.sale,
        status: PriceListStatus.active);
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
            14,
            (index) => index.isEven
                ? const PriceListTile(priceList)
                : const Divider(height: 0, indent: 16.0)),
      ),
    );
  }
}
