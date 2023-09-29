import 'package:connie/getx/app_controller.dart';
import 'package:connie/pages/category/category_form_page.dart';
import 'package:connie/widgets/category/categories_list_widget.dart';
import 'package:connie/widgets/common/no_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoriesOverviewPage extends StatefulWidget {
  const CategoriesOverviewPage({super.key});

  @override
  State<CategoriesOverviewPage> createState() => _CategoriesOverviewPageState();
}

class _CategoriesOverviewPageState extends State<CategoriesOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CategoryFormPage()),
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: AppController.to.hiveService.categoryBox.listenable(),
        builder: (context, categories, widget) {
          if (categories.isEmpty) {
            return const NoItemsWidget(
              subtitle: "Click '+' to add a new category",
            );
          } else {
            return CategoriesListWidget(categories: categories);
          }
        },
      ),
    );
  }
}
