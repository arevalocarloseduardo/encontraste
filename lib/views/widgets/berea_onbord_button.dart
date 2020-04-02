import 'package:encontraste/utils/constants.dart';
import 'package:flutter/material.dart';

class BereaOnboardButton extends StatefulWidget {
  BereaOnboardButton({
    @required this.text,
    @required this.onPressed,
    this.padding,
    this.color,
    this.gradient,
    this.icon,
    this.stretch,
    this.enabled = true,
    this.child,
  });
  
  final String text;
  final Function onPressed;
  final EdgeInsetsGeometry padding;
  final Color color;
  final bool enabled;
  final Widget icon;
  final LinearGradient gradient;
  final bool stretch;
  final Widget child;

  @override
  _BereaOnboardButtonState createState() => _BereaOnboardButtonState();
}

class _BereaOnboardButtonState extends State<BereaOnboardButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: ColorFiltered(
        colorFilter: widget.enabled
            ? ColorFilter.mode(Colors.black.withOpacity(0.0), BlendMode.dstOut)
            : ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstOut),
        child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0)),
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      BereaColors.secondary,
                      BereaColors.purple,
                    ]),
                border: Border.all(color: Colors.white54),
                borderRadius: BorderRadius.all(Radius.circular(80.0)),
              ),
              child: Container(
                constraints: BoxConstraints(minWidth: 150, minHeight: 62),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.text ?? "",
                        style: TextStyle(color: Colors.white, fontSize: 22))
                  ],
                ),
              ),
            ),
            onPressed: widget.onPressed),
      ),
    );
  }
}
