import 'package:get/get.dart';
import 'package:medusa_admin/app/data/models/store/index.dart';

class OrderSettingsController extends GetxController {
  Order order = Order(
    customerId: '',
    email: 'Medusa@js.com',
    regionId: '',
    currencyCode: 'usd',
    customer: Customer(email: 'Medusa@js.com', firstName: 'Medusa', lastName: 'Js'),
    total: 12345,
    shippingAddress: Address(countryCode: 'us'),
    cart: Cart(
      createdAt: DateTime.now(),
    ),
    currency: Currency(
      name: 'US Dollars',
      symbol: '\$',
      symbolNative: '\$',
      code: 'us',
    ),
    fulfillmentStatus: FulfillmentStatus.notFulfilled,
    paymentStatus: PaymentStatus.captured,
    displayId: 69,
  );
}
