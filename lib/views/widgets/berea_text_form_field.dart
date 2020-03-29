import 'package:encontraste/utils/constants.dart';
import 'package:encontraste/utils/validators.dart';
import 'package:flutter/material.dart';

class BereaTextFormField extends StatelessWidget {
  const BereaTextFormField({
    Key key,
    @required TextEditingController textController,
    IconData icon,
    TextInputType keyboardType,
    bool autovalidate,
    @required String label,
  })  : _textController = textController,
        _label = label,
        _icon = icon,
        _autovalidate = autovalidate,
        _keyboardType = keyboardType,
        super(key: key);

  final TextEditingController _textController;
  final String _label;
  final IconData _icon;
  final bool _autovalidate;
  final TextInputType _keyboardType;

  @override
  Widget build(BuildContext context) {
    var color = Colors.white;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          autovalidate: _autovalidate ?? false,
          keyboardType: _keyboardType ?? TextInputType.text,
          controller: _textController,
          validator: (value) => _keyboardType == TextInputType.phone
              ? Validators.validateTel(value)
              : (value.isEmpty)
                  ? "Por favor ingrese ${_label.toLowerCase()}"
                  : null,
          style: TextStyle(color: color),
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(40),
              ),
              filled: true,
              fillColor: BereaColors.secondary.withOpacity(0.4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: BereaColors.secondary.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(40),
              ),
              //fillColor: Colors.white70,
              focusColor: color,
              hintStyle: new TextStyle(color: Colors.grey[800]),
              prefixIcon: Icon(
                _icon ?? Icons.chevron_right,
                color: color,
              ),
              labelText: _label ?? "Label",
              labelStyle: TextStyle(color: color)
              /* border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(40.0),
              ),
            ),*/
              ),
        ));
  }
}
