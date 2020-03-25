import 'package:encontraste/utils/constants.dart';
import 'package:flutter/material.dart';

class BereaTextFormField extends StatelessWidget {
  const BereaTextFormField({
    Key key,
    @required TextEditingController textController,
    @required String label,
  })  : _textController = textController,
        _label = label,
        super(key: key);

  final TextEditingController _textController;
  final String _label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _textController,
        validator: (value) => (value.isEmpty)
            ? "Por favor ingrese ${_label.toLowerCase()}"
            : null,
        style: BereaStyles.style,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            labelText: _label ?? "Label",
            border: OutlineInputBorder()),
      ),
    );
  }
}
