import 'package:flutter/material.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';

class CustomDialog {
  void internetErrorDialog(BuildContext context, VoidCallback onTap) {
    showDialog(
        barrierDismissible: false,
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
        barrierDismissible: false,
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
        barrierDismissible: false,
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
        useSafeArea: true,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
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
            ),
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
        barrierDismissible: false,
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

  void loadingDialog(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              content: SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              ),
              elevation: 0, // Remove shadow
            ),
          );
        });
  }

  void snackbarDialog(BuildContext context, String text, Color? color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color ?? Colors.red,
        content: Text(text),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Okay',
          onPressed: () {},
        ),
      ),
    );
  }

  void customPopUp(
    BuildContext context,
    String title,
    String paragraph,
    String? btnNot,
    String? btnOk, {
    VoidCallback? onTapClose,
    VoidCallback? onTapConfirm,
    Color? btnNotBackgroundColor,
    Color? btnOkBackgroundColor,
    Color? btnNotTextColor,
    Color? btnOkTextColor,
    bool showTwoButtons = true,
    required String imageName, // Add this parameter for the dynamic image name
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  //pu_confirmaiton
                  //pu_nointernet
                  //pu_servererror
                  //pu_success
                  child: Image.asset(
                    'assets/images/$imageName.png', // Use the dynamic image name here
                    fit: BoxFit.cover,
                    height: 100,
                    width: double.infinity,
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomTitle(
                    text: title,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                    letterSpacing: -0.408,
                  ),
                ),
                // Paragraph
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomParagraph(
                    text: paragraph,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black54,
                    textAlign: TextAlign.center,
                    letterSpacing: -0.408,
                  ),
                ),
                // Buttons
                Padding(
                  padding: const EdgeInsets.only(
                      top: 25, right: 15, left: 15, bottom: 16),
                  child: showTwoButtons
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: TextButton(
                                  onPressed: onTapClose,
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        btnNotBackgroundColor ?? Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: CustomParagraph(
                                    text: btnNot!,
                                    color: btnNotTextColor ?? Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.408,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: TextButton(
                                  onPressed: onTapConfirm,
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: btnOkBackgroundColor ??
                                        AppColor.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: CustomParagraph(
                                    text: btnOk!,
                                    color: btnOkTextColor ?? Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.408,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: TextButton(
                            onPressed: onTapConfirm,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  btnOkBackgroundColor ?? AppColor.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: CustomParagraph(
                              text: btnOk!,
                              color: btnOkTextColor ?? Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.408,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
