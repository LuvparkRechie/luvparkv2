import 'package:flutter/material.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';

class CustomDialog {
  void internetErrorDialog(BuildContext context, VoidCallback onTap) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const CustomTitle(
              text: "Error",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            content: const CustomParagraph(
                text: "Please check your internet connection and try again."),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Close",
                  style: paragraphStyle(color: AppColor.primaryColor),
                ),
                onPressed: () {
                  onTap();
                },
              ),
            ],
          );
        });
  }

  void serverErrorDialog(BuildContext context, VoidCallback onTap) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const CustomTitle(
              text: "Error",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            content: const CustomParagraph(
                text: "Error while connecting to server, Please try again."),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Close",
                  style: paragraphStyle(color: AppColor.primaryColor),
                ),
                onPressed: () {
                  onTap();
                },
              ),
            ],
          );
        });
  }

  void errorDialog(BuildContext context, String title, String paragraph,
      VoidCallback onTap) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: CustomTitle(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            content: CustomParagraph(text: paragraph),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Close",
                  style: paragraphStyle(color: AppColor.primaryColor),
                ),
                onPressed: () {
                  onTap();
                },
              ),
            ],
          );
        });
  }

  void successDialog(BuildContext context, String title, String paragraph,
      String btnName, VoidCallback onTap) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: CustomTitle(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              wordspacing: 4,
            ),
            content: CustomParagraph(text: paragraph),
            actions: <Widget>[
              TextButton(
                child: Text(
                  btnName,
                  style: paragraphStyle(color: AppColor.primaryColor),
                ),
                onPressed: () {
                  onTap();
                },
              ),
            ],
          );
        });
  }

  void confirmationDialog(
    BuildContext context,
    String title,
    String paragraph,
    String btnNot,
    String btnOk,
    VoidCallback onTapClose,
    VoidCallback onTapConfirm,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: CustomTitle(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              wordspacing: 4,
            ),
            content: CustomParagraph(text: paragraph),
            actions: <Widget>[
              TextButton(
                child: Text(
                  btnNot,
                  style: paragraphStyle(color: AppColor.primaryColor),
                ),
                onPressed: () {
                  onTapClose();
                },
              ),
              TextButton(
                child: Text(
                  btnOk,
                  style: paragraphStyle(color: AppColor.primaryColor),
                ),
                onPressed: () {
                  onTapConfirm();
                },
              ),
            ],
          );
        });
  }

  void snackbarDialog(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(text),
        duration: const Duration(seconds: 1), // Adjust the duration as needed
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Okay',
          onPressed: () {},
        ),
      ),
    );
  }
}
