import 'package:connie/widgets/common/form/form_field_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormFieldMultiselect<T> extends StatefulWidget {
  final String hint;
  final RxList<T> selected;
  final List<T> options;
  final String Function(T) titleGetter;
  const FormFieldMultiselect({
    super.key,
    required this.hint,
    required this.selected,
    required this.options,
    required this.titleGetter,
  });

  @override
  State<FormFieldMultiselect<T>> createState() =>
      _FormFieldMultiselectState<T>();
}

class _FormFieldMultiselectState<T> extends State<FormFieldMultiselect<T>> {
  final _textController = TextEditingController();

  void _displaySelectDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 100,
          width: 50,
          child: ListView.builder(
            itemCount: widget.options.length,
            itemBuilder: (context, index) => Obx(
              () => CheckboxListTile(
                value: widget.selected.contains(widget.options[index]),
                title: Text(widget.titleGetter(widget.options[index])),
                onChanged: (b) {
                  if (b == null) return;

                  setState(() {
                    if (b) {
                      widget.selected.add(widget.options[index]);
                    } else {
                      widget.selected.remove(widget.options[index]);
                    }
                    _textController.text = _textFieldContent();
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _textFieldContent() {
    String text = "";
    for (T t in widget.selected) {
      text += "${widget.titleGetter(t)}, ";
    }

    if (text.isEmpty) return "";

    return text.substring(0, text.length - 2);
  }

  @override
  void initState() {
    super.initState();
    _textController.text = _textFieldContent();
  }

  @override
  Widget build(BuildContext context) {
    return FormFieldText(
      hint: widget.hint,
      controller: _textController,
      onTap: () => _displaySelectDialog(context),
      readOnly: true,
    );
  }
}
