import 'package:connie/objects/category.dart';
import 'package:connie/objects/expense.dart';
import 'package:connie/services/hive_service.dart';
import 'package:connie/widgets/category/select_categories_widget.dart';
import 'package:connie/widgets/common/form/form_field_datetime.dart';
import 'package:connie/widgets/common/form/form_field_divider.dart';
import 'package:connie/widgets/common/form/form_field_text.dart';
import 'package:flutter/material.dart';

class ExpenseForm extends StatefulWidget {
  final Function onSubmit;
  final Expense? initialExpense;
  const ExpenseForm({
    this.initialExpense,
    required this.onSubmit,
    super.key,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  bool _loading = true;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _commentController = TextEditingController();
  final List<Category> _categories = List<Category>.empty(growable: true);

  @override
  void initState() {
    super.initState();

    if (widget.initialExpense != null) {
      _titleController.text = widget.initialExpense!.title;
      _amountController.text = widget.initialExpense!.amount.toString();
      _dateController.text = widget.initialExpense!.date.toIso8601String();
      _commentController.text = widget.initialExpense!.comment ?? "";
      Future.delayed(Duration.zero, () async {
        List<Category> categories =
            await Category.getAllByRecord(widget.initialExpense!);
        _categories.addAll(categories);
        setState(() {
          _loading = false;
        });
      });
    } else {
      _dateController.text = DateTime.now().toIso8601String();
      _loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                FormFieldText(
                  hint: "Title",
                  icon: const Icon(Icons.edit),
                  controller: _titleController,
                  validationRules: const ["required"],
                ),
                FormFieldText(
                  hint: "Amount",
                  icon: const Icon(Icons.attach_money),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  validationRules: const ["required"],
                ),
                FormFieldDatetime(
                  hint: "Date",
                  icon: const Icon(Icons.calendar_month),
                  controller: _dateController,
                ),
                FormFieldText(
                  hint: "Comment",
                  icon: const Icon(Icons.notes),
                  controller: _commentController,
                  minLines: 3,
                  maxLines: 10,
                ),
                SelectCategoriesWidget(selected: _categories),
                const FormFieldDivider(),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    await widget.onSubmit(
                      Expense(
                        id: widget.initialExpense?.id ??
                            HiveService.generateId(),
                        title: _titleController.text,
                        amount: double.tryParse(_amountController.text) ?? 0,
                        date: DateTime.tryParse(_dateController.text) ??
                            DateTime.now(),
                        comment: _commentController.text,
                      ),
                      _categories,
                    );
                  },
                  child: Text(
                    (widget.initialExpense == null) ? "Create" : "Update",
                  ),
                ),
              ],
            ),
    );
  }
}
