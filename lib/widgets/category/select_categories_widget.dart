import 'package:connie/getx/app_controller.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/widgets/category/category_chip_widget.dart';
import 'package:flutter/material.dart';

class SelectCategoriesWidget extends StatefulWidget {
  final List<Category> selected;
  const SelectCategoriesWidget({
    super.key,
    required this.selected,
  });

  @override
  State<SelectCategoriesWidget> createState() => _SelectCategoriesWidgetState();
}

class _SelectCategoriesWidgetState extends State<SelectCategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Categories",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              for (Category category
                  in AppController.to.hiveService.categoryBox.values)
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: CategoryChipWidget(
                    category: category,
                    initiallySelected: widget.selected.contains(category),
                    onValueChanged: (bool selected) {
                      if (selected) {
                        widget.selected.add(category);
                      } else {
                        widget.selected.remove(category);
                      }
                    },
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
