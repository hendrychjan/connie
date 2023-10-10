import 'package:flutter/material.dart';

class FormFieldCheckbox extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Future<void> Function(bool value)? onChanged;
  const FormFieldCheckbox({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
  });

  @override
  State<FormFieldCheckbox> createState() => _FormFieldCheckboxState();
}

class _FormFieldCheckboxState extends State<FormFieldCheckbox> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = bool.tryParse(widget.controller.text) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Checkbox(
            value: _value,
            onChanged: (val) {
              setState(() {
                _value = !_value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(_value);
              }
              widget.controller.text = _value.toString();
            },
          ),
          Text(widget.label)
        ],
      ),
    );
  }
}
