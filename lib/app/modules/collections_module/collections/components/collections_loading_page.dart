import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medusa_admin_flutter/medusa_admin.dart';
import 'package:medusa_admin/app/modules/collections_module/collections/components/collection_list_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CollectionsLoadingPage extends StatelessWidget {
  const CollectionsLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final collection = ProductCollection(title: 'Collection', handle: 'medusa',updatedAt: DateTime.now(),
    products: []
    );
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(10, (index) => CollectionListTile(collection,tileColor: index.isOdd
            ? context.theme.appBarTheme.backgroundColor
            : null)),
      ),
    );
  }
}
