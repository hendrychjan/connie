import 'package:connie/objects/expense.dart';
import 'package:connie/services/hive_service.dart';
import 'package:connie/widgets/common/form/form_field_datetime.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialExpense != null) {
      _titleController.text = widget.initialExpense!.title;
      _amountController.text = widget.initialExpense!.amount.toString();
      _dateController.text = widget.initialExpense!.date.toIso8601String();
      _commentController.text = widget.initialExpense!.comment ?? "";
    } else {
      _dateController.text = DateTime.now().toIso8601String();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              await widget.onSubmit(Expense(
                id: widget.initialExpense?.id ?? HiveService.generateId(),
                title: _titleController.text,
                amount: double.tryParse(_amountController.text) ?? 0,
                date: DateTime.tryParse(_dateController.text) ?? DateTime.now(),
                comment: _commentController.text,
              ));
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
