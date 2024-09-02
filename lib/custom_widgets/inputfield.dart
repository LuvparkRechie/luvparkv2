// import 'dart:io';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// // ignore: implementation_imports
// import 'package:flutter/src/services/text_formatter.dart';
// import 'package:luvpark_get/custom_widgets/custom_text.dart';

// class CustomInputField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final IconData? prefixIcon;
//   final bool obscureText;
//   final TextInputType keyboardType;
//   final TextInputAction textInputAction;
//   final List<TextInputFormatter>? inputFormatters;
//   final TextCapitalization textCapitalization;
//   final Function(String)? onChanged;
//   final FormFieldValidator<String>? validator;

//   const CustomInputField({
//     Key? key,
//     required this.controller,
//     required this.label,
//     this.prefixIcon,
//     this.obscureText = false,
//     this.keyboardType = TextInputType.text,
//     this.textInputAction = TextInputAction.done,
//     this.onChanged,
//     this.validator,
//     this.inputFormatters,
//     this.textCapitalization = TextCapitalization.none,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       textInputAction: textInputAction,
//       onChanged: onChanged,
//       textCapitalization: textCapitalization,
//       inputFormatters: inputFormatters,
//       decoration: InputDecoration(
//         hintText: label,
//         prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
//         hintStyle: Platform.isAndroid
//             ? paragraphStyle(fontWeight: FontWeight.w500)
//             : const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF9C9C9C),
//                 fontSize: 16,
//                 fontFamily: "SFProTextReg",
//               ),
//         contentPadding: const EdgeInsets.all(10),
//         focusedBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(7)),
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(7)),
//           borderSide: BorderSide(
//             width: 2,
//             color: Colors.black.withOpacity(0.07999999821186066),
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(7)),
//           borderSide: BorderSide(
//             width: 2,
//             color: Colors.black.withOpacity(0.07999999821186066),
//           ),
//         ),
//       ),
//       style: paragraphStyle(color: Colors.black),
//       validator: validator,
//     );
//   }
// }

// class CustomDropdown extends StatefulWidget {
//   final String? ddValue;
//   final List? ddData; // Updated type to be more specific
//   final String labelText;
//   final FormFieldValidator<String>? validator;
//   final ValueChanged<String?> onChange; // Change to handle nullable values

//   const CustomDropdown({
//     super.key,
//     required this.labelText,
//     required this.ddData,
//     required this.onChange,
//     this.validator,
//     this.ddValue,
//   });

//   @override
//   State<CustomDropdown> createState() => _CustomDropdownState();
// }

// class _CustomDropdownState extends State<CustomDropdown> {
//   final numericRegex = RegExp(r'[0-9]');
//   final upperCaseRegex = RegExp(r'[A-Z]');

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String?>(
//       dropdownColor: Colors.white,
//       decoration: InputDecoration(
//         hintText: widget.labelText,
//         hintStyle: Platform.isAndroid
//             ? paragraphStyle(fontWeight: FontWeight.w500)
//             : const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF9C9C9C),
//                 fontSize: 16,
//                 fontFamily: "SFProTextReg",
//               ),
//         contentPadding: const EdgeInsets.all(10),
//         focusedBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(7)),
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(7)),
//           borderSide: BorderSide(
//             width: 2,
//             color: Colors.black.withOpacity(0.07999999821186066),
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(7)),
//           borderSide: BorderSide(
//             width: 2,
//             color: Colors.black.withOpacity(0.07999999821186066),
//           ),
//         ),
//       ),
//       style: paragraphStyle(color: Colors.black),
//       value: widget.ddValue,
//       isExpanded: true,
//       onChanged: (String? newValue) {
//         widget.onChange(newValue); // Pass the nullable value directly
//       },
//       validator: widget.validator,
//       items: widget.ddData!.map((item) {
//         return DropdownMenuItem<String?>(
//           value: item['value'].toString(),
//           child: AutoSizeText(
//             item['text']!.toString(),
//             style: paragraphStyle(color: Colors.black),
//             overflow: TextOverflow.ellipsis,
//             maxFontSize: 15,
//             maxLines: 2,
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
