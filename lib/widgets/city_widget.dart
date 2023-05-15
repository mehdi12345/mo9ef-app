import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/models/city.dart';

class CityDropDownWidget extends StatelessWidget {
  const CityDropDownWidget(
      {required this.selectedCity,
      required this.label,
      required this.hint,
      this.onChanged,
      Key? key})
      : super(key: key);
  final City? selectedCity;
  final String label, hint;
  final Function(City?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(
          height: 8,
        ),
        DropdownSearch<City>(
          items: Config.cities,
          onChanged: onChanged,
          selectedItem: selectedCity,
          itemAsString: (item) => item.name,
          popupProps: const PopupPropsMultiSelection.menu(showSearchBox: true),
          validator: (val) {
            if (val == null) {
              return context.locale.champs_obligatoires;
            }
            return null;
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade300.withOpacity(0.7),
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
              labelStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
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
        )
      ],
    );
  }
}
