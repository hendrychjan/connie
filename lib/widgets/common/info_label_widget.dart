import 'package:flutter/material.dart';

class InfoLabelWidget extends StatelessWidget {
  final String message;
  final TextAlign? textAlign;
  const InfoLabelWidget({
    super.key,
    required this.message,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          message,
          textAlign: textAlign ?? TextAlign.center,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
