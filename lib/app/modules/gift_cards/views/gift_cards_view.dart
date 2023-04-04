import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medusa_admin/app/modules/components/adaptive_back_button.dart';
import '../controllers/gift_cards_controller.dart';

class GiftCardsView extends GetView<GiftCardsController> {
  const GiftCardsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AdaptiveBackButton(),
        title: const Text('Gift Cards'),
      ),
      body: const Center(
        child: Text(
          'GiftCardsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
