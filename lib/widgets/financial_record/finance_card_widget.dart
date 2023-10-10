import 'package:connie/getx/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinanceCardWidget extends StatefulWidget {
  final RxDouble value;
  final String title;
  final Color? color;
  const FinanceCardWidget({
    super.key,
    required this.value,
    required this.title,
    this.color,
  });

  @override
  State<FinanceCardWidget> createState() => _FinanceCardWidgetState();
}

class _FinanceCardWidgetState extends State<FinanceCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Obx(
              () => Text(
                AppController.to.currencyFormat.format(widget.value.value),
                style: TextStyle(
                  fontSize: 30,
                  color: widget.color,
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
