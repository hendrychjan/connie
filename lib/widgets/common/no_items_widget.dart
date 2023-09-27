import 'package:flutter/material.dart';

class NoItemsWidget extends StatefulWidget {
  final String? subtitle;
  const NoItemsWidget({super.key, this.subtitle});

  @override
  State<NoItemsWidget> createState() => _NoItemsWidgetState();
}

class _NoItemsWidgetState extends State<NoItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "No items so far",
            style: TextStyle(fontSize: 18),
          ),
          if (widget.subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(widget.subtitle!),
            ),
        ],
      ),
    );
  }
}
