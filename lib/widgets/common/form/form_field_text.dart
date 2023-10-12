import 'package:connie/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormFieldText extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final List<String>? validationRules;
  final TextInputType keyboardType;
  final bool obscureText;
  final Icon? icon;
  final Function? onSubmit;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool? enabled;
  final bool? readOnly;
  final Function? onTap;
  final Color? themeColor;
  final TextInputAction? textInputAction;
  final String? tooltipMessage;
  final String? placeholder;

  const FormFieldText({
    required this.hint,
    required this.controller,
    this.validationRules,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.icon,
    this.onSubmit,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.themeColor,
    this.textInputAction = TextInputAction.done,
    this.tooltipMessage,
    this.placeholder,
    super.key,
  });

  @override
  State<FormFieldText> createState() => _FormFieldTextState();
}

class _FormFieldTextState extends State<FormFieldText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          labelText: widget.hint,
          prefixIcon: widget.icon,
          fillColor:
              widget.themeColor ?? Get.theme.primaryColor.withOpacity(0.05),
          filled: true,
          hintText: widget.placeholder,
          suffixIcon: (widget.tooltipMessage != null)
              ? Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: widget.tooltipMessage,
                  child: const Icon(Icons.info),
                )
              : null,
        ),
        obscureText: widget.obscureText,
        validator: (value) {
          return ValidationService.validateField(
            value.toString(),
            widget.validationRules,
          );
        },
        onFieldSubmitted: (value) {
          if (widget.onSubmit != null) widget.onSubmit!(value);
        },
        minLines: widget.minLines ?? 1,
        maxLines: widget.maxLines ?? 1,
        enabled: widget.enabled,
        readOnly: widget.readOnly ?? false,
        onTap: (widget.onTap != null) ? () => widget.onTap!() : () {},
        textInputAction: widget.textInputAction,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}
