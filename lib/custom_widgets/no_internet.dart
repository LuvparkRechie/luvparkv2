import 'package:flutter/material.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';

class NoInternetConnected extends StatelessWidget {
  final Function? onTap;
  final double? size;
  const NoInternetConnected({super.key, this.onTap, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onTap!();
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: size ?? MediaQuery.of(context).size.height * .20,
              width: size ?? MediaQuery.of(context).size.width / 2,
              image: const AssetImage("assets/images/no_internet.png"),
            ),
            Container(
              height: 20,
            ),
            const CustomParagraph(
                text: "Please check your internet connection.",
                fontWeight: FontWeight.normal,
                fontSize: 12),
            Container(
              height: 10,
            ),
            if (onTap != null)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh,
                    size: 17,
                  ),
                  CustomParagraph(
                      text: " Tap to retry",
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ],
              )
          ],
        ),
      ),
    );
  }
}
