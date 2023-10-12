import 'package:connie/objects/category.dart';
import 'package:connie/services/hive_service.dart';
import 'package:connie/widgets/common/form/form_field_color.dart';
import 'package:connie/widgets/common/form/form_field_text.dart';
import 'package:flutter/material.dart';

class CategoryForm extends StatefulWidget {
  final Future<void> Function(Category) onSubmit;
  final Category? initialCategory;
  const CategoryForm({
    required this.onSubmit,
    this.initialCategory,
    super.key,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _colorHexController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialCategory != null) {
      _titleController.text = widget.initialCategory!.title;
      _colorHexController.text = widget.initialCategory!.colorHex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormFieldText(
            hint: "Title",
            icon: const Icon(Icons.edit),
            controller: _titleController,
            validationRules: const ["required"],
            textInputAction: TextInputAction.done,
          ),
          FormFieldColor(
            hint: "Color",
            controller: _colorHexController,
            validationRules: const ["required"],
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              await widget.onSubmit(
                Category(
                  id: widget.initialCategory?.id ?? HiveService.generateId(),
                  title: _titleController.text,
                  colorHex: _colorHexController.text,
                ),
              );
            },
            child: Text(
              (widget.initialCategory == null) ? "Create" : "Update",
            ),
          ),
        ],
      ),
    );
  }
}
