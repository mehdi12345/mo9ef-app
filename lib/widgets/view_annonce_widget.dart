import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';

class ListItem extends StatelessWidget {
  const ListItem({Key? key, required this.title, required this.value})
      : super(key: key);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 14, color: Config.black, fontWeight: FontWeight.bold),
        ).paddingOnly(left: 3),
        Container(
          height: 1.5,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.4),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
              fontSize: 14, color: Config.black, fontWeight: FontWeight.normal),
        ).paddingOnly(left: 5),
      ],
    ).paddingSymmetric(horizontal: 5);
  }
}
