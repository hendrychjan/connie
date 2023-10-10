import 'package:connie/widgets/common/form/form_field_checkbox.dart';
import 'package:connie/widgets/common/form/form_field_text.dart';
import 'package:flutter/material.dart';

class FirstTimeSetupForm extends StatefulWidget {
  final Function onSubmit;
  const FirstTimeSetupForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<FirstTimeSetupForm> createState() => _FirstTimeSetupFormState();
}

class _FirstTimeSetupFormState extends State<FirstTimeSetupForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentBalanceController = TextEditingController();
  final _showDecimalsController = TextEditingController(text: "false");
  final _currencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormFieldText(
            hint: "What is your current balance?",
            keyboardType: TextInputType.number,
            controller: _currentBalanceController,
            validationRules: const ['required'],
          ),
          FormFieldCheckbox(
            controller: _showDecimalsController,
            label: "Show decimals",
          ),
          FormFieldText(
            hint: "Currency",
            controller: _currencyController,
            validationRules: const ["required"],
          ),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;

              widget.onSubmit({
                "currentBalance":
                    double.tryParse(_currentBalanceController.text) ?? 0.0,
                "showDecimals":
                    bool.tryParse(_showDecimalsController.text) ?? true,
                "currency": _currencyController.text,
              });
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
