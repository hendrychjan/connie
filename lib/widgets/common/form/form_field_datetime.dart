import 'package:connie/widgets/common/form/form_field_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormFieldDatetime extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final Icon? icon;
  const FormFieldDatetime({
    required this.hint,
    required this.controller,
    this.icon,
    super.key,
  });

  @override
  State<FormFieldDatetime> createState() => _FormFieldDatetimeState();
}

class _FormFieldDatetimeState extends State<FormFieldDatetime> {
  late DateTime _selected;
  final _textController = TextEditingController();

  String _formatDateForTextField(DateTime date) {
    return "${DateFormat.yMd().format(date)} ${DateFormat.Hm().format(date)}";
  }

  void _openDateTimeDialog() async {
    DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: _selected,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    if (datePicked == null) return;

    if (!mounted) return;

    TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selected),
    );

    if (timePicked == null) return;

    setState(() {
      _selected = DateTime(
        datePicked.year,
        datePicked.month,
        datePicked.day,
        timePicked.hour,
        timePicked.minute,
      );
    });
    _textController.text = _formatDateForTextField(_selected);
    widget.controller.text = _selected.toIso8601String();
  }

  @override
  void initState() {
    super.initState();
    _selected = DateTime.tryParse(widget.controller.text) ?? DateTime.now();
    _textController.text = _formatDateForTextField(_selected);
  }

  @override
  Widget build(BuildContext context) {
    return FormFieldText(
      hint: widget.hint,
      controller: _textController,
      readOnly: true,
      icon: widget.icon,
      onTap: _openDateTimeDialog,
    );
  }
}
