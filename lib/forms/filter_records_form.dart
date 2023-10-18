import 'package:connie/objects/category.dart';
import 'package:connie/objects/expense.dart';
import 'package:connie/objects/financial_records_filter.dart';
import 'package:connie/objects/income.dart';
import 'package:connie/widgets/category/select_categories_widget.dart';
import 'package:connie/widgets/common/form/form_field_daterange.dart';
import 'package:connie/widgets/common/form/form_field_divider.dart';
import 'package:connie/widgets/common/form/form_field_multiselect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterRecordsForm extends StatefulWidget {
  final Future<void> Function(FinancialRecordsFilter) onSubmit;
  final FinancialRecordsFilter? initialFilter;
  const FilterRecordsForm({
    super.key,
    required this.onSubmit,
    this.initialFilter,
  });

  @override
  State<FilterRecordsForm> createState() => _FilterRecordsFormState();
}

class _FilterRecordsFormState extends State<FilterRecordsForm> {
  final _formKey = GlobalKey<FormState>();
  final RxList<Category> _categories = RxList<Category>.empty(growable: true);
  final RxList<Type> _recordTypes = RxList<Type>.empty(growable: true);
  final _dateRangeStartController = TextEditingController();
  final _dateRangeEndController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialFilter == null) return;

    _categories.addAll(widget.initialFilter!.categories);
    _recordTypes.addAll(widget.initialFilter!.recordTypes);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormFieldDateRange(
            hint: "Date range",
            dateStartController: _dateRangeStartController,
            dateEndController: _dateRangeEndController,
          ),
          FormFieldMultiselect<Type>(
            hint: "Record types",
            selected: _recordTypes,
            options: const [Expense, Income],
            titleGetter: (t) {
              return t.toString();
            },
          ),
          SelectCategoriesWidget(selected: _categories),
          const FormFieldDivider(),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await widget.onSubmit(
                FinancialRecordsFilter(
                  categories: _categories,
                  dateRange: DateTimeRange(
                    start: DateTime.parse(_dateRangeStartController.text),
                    end: DateTime.parse(_dateRangeEndController.text),
                  ),
                  recordTypes: _recordTypes,
                ),
              );
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
