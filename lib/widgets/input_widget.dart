import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moqefapp/extensions/extensions.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController inputController;
  final String hint;
  final String label;
  final int? lines;
  final TextInputType keyboardType;
  final TextInputAction action;
  final bool isRequired;
  const InputWidget(
      {Key? key,
      required this.inputController,
      required this.label,
      required this.hint,
      this.isRequired = true,
      this.action = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.lines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: const Offset(12, 26),
                blurRadius: 50,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.1)),
          ]),
          child: TextFormField(
            controller: inputController,
            maxLines: lines,
            validator: (val) {
              if (isRequired && (val != null && val.isEmpty)) {
                return context.locale.champs_obligatoires;
              }
              return null;
            },
            inputFormatters: keyboardType == TextInputType.number
                ? [DecimalTextInputFormatter()]
                : null,
            textInputAction: action,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              // prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor: Colors.grey.shade300.withOpacity(0.7),
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),

              contentPadding: EdgeInsets.symmetric(
                  vertical: lines != null ? 10 : 0.0, horizontal: 20.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffEF4444), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  gapPadding: 10),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 10);
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'^\d*\.?\d*');
    String newText = regEx.stringMatch(newValue.text) ?? '';
    return newText == newValue.text ? newValue : oldValue;
  }
}
