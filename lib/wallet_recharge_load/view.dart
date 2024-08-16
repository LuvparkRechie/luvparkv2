import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/custom_widgets/custom_appbar.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';

import 'controller.dart';

class WalletRechargeLoadScreen extends GetView<WalletRechargeLoadController> {
  const WalletRechargeLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        children: Column(children: [CustomAppbar(title: "Load")]));
  }
}
