import 'package:connie/forms/category_form.dart';
import 'package:connie/objects/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryFormPage extends StatefulWidget {
  final Category? initialCategory;
  const CategoryFormPage({this.initialCategory, super.key});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  bool _loading = false;

  Future<void> _handleSubmit(Category payload) async {
    setState(() {
      _loading = true;
    });
    await payload.save();
    setState(() {
      _loading = false;
    });
    Get.back();
  }

  Future<void> _handleDelete() async {
    setState(() {
      _loading = true;
    });
    // Here, initialCategory can never be null, because the _handleDelete
    // function is called from a widget that is only rendered into the UI when
    // the initialCategory is not null
    await widget.initialCategory!.delete();
    setState(() {
      _loading = false;
    });
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.initialCategory == null) ? "New category" : "Edit category",
        ),
        actions: [
          if (widget.initialCategory != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _handleDelete,
            )
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CategoryForm(
              onSubmit: _handleSubmit,
              initialCategory: widget.initialCategory,
            ),
    );
  }
}
