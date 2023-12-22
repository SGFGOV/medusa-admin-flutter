import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medusa_admin/app/modules/components/scrolling_expandable_fab.dart';
import 'package:medusa_admin/core/utils/colors.dart';
import 'package:medusa_admin/core/utils/extension.dart';
import 'package:medusa_admin/route/app_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/utils/medusa_icons_icons.dart';
import '../../../../data/models/req/user_gift_card_req.dart';
import '../../../../data/models/store/gift_card.dart';
import '../../../../data/repository/gift_card/gift_card_repo.dart';
import '../../../components/adaptive_back_button.dart';
import '../../../components/adaptive_icon.dart';
import '../components/index.dart';
import '../controllers/custom_gift_cards_controller.dart';

@RoutePage()
class CustomGiftCardsView extends StatelessWidget {
  const CustomGiftCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final lightWhite = ColorManager.manatee;
    final smallTextStyle = context.bodySmall;

    return GetBuilder<CustomGiftCardsController>(
        init: CustomGiftCardsController(giftCardRepo: GiftCardRepo()),
        builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          leading: const AdaptiveBackButton(),
          title: const Text('Gift Cards History'),
          actions: [
            AdaptiveIcon(
                onPressed: () =>
                    context.pushRoute(
                        MedusaSearchRoute(
                            searchCategory: SearchCategory.giftCards)),
                icon: const Icon(MedusaIcons.magnifying_glass_mini))
          ],
        ),
        floatingActionButton: ScrollingExpandableFab(
          controller: controller.scrollController,
          label: 'Custom Gift Card',
          icon: const Icon(Icons.add),
          onPressed: () => context.pushRoute(CreateUpdateCustomGiftCardRoute()),
        ),
        body: SafeArea(
          child: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              SliverPadding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'See the history of purchased Gift Cards',
                    style: smallTextStyle?.copyWith(color: lightWhite),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 80),
                sliver: PagedSliverList.separated(
                    pagingController: controller
                        .customGiftCardsPagingController,
                    builderDelegate: PagedChildBuilderDelegate<GiftCard>(
                      itemBuilder: (context, giftCard, index) {
                        final isDisabled = giftCard.isDisabled ?? false;

                        final listTile = ListTile(
                          onTap: () {
                            showBarModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  CustomGiftCardView(giftCard),
                            );
                          },
                          onLongPress: () async {
                            await showModalActionSheet<int>(
                                title: 'Manage Custom Gift Card',
                                context: context,
                                actions: <SheetAction<int>>[
                                  const SheetAction(
                                      label: 'Edit details', key: 0),
                                  SheetAction(
                                      label: isDisabled ? 'Enable' : 'Disable',
                                      isDestructiveAction: true,
                                      key: 1),
                                ]).then((value) async {
                              switch (value) {
                                case 0:
                                  context.pushRoute(CreateUpdateCustomGiftCardRoute(giftCard: giftCard));
                                  break;
                                case 1:
                                  await controller.updateCustomGiftCard(
                                    context:context,
                                    id: giftCard.id!,
                                    userUpdateGiftCardReq: UserUpdateGiftCardReq(
                                        isDisabled: !isDisabled),
                                    getBack: false,
                                  );
                                  break;
                              }
                            });
                          },
                          tileColor:
                          Theme
                              .of(context)
                              .appBarTheme
                              .backgroundColor,
                          title: Text(giftCard.code ?? ''),
                          subtitle: Text(
                            giftCard.orderId ?? '_',
                            style: smallTextStyle?.copyWith(color: lightWhite),
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  '${giftCard.balance.formatAsPrice(
                                      giftCard.region?.currencyCode,
                                      includeSymbol: false)} / ${giftCard.value
                                      .formatAsPrice(
                                      giftCard.region?.currencyCode,
                                      symbolAtEnd: true)}'),
                              Text(giftCard.createdAt.formatDate()),
                            ],
                          ),
                        );
                        const disabledDot = Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                              Icons.circle, color: Colors.red, size: 10),
                        );
                        if (isDisabled) {
                          return Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              listTile,
                              disabledDot,
                            ],
                          );
                        } else {
                          return listTile;
                        }
                      },
                      noItemsFoundIndicatorBuilder: (_) =>
                      const Center(child: Text('No Gift cards')),
                      firstPageProgressIndicatorBuilder: (context) =>
                      const Center(
                          child: CircularProgressIndicator.adaptive()),
                    ),
                    separatorBuilder: (_, __) => const Divider(height: 0)),
              ),
            ],
          ),
        ),
      );
    });
  }
}
