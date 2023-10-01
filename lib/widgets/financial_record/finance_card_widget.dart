import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinanceCardWidget extends StatefulWidget {
  final RxDouble value;
  final String title;
  const FinanceCardWidget({
    super.key,
    required this.value,
    required this.title,
  });

  @override
  State<FinanceCardWidget> createState() => _FinanceCardWidgetState();
}

class _FinanceCardWidgetState extends State<FinanceCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Obx(
              () => Text(
                "${widget.value} Kč",
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(widget.title),
          ),
        ],
      ),
    );
  }
}
