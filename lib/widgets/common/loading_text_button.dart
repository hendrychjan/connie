import 'package:flutter/material.dart';

class LoadingTextButton extends StatefulWidget {
  final Function onPressed;
  final String label;
  final Icon icon;
  const LoadingTextButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  State<LoadingTextButton> createState() => _LoadingTextButtonState();
}

class _LoadingTextButtonState extends State<LoadingTextButton> {
  bool _isLoading = false;

  void _handlePressed() async {
    setState(() {
      _isLoading = true;
    });
    await widget.onPressed();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: (!_isLoading) ? _handlePressed : null,
      icon: (!_isLoading)
          ? widget.icon
          : const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
      label: Text(widget.label),
    );
  }
}
