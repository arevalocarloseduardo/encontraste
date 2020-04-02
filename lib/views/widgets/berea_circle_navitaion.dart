import 'package:encontraste/utils/constants.dart';
import 'package:flutter/material.dart';

class BereaCirclePosition extends StatelessWidget {
  const BereaCirclePosition({
    Key key,
    this.flex = 2,
    this.width,
    this.icon,
    this.isSelect,
    this.isCompleted,
    this.cantWidget = 6,
    @required this.ordenPosition,
    this.heigth,
    this.flexTotal = 21,
    this.child,
    this.onPressed,
  }) : super(key: key);

  final int flex;
  final bool isSelect;
  final bool isCompleted;
  final double width;
  final int cantWidget;
  final int ordenPosition;
  final double heigth;
  final int flexTotal;
  final Widget child;
  final Function onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Positioned(
      left: width ?? w / cantWidget * (ordenPosition - 1),
      right: width ?? w / cantWidget * (cantWidget - ordenPosition),
      top: ordenPosition % 2 != 0 ? heigth ?? h / flexTotal * flex / 2 : 0,
      bottom: ordenPosition % 2 == 0 ? heigth ?? h / flexTotal * flex / 2 : 0,
      child: child ??
          ColorFiltered(
              colorFilter: isSelect ?? false
                  ? ColorFilter.mode(
                      Colors.black.withOpacity(0.0), BlendMode.dstOut)
                  : isCompleted ?? false
                      ? ColorFilter.mode(
                          Colors.green.withOpacity(0.6), BlendMode.srcATop)
                      : ColorFilter.mode(
                          Colors.black.withOpacity(0.7), BlendMode.dstOut),
              child: FloatingActionButton(
                
              heroTag: "Increment $ordenPosition",
                  elevation: 24.5,
                  backgroundColor: BereaColors.secondary,
                  onPressed: onPressed ?? () {},
                  child: Icon(icon))),
    );
  }
}