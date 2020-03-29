
import 'package:encontraste/models/punto.dart';
import 'package:encontraste/services/database_service.dart';
import 'package:encontraste/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:encontraste/models/utils.dart';

class VerScreen extends StatefulWidget {
  @override
  _VerScreenState createState() => _VerScreenState();
}

class _VerScreenState extends State<VerScreen> {
  final db = DatabaseService();
  List<Utils> utils;
  var height;
  var width;
  
    String nombre="";

  List<Punto> personas;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return true
        ? Container(
            child: StreamBuilder<List<Punto>>(
              stream: db.streamListPuntos(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  personas = snapshot.data;
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                       /* Wrap(
                          children: <Widget>[
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  nombre = value;
                                });
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: 'Search...'),
                            ),
                            Text("Integrantes ${personas.length}",
                                style: TextStyle(color: Colors.black54)),
                          ],
                        ),*/
                        listPersonas(personas)
                      ],
                    ),
                  );
                } else {
                  return Text('Cargando');
                }
              },
            ),
          )
        : Container(
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
                                                : "naranja",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 28)),
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

  listPersonas(List<Punto> personas) {
    List<Widget> listTile = [];
    var percentWidth = width / 4;
    for (var i = 0; i < personas.length; i++) {
      var nombre = personas[i]
          .motivo; // principalHomeController.equipo.personas[i].nombres[0];
      var dia = personas[i].fecha.day.toString(); 
      var mes = personas[i].fecha.month.toString();
      //var id = personas[i].puntos;

      listTile.add(Column(
        children: <Widget>[
          ListTile(
            trailing: GestureDetector(
                onTap: () {
                  // showUpdate(context, personas[i]);
                },
                child: Icon(Icons.view_headline)),
            onTap: () {
              //showPuntos(context);
              // showUpdate(context, personas[i]);
              //db.deletePersona(Persona(id:id));
            },
            title: Text(
              "$nombre $dia/$mes",
              style: TextStyle(
                  color: Colors.black54, fontSize: percentWidth * 0.16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${personas[i].puntos}",
                  style: TextStyle(
                      color: Colors.black54, fontSize: percentWidth * 0.14),
                ),
                Divider()
              ],
            ),
          ),
        ],
      ));
    }
    listTile.add(Padding(
      padding: const EdgeInsets.all(12.0),
      child: FloatingActionButton.extended(
        backgroundColor: BereaColors.purple.withOpacity(0.7),
        onPressed: () {
          // showAgregar(context);
        },
        label: Row(
          children: <Widget>[Icon(Icons.add), Text("Agregar")],
        ),
      ),
    ));
    return Container(
      child: Column(
        children: listTile,
      ),
    );
  }
}
