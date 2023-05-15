import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';

class SeachInput extends StatelessWidget {
  const SeachInput({
    Key? key,
    this.search,
    required this.onFilter,
    required this.controller,
    this.keyBoard = TextInputType.text,
  }) : super(key: key);
  final TextEditingController controller;
  final Function()? search;
  final Function() onFilter;
  final TextInputType keyBoard;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize(context).width,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          TextFormField(
            controller: controller,
            keyboardType: keyBoard,
            onEditingComplete: () {
              search?.call();
            },
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                hintText: context.locale.chercher,
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(
                  Ionicons.search_outline,
                  color: Config.primaryColor,
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    onFilter();
                  },
                  child: Icon(
                    Ionicons.filter_outline,
                    color: Config.primaryColor,
                  ),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Config.primaryColor))),
          ).makeItFlexible(),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: search,
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Config.primaryColor,
              ),
              child: const Icon(
                Ionicons.search,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
