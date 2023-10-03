import 'package:connie/objects/expense.dart';
import 'package:connie/objects/financial_record.dart';
import 'package:connie/objects/income.dart';
import 'package:connie/pages/financial_record/expense_form_page.dart';
import 'package:connie/pages/financial_record/income_form_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FinancialRecordsListWidget extends StatefulWidget {
  final RxList<FinancialRecord> records;
  final Function? onTap;
  const FinancialRecordsListWidget({
    required this.records,
    this.onTap,
    super.key,
  });

  @override
  State<FinancialRecordsListWidget> createState() =>
      _FinancialRecordsListWidgetState();
}

class _FinancialRecordsListWidgetState
    extends State<FinancialRecordsListWidget> {
  void _handleSelected(FinancialRecord record) {
    if (record is Expense) {
      Get.to(() => ExpenseFormPage(initialExpense: record));
      return;
    }

    if (record is Income) {
      Get.to(() => IncomeFormPage(initialIncome: record));
      return;
    }
  }

  Widget _renderTitle(FinancialRecord record) {
    if (record is Expense) {
      return Text(
        record.amount.toString(),
        style: const TextStyle(
          color: Colors.redAccent,
        ),
      );
    }

    if (record is Income) {
      return Text(
        record.amount.toString(),
        style: const TextStyle(
          color: Colors.greenAccent,
        ),
      );
    }

    return Text(record.amount.toString());
  }

  Widget _renderIcon(FinancialRecord record) {
    if (record is Expense) {
      return const Icon(Icons.shopping_cart);
    }

    if (record is Income) {
      return const Icon(Icons.add_card);
    }

    return const Icon(Icons.attach_money);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        itemCount: widget.records.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _handleSelected(widget.records[index]),
            child: ListTile(
              title: _renderTitle(widget.records[index]),
              subtitle: Text(widget.records[index].title),
              leading: _renderIcon(widget.records[index]),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(DateFormat.yMd().format(widget.records[index].date)),
                  Text(DateFormat.Hm().format(widget.records[index].date)),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
