import 'package:encontraste/services/database_service.dart';
import 'package:flutter/material.dart';

import 'package:encontraste/models/utils.dart';

class VerScreen extends StatefulWidget {
  @override
  _VerScreenState createState() => _VerScreenState();
}

class _VerScreenState extends State<VerScreen> {
  final db = DatabaseService();
  List<Utils> utils;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<List<Utils>>(
      stream: db.streamVer(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          utils = snapshot.data;
          var pinto = (utils[0].apreto1 && utils[0].apreto2);
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: pinto
                      ? utils[0].idApreto == "celeste"
                          ? Colors.orange
                          : utils[0].idApreto == "default"
                              ? Colors.grey
                              : Colors.lightBlueAccent
                      : utils[0].idApreto == "naranja"
                          ? Colors.orange
                          : utils[0].idApreto == "default"
                              ? Colors.grey
                              : Colors.lightBlue,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 300,
                        child: Center(
                          child: Text(
                             pinto
                      ? utils[0].idApreto == "celeste"
                          ? "naranja"
                          : utils[0].idApreto == "default"
                              ? ""
                              : "celeste"
                      : utils[0].idApreto == "celeste"
                          ? "celeste"
                          : utils[0].idApreto == "default"
                              ? ""
                              : "naranja", style:
                                  TextStyle(color: Colors.white, fontSize: 28)),
                        ),
                      ),
                      FlatButton(
                          onPressed: () {
                            db.juegoUserClean("g");
                          },
                          child: Icon(Icons.settings_backup_restore))
                    ],
                  ),
                ),
              )
            ],
          );
        } else {
          return Text('Cargando');
        }
      },
    ));
  }
}
