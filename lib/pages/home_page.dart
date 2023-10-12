import 'package:connie/getx/app_controller.dart';
import 'package:connie/pages/category/categories_overview_page.dart';
import 'package:connie/pages/financial_record/expense_form_page.dart';
import 'package:connie/pages/financial_record/income_form_page.dart';
import 'package:connie/pages/settings_page.dart';
import 'package:connie/widgets/financial_record/finance_card_widget.dart';
import 'package:connie/widgets/financial_record/financial_records_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _openNewRecordDialog() {
    Get.dialog(AlertDialog(
      title: const Text("Create"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
              Get.to(() => const IncomeFormPage());
            },
            icon: const Icon(Icons.add_card),
            label: const Text("Income"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
              Get.to(() => const ExpenseFormPage());
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text("Expense"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: Get.back, child: const Text("Cancel")),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connie"),
        scrolledUnderElevation: 0.0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              onPressed: () => Get.to(() => const SettingsPage()),
              icon: const Icon(Icons.settings),
            ),
            IconButton(
              onPressed: () => Get.to(() => const CategoriesOverviewPage()),
              icon: const Icon(Icons.category),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewRecordDialog,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FinanceCardWidget(
            value: AppController.to.currentBalance,
            title: "Current balance",
          ),
          FinanceCardWidget(
            value: AppController.to.periodExpenses,
            title: "Weekly expenses",
            color: Colors.redAccent,
          ),
          const Divider(),
          Expanded(
            child: FinancialRecordsListWidget(
              records: AppController.to.weeklyRecords,
            ),
          ),
        ],
      ),
    );
  }
}
