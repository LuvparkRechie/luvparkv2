// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:flutter_svg/svg.dart';

import '../../custom_widgets/app_color.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_separator.dart';
import '../../custom_widgets/custom_text.dart';
import '../../custom_widgets/variables.dart';

class TransactionDetails extends StatelessWidget {
  final List data;
  final int index;
  const TransactionDetails(
      {super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            SizedBox(
              height: 35,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                15,
                30,
                15,
                0,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(7))),
              child: Wrap(
                children: [
                  Center(
                    child: CustomTitle(
                      text: 'Transaction Details',
                      fontSize: 20,
                      maxlines: 1,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Center(
                    child: CustomParagraph(
                      text: "${data[index]["tran_desc"]}",
                      color: AppColor.primaryColor,
                      textAlign: TextAlign.left,
                      fontSize: 16,
                      maxlines: 1,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  const MySeparator(),
                  Container(
                    height: 20,
                  ),
                  rowWidget("Date",
                      Variables.formatDateLocal(data[index]["tran_date"])),
                  Container(
                    height: 10,
                  ),
                  rowWidget("Amount",
                      toCurrencyString(data[index]["amount"].toString())),
                  Container(
                    height: 10,
                  ),
                  rowWidget("Previous Balance",
                      toCurrencyString(data[index]["bal_before"].toString())),
                  Container(
                    height: 10,
                  ),
                  rowWidget("Current Balance",
                      toCurrencyString(data[index]["bal_after"].toString())),
                  Container(
                    height: 20,
                  ),
                  const MySeparator(),
                  Container(
                    height: 50,
                  ),
                  Center(
                    child: CustomTitle(
                      text: data[index]["ref_no"].toString(),
                      color: AppColor.primaryColor,
                    ),
                  ),
                  Center(
                    child: CustomParagraph(
                      text: "Reference No",
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  CustomButton(
                    text: 'Close',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    btnHeight: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(),
          child: SvgPicture.asset(
            "assets/images/${data[index]["tran_desc"] == 'Share a token' ? 'wallet_sharetoken' : data[index]["tran_desc"] == 'Received token' ? 'wallet_receivetoken' : 'wallet_payparking'}.svg",
            //if trans_Desc is equal to Share a token svg is wallet_sharetoken else Receive Token svg is wallet_receivetoken else parking transaction is svg wallet_payparking
            height: 70,
            width: MediaQuery.of(context).size.width,
          ),
        )
      ],
    );
  }

  Row rowWidget(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomParagraph(
          text: label,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: CustomParagraph(
              text: value,
              color: AppColor.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
