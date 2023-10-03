import 'package:connie/forms/income_form.dart';
import 'package:connie/objects/category.dart';
import 'package:connie/objects/income.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncomeFormPage extends StatefulWidget {
  final Income? initialIncome;
  const IncomeFormPage({
    super.key,
    this.initialIncome,
  });

  @override
  State<IncomeFormPage> createState() => _IncomeFormPageState();
}

class _IncomeFormPageState extends State<IncomeFormPage> {
  bool _loading = false;

  Future<void> _handleSubmit(Income payload, List<Category> categories) async {
    setState(() {
      _loading = true;
    });
    await payload.save(categories);
    setState(() {
      _loading = true;
    });
    Get.back();
  }

  Future<void> _handleDelete() async {
    setState(() {
      _loading = true;
    });
    // The initialIncome can never be null, because _handleDelete is only
    // called from a widget that is rendered conditionally when the
    // initialIncome is not null
    await widget.initialIncome!.delete();
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
          (widget.initialIncome == null) ? "New income" : "Edit income",
        ),
        actions: [
          if (widget.initialIncome != null)
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
          : IncomeForm(
              onSubmit: _handleSubmit,
              initialIncome: widget.initialIncome,
            ),
    );
  }
}
