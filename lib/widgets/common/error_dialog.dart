import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(message.toString()),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text("Ok"),
        ),
      ],
    );
  }
}
