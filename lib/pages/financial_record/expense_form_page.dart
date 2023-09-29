import 'package:connie/forms/expense_form.dart';
import 'package:connie/objects/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseFormPage extends StatefulWidget {
  final Expense? initialExpense;
  const ExpenseFormPage({this.initialExpense, super.key});

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  bool _loading = false;

  Future<void> _handleSubmit(Expense payload) async {
    setState(() {
      _loading = true;
    });
    await payload.save();
    setState(() {
      _loading = true;
    });
    Get.back();
  }

  Future<void> _handleDelete() async {
    setState(() {
      _loading = true;
    });
    // The initialExpense can never be null, because _handleDelete is only
    // called from a widget that is rendered conditionally when the
    // initialExpense is not null
    await widget.initialExpense!.delete();
    setState(() {
      _loading = true;
    });
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.initialExpense == null) ? "New expense" : "Edit expense",
        ),
        actions: [
          if (widget.initialExpense != null)
            IconButton(
              onPressed: _handleDelete,
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ExpenseForm(
              onSubmit: _handleSubmit,
              initialExpense: widget.initialExpense,
            ),
    );
  }
}
