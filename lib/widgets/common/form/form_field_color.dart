import 'package:connie/ui/local_theme.dart';
import 'package:connie/widgets/common/form/form_field_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class FormFieldColor extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final List<String> validationRules;
  const FormFieldColor({
    required this.hint,
    required this.controller,
    required this.validationRules,
    super.key,
  });

  @override
  State<FormFieldColor> createState() => _FormFieldColorState();
}

class _FormFieldColorState extends State<FormFieldColor> {
  void _openSelectDialog() async {
    Get.dialog(
      AlertDialog.adaptive(
        content: BlockPicker(
          pickerColor: const Color.fromARGB(1, 1, 1, 1),
          onColorChanged: (Color newColor) {
            widget.controller.text = LocalTheme.colorToHexString(newColor);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {});
              Get.back();
            },
            child: const Text("Ok"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openSelectDialog,
      child: FormFieldText(
        hint: widget.hint,
        controller: widget.controller,
        icon: const Icon(Icons.colorize),
        enabled: false,
        themeColor: LocalTheme.hexStringToColor(widget.controller.text),
        validationRules: widget.validationRules,
      ),
    );
  }
}
