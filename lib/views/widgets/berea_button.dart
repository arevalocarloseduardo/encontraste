
import 'package:flutter/material.dart';

class BereaButton extends StatelessWidget {
  const BereaButton({
    @required this.onPressed, @required this.text,
  });

  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red,
        child: MaterialButton(
          onPressed: onPressed ?? null,
          child: Text(
            text??"Continuar",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}