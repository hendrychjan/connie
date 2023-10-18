import 'package:connie/widgets/common/form/form_field_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormFieldDateRange extends StatefulWidget {
  final String hint;
  final TextEditingController dateStartController;
  final TextEditingController dateEndController;
  final Icon? icon;
  const FormFieldDateRange({
    super.key,
    required this.hint,
    required this.dateStartController,
    required this.dateEndController,
    this.icon,
  });

  @override
  State<FormFieldDateRange> createState() => FormFieldDateRangeState();
}

class FormFieldDateRangeState extends State<FormFieldDateRange> {
  late DateTimeRange _selected;
  final _textController = TextEditingController();

  String _formatDateForTextField(DateTime from, DateTime to) {
    DateFormat df = DateFormat.yMd();
    return "${df.format(from)} - ${df.format(to)}";
  }

  void _openDateRangeDialog() async {
    DateTimeRange? rangePicked = await showDateRangePicker(
      context: context,
      initialDateRange: _selected,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    if (rangePicked == null) return;

    if (!mounted) return;

    DateTimeRange adjustedRange = _adjustRangeEnd(rangePicked);
    widget.dateStartController.text = adjustedRange.start.toIso8601String();
    widget.dateEndController.text = adjustedRange.end.toIso8601String();
    _textController.text =
        _formatDateForTextField(adjustedRange.start, adjustedRange.end);
  }

  DateTimeRange _adjustRangeEnd(DateTimeRange originalRange) {
    return DateTimeRange(
      start: originalRange.start,
      end: originalRange.end
          .add(
            const Duration(days: 1),
          )
          .subtract(
            const Duration(milliseconds: 1),
          ),
    );
  }

  @override
  void initState() {
    super.initState();

    DateTime? initialStart = DateTime.tryParse(widget.dateStartController.text);
    DateTime? initialEnd = DateTime.tryParse(widget.dateEndController.text);

    if (initialStart == null || initialEnd == null) {
      DateTime now = DateTime.now();
      DateTime todayStart = DateTime(now.year, now.month, now.day);
      DateTime todayEnd = todayStart
          .add(const Duration(days: 1))
          .subtract(const Duration(milliseconds: 1));
      initialStart = todayStart;
      initialEnd = todayEnd;
    }

    widget.dateStartController.text = initialStart.toIso8601String();
    widget.dateEndController.text = initialEnd.toIso8601String();

    _textController.text = _formatDateForTextField(initialStart, initialEnd);
    _selected = DateTimeRange(start: initialStart, end: initialEnd);
  }

  @override
  Widget build(BuildContext context) {
    return FormFieldText(
      hint: widget.hint,
      controller: _textController,
      readOnly: true,
      icon: widget.icon,
      onTap: _openDateRangeDialog,
    );
  }
}
