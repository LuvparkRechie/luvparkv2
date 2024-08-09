import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';

import 'package:luvpark_get/qr/controller.dart';

class QrWallet extends GetView<QrWalletController> {
  const QrWallet({super.key});

  @override
  Widget build(BuildContext context) {
    final QrWalletController ct = Get.put(QrWalletController());
    return CustomScaffold(
      bodyColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 24,
        backgroundColor: Colors.white,
        bottom: TabBar(
            labelStyle: paragraphStyle(),
            unselectedLabelStyle: paragraphStyle(),
            controller: ct.tabController,
            tabs: const [
              Tab(
                text: "Qr Pay",
              ),
              Tab(
                text: "Receive",
              ),
            ]),
      ),
      children: TabBarView(
        controller: ct.tabController,
        children: [PayQr(), ReceiveQr()],
      ),
    );
  }
}

class PayQr extends StatelessWidget {
  const PayQr({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("QR PAY")],
    );
  }
}

class ReceiveQr extends StatelessWidget {
  const ReceiveQr({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("QR PAY")],
    );
  }
}
