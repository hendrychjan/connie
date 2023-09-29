import 'package:connie/getx/app_controller.dart';
import 'package:connie/pages/category/categories_overview_page.dart';
import 'package:connie/pages/financial_record/expense_form_page.dart';
import 'package:connie/widgets/financial_record/financial_records_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
            IconButton(
              onPressed: () => Get.to(() => const CategoriesOverviewPage()),
              icon: const Icon(Icons.category),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_alt),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bar_chart),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const ExpenseFormPage()),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "1 924 Kč",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Actual balance"),
                ),
              ],
            ),
          ),
          const Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "-834 Kč",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Weekly spendings"),
                ),
              ],
            ),
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
