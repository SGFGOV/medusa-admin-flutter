import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:medusa_admin/app/data/helper/image_picker_helper.dart';
import 'package:medusa_admin/domain/use_case/update_product_use_case.dart';
import 'package:medusa_admin_flutter/medusa_admin.dart';
import 'package:medusa_admin/app/modules/components/countries/components/countries.dart';
import 'package:medusa_admin/app/modules/components/easy_loading.dart';
import 'package:medusa_admin/core/utils/extension.dart';
import 'package:medusa_admin/core/utils/extensions/snack_bar_extension.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flex_expansion_tile/flex_expansion_tile.dart';

class AddUpdateProductController extends GetxController {
  AddUpdateProductController(
      {required this.updateProductUseCase,
      this.updateProductReq});
  final UpdateProductUseCase updateProductUseCase;
  final titleCtrl = TextEditingController();
  final subtitleCtrl = TextEditingController();
  final handleCtrl = TextEditingController();
  final materialCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  final generalKey = GlobalKey();
  final organizeKey = GlobalKey();
  final variantKey = GlobalKey();
  final attributesKey = GlobalKey();
  final thumbnailKey = GlobalKey();
  final mediaKey = GlobalKey();
  final generalTileCtrl = FlexExpansionTileController();
  final organizeTileCtrl = FlexExpansionTileController();
  final variantTileCtrl = FlexExpansionTileController();
  final attributeTileCtrl = FlexExpansionTileController();
  final thumbnailTileCtrl = FlexExpansionTileController();
  final mediaTileCtrl = FlexExpansionTileController();
  List<ProductCollection>? collections;
  List<ProductType>? productTypes;
  ProductCollection? selectedCollection;
  List<ImageData> imagesToDelete = [];
  ProductType? selectedProductType;
  bool discountable = true;
  bool enableSalesChannels = false;
  bool deleteThumbnail = false;
  List<SalesChannel>? salesChannels;
  List<String> selectedSalesChannels = [];
  final optionCtrl = TextEditingController();
  final variationsCtrl = TextEditingController();
  final widthCtrl = TextEditingController();
  final lengthCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final midCodeCtrl = TextEditingController();
  final hsCodeCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final optionKeyForm = GlobalKey<FormState>();
  bool updateMode = false;
  final UpdateProductReq? updateProductReq;
  File? thumbnailImage;
  List<File> images = [];
  late Product product;
  late ImagePickerHelper imagePickerHelper;
  @override
  Future<void> onInit() async {
    imagePickerHelper = ImagePickerHelper();
    fetchProduct();
    fetchSalesChannels();
    fetchOrganize();
    super.onInit();
  }

  @override
  void onReady() {
    if (updateProductReq != null) {
      switch (updateProductReq!.number) {
        case 0:
          generalTileCtrl.expand();
        case 1:
          organizeTileCtrl.expand();
        case 2:
          variantTileCtrl.expand();
        case 3:
          attributeTileCtrl.expand();
        case 4:
          thumbnailTileCtrl.expand();
        case 5:
          mediaTileCtrl.expand();
      }
    }
    super.onReady();
  }

  Future<List<SalesChannel>?> fetchSalesChannels() async {
    final result = await updateProductUseCase.retrieveSalesChannels();
    return result.when((success) {
      if (success.salesChannels != null) {
        salesChannels = success.salesChannels;
        update([1]);
        return salesChannels!;
      } else {
        return [];
      }
    }, (error) {
      return null;
    });
  }

  Future<void> fetchOrganize() async {
    final result = await updateProductUseCase.retrieveProductTypes();
    result.when((success) {
      productTypes = success.productTypes;
      if (updateProductReq != null) {
        final q = productTypes?.where(
            (element) => element.id == updateProductReq!.product.type?.id);
        selectedProductType = (q?.isNotEmpty ?? false) ? q?.first : null;
      }
    }, (error) => null);
    final result2 = await updateProductUseCase.retrieveCollections();
    result2.when((success) {
      collections = success.collections;
      if (updateProductReq != null) {
        final q = collections?.where((element) =>
            element.id == updateProductReq!.product.collection?.id);
        selectedCollection = (q?.isNotEmpty ?? false) ? q?.first : null;
      }
    }, (error) => null);
    update([1]);
  }

