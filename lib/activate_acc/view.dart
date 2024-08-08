import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luvpark_get/activate_acc/controller.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';

class ActivateAccount extends StatelessWidget {
  const ActivateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final ActivateAccountController controllers =
        Get.put(ActivateAccountController());
    return CustomScaffold(
        bodyColor: Colors.white,
        children: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ));
  }
}
