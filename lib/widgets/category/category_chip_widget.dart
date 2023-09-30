import 'package:connie/objects/category.dart';
import 'package:connie/ui/local_theme.dart';
import 'package:flutter/material.dart';

class CategoryChipWidget extends StatefulWidget {
  final Category category;
  final Function onValueChanged;
  final bool initiallySelected;
  const CategoryChipWidget({
    super.key,
    required this.category,
    required this.onValueChanged,
    required this.initiallySelected,
  });

  @override
  State<CategoryChipWidget> createState() => _CategoryChipWidgetState();
}

class _CategoryChipWidgetState extends State<CategoryChipWidget> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selected = !_selected;
        });
        widget.onValueChanged(_selected);
      },
      child: Chip(
        label: Text(
          widget.category.title,
          style: TextStyle(
            fontWeight: (_selected) ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: LocalTheme.hexStringToColor(widget.category.colorHex)
            .withOpacity((_selected) ? 0.4 : 0.05),
      ),
    );
  }
}
