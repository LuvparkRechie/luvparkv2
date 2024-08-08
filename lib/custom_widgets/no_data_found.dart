import 'package:flutter/material.dart';
import 'package:luvpark_get/custom_widgets/custom_text.dart';

class NoDataFound extends StatelessWidget {
  final double? size;
  final Function? onTap;
  final String? textText;
  const NoDataFound({super.key, this.size, this.onTap, this.textText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: size ?? 100,
              width: size ?? 80,
              image: const AssetImage("assets/images/no_data.png"),
            ),
            Container(
              height: 10,
            ),
            CustomParagraph(
              text: textText ?? "No data found",
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
            Container(
              height: 10,
            ),
            onTap != null
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh,
                        size: 17,
                      ),
                      CustomParagraph(
                        text: " Tap to retry",
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
