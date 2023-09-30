import 'package:flutter/material.dart';

class FormFieldDivider extends StatelessWidget {
  const FormFieldDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Divider(),
    );
  }
}
