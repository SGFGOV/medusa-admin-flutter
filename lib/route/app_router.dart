import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:medusa_admin_flutter/medusa_admin.dart';
import 'package:medusa_admin/app/modules/auth_module/reauthenticate.dart';
import 'package:medusa_admin/app/modules/collections_module/create_collection/controllers/create_collection_controller.dart';
import 'package:medusa_admin/app/modules/pricing_module/add_update_price_list/components/index.dart';
import 'package:medusa_admin/app/modules/products_module/add_update_product/components/image_card.dart';
import '../app/modules/auth_module/reset_password/views/reset_password_view.dart';
import '../app/modules/auth_module/sign_in/views/sign_in_view.dart';
import '../app/modules/categories/views/categories_view.dart';
import '../app/modules/collections_module/collection_details/views/collection_details_view.dart';
import '../app/modules/collections_module/collections/views/collections_view.dart';
import '../app/modules/collections_module/create_collection/views/create_collection_view.dart';
import '../app/modules/components/countries/controller/country_controller.dart';
import '../app/modules/components/countries/view/country_view.dart';
import '../app/modules/components/pick_groups/controllers/pick_groups_controller.dart';
import '../app/modules/components/pick_groups/views/pick_groups_view.dart';
import '../app/modules/components/pick_products/controllers/pick_products_controller.dart';
import '../app/modules/components/pick_products/views/pick_products_view.dart';
import '../app/modules/components/pick_regions/controllers/pick_regions_controller.dart';
import '../app/modules/components/pick_regions/views/pick_regions_view.dart';
import '../app/modules/customers_module/add_update_customer/views/update_customer_details_view.dart';
import '../app/modules/customers_module/customer_details/views/customer_details_view.dart';
import '../app/modules/customers_module/customers/views/customers_view.dart';
import '../app/modules/customers_module/transfer_order/views/transfer_order_view.dart';
import '../app/modules/dashboard/views/dashboard_view.dart';
import '../app/modules/discount_module/add_update_discount/views/add_update_discount_view.dart';
import '../app/modules/discount_module/discount_conditions/components/condition_collection.dart';
import '../app/modules/discount_module/discount_conditions/components/condition_customer_group.dart';
import '../app/modules/discount_module/discount_conditions/components/condition_product.dart';
import '../app/modules/discount_module/discount_conditions/components/condition_tags.dart';
import '../app/modules/discount_module/discount_conditions/components/condition_type.dart';
import '../app/modules/discount_module/discount_conditions/controllers/discount_conditions_controller.dart';
import '../app/modules/discount_module/discount_conditions/views/discount_conditions_view.dart';
import '../app/modules/discount_module/discount_details/views/discount_details_view.dart';
import '../app/modules/discount_module/discounts/views/discounts_view.dart';
import '../app/modules/discount_module/update_condition/controllers/update_condition_controller.dart';
import '../app/modules/discount_module/update_condition/views/update_condition_view.dart';
import '../app/modules/draft_orders_module/create_draft_order/components/address_view.dart';
import '../app/modules/draft_orders_module/create_draft_order/components/draft_order_over_view.dart';
import '../app/modules/draft_orders_module/create_draft_order/components/items_view.dart';
import '../app/modules/draft_orders_module/create_draft_order/components/pick_customer/controllers/pick_customer_controller.dart';
import '../app/modules/draft_orders_module/create_draft_order/components/pick_customer/views/pick_customer_view.dart';
import '../app/modules/draft_orders_module/create_draft_order/components/pick_product_variants/controllers/pick_product_variants_controller.dart';
import '../app/modules/draft_orders_module/create_draft_order/components/pick_product_variants/views/pick_product_vairants_view.dart';
import '../app/modules/draft_orders_module/create_draft_order/controllers/create_draft_order_controller.dart';
import '../app/modules/draft_orders_module/create_draft_order/views/create_draft_order_view.dart';
import '../app/modules/draft_orders_module/draft_order_details/views/draft_order_details_view.dart';
import '../app/modules/draft_orders_module/draft_orders/views/draft_orders_view.dart';
import '../app/modules/gift_cards_module/create_update_custom_gift_card/views/create_update_custom_gift_card_view.dart';
import '../app/modules/gift_cards_module/custom_gift_cards/views/custom_gift_cards_view.dart';
import '../app/modules/gift_cards_module/gift_cards/views/gift_cards_view.dart';
import '../app/modules/groups_module/create_update_group/views/create_update_group_view.dart';
import '../app/modules/groups_module/group_details/views/group_details_view.dart';
import '../app/modules/groups_module/groups/views/groups_view.dart';
import '../app/modules/medusa_search/views/medusa_search_view.dart';
import '../app/modules/orders_module/order_details/components/add_update_order_edit/views/add_update_order_edit_view.dart';
import '../app/modules/orders_module/order_details/components/order_create_fulfillment.dart';
import '../app/modules/orders_module/order_details/views/order_details_view.dart';
import '../app/modules/orders_module/orders/views/orders_view.dart';
import '../app/modules/pricing_module/add_update_price_list/views/add_update_price_list_view.dart';
import '../app/modules/pricing_module/price_list_details/views/price_list_details_view.dart';
import '../app/modules/pricing_module/pricing/views/pricing_view.dart';
import '../app/modules/products_module/add_update_product/components/product_add_variant.dart';
import '../app/modules/products_module/add_update_product/controllers/add_update_product_controller.dart';
import '../app/modules/products_module/add_update_product/views/add_update_product_view.dart';
import '../app/modules/products_module/product_details/views/product_details_view.dart';
import '../app/modules/products_module/products/views/products_view.dart';
import '../app/modules/settings_module/app_settings/order_settings/views/order_settings_view.dart';
import '../app/modules/settings_module/app_settings/views/app_settings_view.dart';
import '../app/modules/settings_module/store_settings/api_key_module/add_update_api_key/views/add_update_api_key_view.dart';
import '../app/modules/settings_module/store_settings/api_key_module/api_key_management/views/api_key_management_view.dart';
import '../app/modules/settings_module/store_settings/currencies/views/currencies_view.dart';
import '../app/modules/settings_module/store_settings/personal_information/views/personal_information_view.dart';
import '../app/modules/settings_module/store_settings/regions_module/add_region/views/add_region_view.dart';
import '../app/modules/settings_module/store_settings/regions_module/add_update_shipping_option/controllers/add_update_shipping_option_controller.dart';
import '../app/modules/settings_module/store_settings/regions_module/add_update_shipping_option/views/add_update_shipping_option_view.dart';
import '../app/modules/settings_module/store_settings/regions_module/region_details/views/region_details_view.dart';
import '../app/modules/settings_module/store_settings/regions_module/regions/views/regions_view.dart';
import '../app/modules/settings_module/store_settings/return_reasons_module/create_update_return_reason/views/create_update_return_reason_view.dart';
import '../app/modules/settings_module/store_settings/return_reasons_module/return_reasons/views/return_reasons_view.dart';
import '../app/modules/settings_module/store_settings/sales_channel_module/add_update_sales_channel/views/add_update_sales_channel_view.dart';
import '../app/modules/settings_module/store_settings/sales_channel_module/sales_channel_details/views/sales_channel_details_view.dart';
import '../app/modules/settings_module/store_settings/sales_channel_module/sales_channels/views/sales_channels_view.dart';
import '../app/modules/settings_module/store_settings/shipping/views/shipping_view.dart';
import '../app/modules/settings_module/store_settings/store_details/views/store_details_view.dart';
import '../app/modules/settings_module/store_settings/store_settings_view.dart';
import '../app/modules/settings_module/store_settings/tax_settings_module/add_update_tax_rate/controllers/add_update_tax_rate_controller.dart';
import '../app/modules/settings_module/store_settings/tax_settings_module/add_update_tax_rate/views/add_update_tax_rate_view.dart';
import '../app/modules/settings_module/store_settings/tax_settings_module/tax_settings/views/tax_settings_select_region_view.dart';
import '../app/modules/settings_module/store_settings/tax_settings_module/tax_settings/views/tax_settings_view.dart';
import '../app/modules/settings_module/store_settings/team/views/team_view.dart';
import '../app/modules/splash/views/splash_view.dart';
import '../core/utils/enums.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends _$AppRouter {

  List<AutoRoute> dashboardChildren =[
    AutoRoute(page: OrdersRoute.page),
    AutoRoute(page: DraftOrdersRoute.page),
    AutoRoute(page: ProductsRoute.page),
    AutoRoute(page: CategoriesRoute.page),
    AutoRoute(page: CollectionsRoute.page),
    AutoRoute(page: CustomersRoute.page),
    AutoRoute(page: GroupsRoute.page),
    AutoRoute(page: DiscountsRoute.page),
    AutoRoute(page: GiftCardsRoute.page),
    AutoRoute(page: PricingRoute.page),
    AutoRoute(page: StoreSettingsRoute.page),
    AutoRoute(page: AppSettingsRoute.page),
  ];

  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(page: SplashRoute.page, initial: true),
      AutoRoute(page: DashboardRoute.page, children: dashboardChildren),
      AutoRoute(page: PickProductsRoute.page),
      AutoRoute(page: SelectCountryRoute.page),
      AutoRoute(page: PickGroupsRoute.page),
      AutoRoute(page: PickRegionsRoute.page),

      // ReAuthenticate
      AutoRoute(page: ReAuthenticateRoute.page),

      // collections module
      AutoRoute(page: CollectionDetailsRoute.page),
      AutoRoute(page: CreateCollectionRoute.page),

      // customers module
      AutoRoute(page: AddUpdateCustomerRoute.page),
      AutoRoute(page: CustomerDetailsRoute.page),
      AutoRoute(page: TransferOrderRoute.page),
      // Auth module
      AutoRoute(page: SignInRoute.page),
      AutoRoute(page: ResetPasswordRoute.page),
      // Discount module
      AutoRoute(page: AddUpdateDiscountRoute.page),
      AutoRoute(page: DiscountDetailsRoute.page),
      AutoRoute(page: DiscountConditionsRoute.page),
      AutoRoute(page: UpdateConditionRoute.page),
      AutoRoute(page: ConditionProductRoute.page),
      AutoRoute(page: ConditionCustomerGroupRoute.page),
      AutoRoute(page: ConditionTagRoute.page),
      AutoRoute(page: ConditionTypeRoute.page),
      AutoRoute(page: ConditionCollectionRoute.page),

      // Draft orders module
      AutoRoute(page: CreateDraftOrderRoute.page, fullscreenDialog: true),
      AutoRoute(page: DraftOrderDetailsRoute.page),
      AutoRoute(page: PickCustomerRoute.page),
      AutoRoute(page: PickProductVariantsRoute.page),

      // Gift cards module
      AutoRoute(page: CreateUpdateCustomGiftCardRoute.page),
      AutoRoute(page: CustomGiftCardsRoute.page),

      // Groups module
      AutoRoute(page: GroupDetailsRoute.page),
      AutoRoute(page: CreateUpdateGroupRoute.page),

      // Medusa Search
      AutoRoute(page: MedusaSearchRoute.page),

      // Orders module
      AutoRoute(page: OrderDetailsRoute.page),
      AutoRoute(page: AddUpdateOrderEditRoute.page),
      AutoRoute(page: OrderCreateFulfillmentRoute.page),

      // Pricing module
      AutoRoute(page: AddUpdateVariantsPriceRoute.page),
      AutoRoute(page: AddUpdatePriceListRoute.page),
      AutoRoute(page: PriceListDetailsRoute.page),

      // Products module
      AutoRoute(page: AddUpdateProductRoute.page),
      AutoRoute(page: ProductDetailsRoute.page, fullscreenDialog: true),
      AutoRoute(page: ImagePreviewRoute.page),
      AutoRoute(page: ProductAddVariantRoute.page),

      // Store settings
      AutoRoute(page: RegionsRoute.page),
      AutoRoute(page: RegionDetailsRoute.page),
      AutoRoute(page: AddRegionRoute.page),
      AutoRoute(page: AddUpdateShippingOptionRoute.page),

      AutoRoute(page: StoreDetailsRoute.page),

      AutoRoute(page: ReturnReasonsRoute.page),
      AutoRoute(page: CreateUpdateReturnReasonRoute.page),

      AutoRoute(page: PersonalInformationRoute.page),

      AutoRoute(page: TaxSettingsRoute.page),
      AutoRoute(page: AddUpdateTaxRateRoute.page),
      AutoRoute(page: TaxSettingsSelectRegionRoute.page),

      AutoRoute(page: CurrenciesRoute.page),

      AutoRoute(page: SalesChannelsRoute.page),
      AutoRoute(page: AddUpdateSalesChannelRoute.page),
      AutoRoute(page: SalesChannelDetailsRoute.page),

      AutoRoute(page: ApiKeyManagementRoute.page),
      AutoRoute(page: AddUpdateApiKeyRoute.page),

      AutoRoute(page: TeamRoute.page),

      // App Settings
      AutoRoute(page: OrderSettingsRoute.page),
    ];
  }
}