  @override
  void onClose() {
    optionCtrl.dispose();
    variationsCtrl.dispose();
    titleCtrl.dispose();
    subtitleCtrl.dispose();
    handleCtrl.dispose();
    materialCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }

  Future<void> addProduct(BuildContext context) async {
    // TODO: check for required fields
    if (!keyForm.currentState!.validate()) {
      if (!generalTileCtrl.isExpanded) {
        generalTileCtrl.expand();
      }
      return;
    }
    context.unfocus();

    product = product.copyWith(title: titleCtrl.text);
    if (enableSalesChannels && selectedSalesChannels.isNotEmpty) {
      product = product.copyWith(
          salesChannels: selectedSalesChannels
              .map((e) => SalesChannel(name: '', id: e))
              .toList());
    }
    loading();
    final result = await updateProductUseCase.addProduct(
         UserPostProductReq(product: product));
    result.when((success) async {
      EasyLoading.showSuccess('New product Added');
      await _uploadImages(id: success.id!, images: images, context: context)
          .then((value) async {
        await _uploadThumbnail(
                id: success.id!, thumbnail: thumbnailImage, context: context)
            .then((value) => context.popRoute(true));
      });
    }, (error) {
      dismissLoading();
      context.showSnackBar(error.toSnackBarString());
    });
  }

  Future<void> updateProduct(BuildContext context) async {
    // Check if there's no update to the product, in that case just go back.
    // Hide the keyboard
    context.unfocus();
    loading();

    final imagesToKeep = List<ImageData>.from(product.images ?? []);
    imagesToKeep.removeWhere((element) =>
        imagesToDelete.map((e) => e.url).toList().contains(element.url));

    final shouldUpdateSalesChannel = !const ListEquality().equals(
        product.salesChannels?.map((e) => e.id).toList(),
        selectedSalesChannels);

    final result = await updateProductUseCase.updateProduct(
      id: product.id!,
      userPostUpdateProductReq: UserPostUpdateProductReq(
        title: product.title == titleCtrl.text ? null : titleCtrl.text,
        subtitle:
            product.subtitle == subtitleCtrl.text ? null : subtitleCtrl.text,
        handle: product.handle == handleCtrl.text ? null : handleCtrl.text,
        material:
            product.material == materialCtrl.text ? null : materialCtrl.text,
        description: product.description == descriptionCtrl.text
            ? null
            : descriptionCtrl.text,
        discountable:
            product.discountable == discountable ? null : discountable,
        tags: product.tags,
        type: selectedProductType,
        collectionId: selectedCollection?.id,
        weight: product.weight.toString() == weightCtrl.text
            ? null
            : int.tryParse(weightCtrl.text),
        width: product.width.toString() == widthCtrl.text
            ? null
            : int.tryParse(widthCtrl.text),
        height: product.height.toString() == heightCtrl.text
            ? null
            : int.tryParse(heightCtrl.text),
        length: product.length.toString() == lengthCtrl.text
            ? null
            : int.tryParse(lengthCtrl.text),
        midCode: product.midCode == midCodeCtrl.text ? null : midCodeCtrl.text,
        hsCode: product.hsCode == hsCodeCtrl.text ? null : hsCodeCtrl.text,
        originCountry: product.originCountry,
        images: imagesToKeep.map((e) => e.url!).toList(),
        thumbnail: deleteThumbnail && thumbnailImage == null ? '' : null,
        salesChannels: shouldUpdateSalesChannel ? selectedSalesChannels
                .map((e) => SalesChannel(name: '', id: e))
                .toList()
            : null,
      ),
    );
    result.when(
      (product) async {
        EasyLoading.showSuccess('Product Updated');
        await _uploadImages(
          id: product.id!,
          context: context,
          images: images,
          imagesToKeep: imagesToKeep.map((e) => e.url!).toList(),
        ).then((value) async {
          await _uploadThumbnail(
            id: product.id!,
            context: context,
            thumbnail: thumbnailImage,
          ).then((value) async {
            if (imagesToDelete.isNotEmpty) {
              for (var element in imagesToDelete) {
                await updateProductUseCase.deleteFile(fileKey: element.id!);
              }
              if (context.mounted) {
                context.popRoute(true);
              }
            } else {
              context.popRoute(true);
            }
          });
        });
      },
      (error) {
        EasyLoading.showError('Error updating product');
        debugPrint(error.message);
      },
    );
  }

