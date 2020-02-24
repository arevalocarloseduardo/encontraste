import 'package:encontraste/services/database_service.dart';
import 'package:flutter/material.dart';

class JuegoScreen extends StatefulWidget {
  @override
  _JuegoScreenState createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  var user="celeste";
  
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    
    return Container(
      color: Colors.white,
      child: Center(
        child: RawMaterialButton(
          onPressed: () {
             db.juegoUser(user);
          },
          child: new Icon(
            Icons.close,
            color: Colors.white,
            size: 160.0,
          ),
          shape: new CircleBorder(),
          elevation: 4.0,
          fillColor: Colors.red,
          padding: const EdgeInsets.all(15.0),
        ),
      ),
    );
  }
}
