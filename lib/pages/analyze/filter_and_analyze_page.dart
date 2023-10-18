import 'package:connie/forms/filter_records_form.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:connie/objects/financial_records_filter.dart';
import 'package:connie/widgets/common/no_items_widget.dart';
import 'package:connie/widgets/financial_record/financial_records_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterAndAnalyzePage extends StatefulWidget {
  const FilterAndAnalyzePage({super.key});

  @override
  State<FilterAndAnalyzePage> createState() => _FilterAndAnalyzePageState();
}

class _FilterAndAnalyzePageState extends State<FilterAndAnalyzePage> {
  bool _loading = false;
  FinancialRecordsFilter? _currentFilter;
  final RxList<FinancialRecord> _records =
      RxList<FinancialRecord>.empty(growable: true);

  Future<void> _handleOnFilterSubmitted(
      FinancialRecordsFilter newFilter) async {
    setState(() {
      _loading = true;
      _currentFilter = newFilter;
    });
    _records.addAll(await FinancialRecord.getAll(newFilter));
    setState(() {
      _loading = false;
    });
  }

  void _displayFilterDialog() {
    Get.to(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("Select dataset"),
          leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.close),
          ),
        ),
        body: FilterRecordsForm(
          initialFilter: _currentFilter,
          onSubmit: _handleOnFilterSubmitted,
        ),
      ),
      transition: Transition.downToUp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter and analyze"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayFilterDialog,
        child: const Icon(Icons.filter_alt),
      ),
      body: (_loading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (_records.isEmpty)
              ? const NoItemsWidget(
                  title: "Nothing to analyze",
                  subtitle: "Select dataset at the bottom right corner",
                )
              : FinancialRecordsListWidget(records: _records),
    );
  }
}
