import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormFieldDropdown extends StatefulWidget {
  final String hint;
  final Icon? icon;
  final dynamic initialSelection;
  final TextEditingController controller;
  final List<DropdownMenuEntry> items;
  final Function? onSelected;
  const FormFieldDropdown({
    super.key,
    required this.hint,
    required this.initialSelection,
    required this.controller,
    required this.items,
    this.icon,
    this.onSelected,
  });

  @override
  State<FormFieldDropdown> createState() => _FormFieldDropdownState();
}

class _FormFieldDropdownState extends State<FormFieldDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: DropdownMenu(
        initialSelection: widget.initialSelection,
        dropdownMenuEntries: widget.items,
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Get.theme.primaryColor.withOpacity(0.05),
          filled: true,
        ),
        label: Text(widget.hint),
        leadingIcon: widget.icon,
        onSelected: (value) {
          widget.controller.text = value.toString();

          if (widget.onSelected != null) {
            widget.onSelected!(value);
          }
        },
      ),
    );
  }
}