  Future<void> _uploadThumbnail(
      {required String id,
      required BuildContext context,
      required File? thumbnail}) async {
    if (thumbnail == null) {
      return;
    }
    loading(status: 'Uploading Thumbnail');
    final imageResult = await updateProductUseCase.uploadFile([thumbnail]);
    await imageResult.when((urls) async {
      if (urls.isEmpty) {
        return;
      }

      final productResult = await updateProductUseCase.updateProduct(
        userPostUpdateProductReq:
            UserPostUpdateProductReq(thumbnail: urls.first),
        id: id,
      );
      productResult.when((success) {
        EasyLoading.showSuccess('Product Updated');
      }, (error) {
        context.showSnackBar(error.toSnackBarString());
        dismissLoading();
      });
    }, (error) {
      context.showSnackBar(error.toSnackBarString());
      dismissLoading();
    });
  }

  Future<void> _uploadImages(
      {required String id,
      required BuildContext context,
      required List<File> images,
      List<String>? imagesToKeep}) async {
    if (images.isEmpty) {
      return;
    }
    loading(status: 'Uploading Images');
    List<File> filesToUpload = [];
    filesToUpload.addAll(images);
    final imageResult = await updateProductUseCase.uploadFile(filesToUpload);
    await imageResult.when((urls) async {
      final productResult = await updateProductUseCase.updateProduct(
        userPostUpdateProductReq: UserPostUpdateProductReq(
            images: urls + (imagesToKeep ?? [])),
        id: id,
      );
      productResult.when((success) {
        EasyLoading.showSuccess('Product Added');
      }, (error) {
        context.showSnackBar(error.toSnackBarString());
        dismissLoading();
      });
    }, (error) {
      context.showSnackBar(error.toSnackBarString());
      dismissLoading();
    });
  }

  void fetchProduct() {
    if (updateProductReq == null) {
      product = const Product();
    } else {
      // Update existing product
      updateMode = true;
      product = updateProductReq!.product;
      titleCtrl.text = product.title ?? '';
      subtitleCtrl.text = product.subtitle ?? '';
      handleCtrl.text = product.handle ?? '';
      materialCtrl.text = product.material ?? '';
      descriptionCtrl.text = product.description ?? '';
      discountable = product.discountable;
      selectedProductType = product.type;
      widthCtrl.text = product.width?.toString() ?? '';
      lengthCtrl.text = product.length?.toString() ?? '';
      heightCtrl.text = product.height?.toString() ?? '';
      weightCtrl.text = product.weight?.toString() ?? '';
      midCodeCtrl.text = product.midCode?.toString() ?? '';
      hsCodeCtrl.text = product.hsCode?.toString() ?? '';

      // Sales channel should be enabled by default when editing a product
      enableSalesChannels = true;
      if (product.salesChannels?.isNotEmpty ?? false) {
        selectedSalesChannels =
            product.salesChannels!.map((e) => e.id ?? '').toList();
      }
      if (product.originCountry != null) {
        countryCtrl.text = countries
                .firstWhere(
                    (element) =>
                        element.iso2 == product.originCountry?.toLowerCase(),
                    orElse: () => const Country(
                        iso2: '',
                        iso3: '',
                        numCode: 0,
                        name: '',
                        displayName: ''))
                .displayName ??
            '';
      }
    }
  }
}

class UpdateProductReq {
  final Product product;
  final int number;
  UpdateProductReq({required this.product, required this.number});
}
