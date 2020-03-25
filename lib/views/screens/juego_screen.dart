import 'package:encontraste/services/database_service.dart';
import 'package:encontraste/views/widgets/button.dart';
import 'package:flutter/material.dart';

class JuegoScreen extends StatefulWidget {
  @override
  _JuegoScreenState createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  var user = "naranja";

  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.red,
          height: 800,
          width: 400,
        ),
        Center(
          child: Container(
            child: new Center(
              child: new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      spreadRadius: -10.0,
                      color: Colors.black87,
                      offset: Offset(7.0, -2.0),
                      blurRadius: 10.0,
                    ),
                    BoxShadow(
                      spreadRadius: -10.0,
                      color: Colors.white70,
                      offset: Offset(-2.0, 5.0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.0),
              ),
            ),
            width: 220.0,
            height: 230.0,
            margin: EdgeInsets.only(bottom: 16.0),
          ),
        ),
        Center(
          child: Container(
            child: new Container(
              child: Center(
                child: Text(
                  "Aceptar",
                  style: TextStyle(color: Colors.white70, fontSize: 30),
                ),
              ),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.red,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    spreadRadius: -10.0,
                    color: Colors.black87,
                    offset: Offset(-5.0, 5.0),
                    blurRadius: 10.0,
                  ),
                  BoxShadow(
                    spreadRadius: -10.0,
                    color: Colors.white70,
                    offset: Offset(5.0, -5.0),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
            ),
            width: 320.0,
            height: 100.0,
            margin: EdgeInsets.only(bottom: 16.0),
          ),
        ),
        Center(
          child: Button(
            child: Icon(Icons.play_arrow),
            color: Colors.red,
            size: 44.0,onPressed: (){},
          ),
        ),
      ],
    );
  }
}
