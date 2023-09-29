import 'package:connie/objects/category.dart';
import 'package:connie/pages/category/category_form_page.dart';
import 'package:connie/ui/local_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class CategoriesListWidget extends StatefulWidget {
  final Box<Category> categories;
  const CategoriesListWidget({super.key, required this.categories});

  @override
  State<CategoriesListWidget> createState() => _CategoriesListWidgetState();
}

class _CategoriesListWidgetState extends State<CategoriesListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        Category category = widget.categories.values.elementAt(index);
        return ListTile(
          onTap: () => Get.to(
            () => CategoryFormPage(
              initialCategory: category,
            ),
          ),
          title: Text(
            category.title,
            style: TextStyle(
              color: LocalTheme.hexStringToColor(category.colorHex),
            ),
          ),
        );
      },
    );
  }
}
