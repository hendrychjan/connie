import 'package:connie/widgets/common/form/form_field_text.dart';
import 'package:flutter/material.dart';

class ExpenseForm extends StatefulWidget {
  final Function onSubmit;
  const ExpenseForm({
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
  final _dateController = DateTime.now();
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormFieldText(
            hint: "Title",
            controller: _titleController,
          ),
          FormFieldText(
            hint: "Amount",
            controller: _amountController,
          ),
          FormFieldText(
            hint: "Comment",
            controller: _commentController,
          ),
        ],
      ),
    );
  }
}
