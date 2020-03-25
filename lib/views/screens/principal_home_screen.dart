import 'package:encontraste/controllers/auth_controller.dart';
import 'package:encontraste/controllers/principal_home_controller.dart';
import 'package:encontraste/controllers/screen_controller.dart';
import 'package:encontraste/models/equipo.dart';
import 'package:encontraste/models/juego.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/models/punto.dart';
import 'package:encontraste/services/database_service.dart';
import 'package:encontraste/utils/constants.dart';
import 'package:encontraste/utils/crud.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class PrincipalHomeScreen extends StatefulWidget {
  @override
  _PrincipalHomeScreenState createState() => _PrincipalHomeScreenState();
}

class _PrincipalHomeScreenState extends State<PrincipalHomeScreen> {
  var width;
  var height;
  PrincipalHomeController principalHomeController;
  final db = DatabaseService();
  List<Persona> personas;
  AuthController authUser;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    principalHomeController = Provider.of<PrincipalHomeController>(context);
    authUser = Provider.of<AuthController>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: BereaColors.purple,
          title: GestureDetector(
            onTap: () {
              authUser.signOut();
            },
            child: Container(
              child: Image.asset(
                "assets/logoen.png",
              ),
              height: width * 0.2,
              width: width,
            ),
          ),
        ),
        body: Container(
            child: StreamBuilder<List<Persona>>(
          stream: db.streamListPersonas(
              idEquipo: principalHomeController.equipo.id ?? ""),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              personas = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    cardInformativo(principalHomeController),
                    Text("Integrantes ${personas.length}",
                        style: TextStyle(color: Colors.black54)),
                    listPersonas(principalHomeController, personas)
                  ],
                ),
              );
            } else {
              return Text('Cargando');
            }
          },
        )));
  }

  Widget cardInformativo(PrincipalHomeController principalHomeController) {
    List<Widget> cards = [];
    var percentWidth = width / principalHomeController.reunion.equipos.length;
    for (var i = 0; i < principalHomeController.reunion.equipos.length; i++) {
      cards.add(GestureDetector(
        onLongPress: () {
          setState(() {
            principalHomeController
                .selectEquipo(principalHomeController.reunion.equipos[i]);
            for (var a = 0;
                a < principalHomeController.reunion.equipos.length;
                a++) {
              principalHomeController.select[a] = false;
              if (i == a) {
                principalHomeController.select[i] = true;
              }
            }
          });
          showPuntos(context, Persona(id: "admin"));
        },
        onTap: () {
          setState(() {
            principalHomeController
                .selectEquipo(principalHomeController.reunion.equipos[i]);
            for (var a = 0;
                a < principalHomeController.reunion.equipos.length;
                a++) {
              principalHomeController.select[a] = false;
              if (i == a) {
                principalHomeController.select[i] = true;
              }
            }
          });
        },
        child: Container(
          height: percentWidth / 1.5,
          width: percentWidth,
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              gradient: LinearGradient(colors: [
                principalHomeController.reunion.equipos[i].color
                    .withOpacity(0.6),
                principalHomeController.reunion.equipos[i].color
                    .withOpacity(0.9)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "${principalHomeController.reunion.equipos[i].nombre}",
                  style: TextStyle(
                      color: Colors.white, fontSize: percentWidth * 0.16),
                ),
                Text(
                  "${principalHomeController.reunion.equipos[i].puntos}",
                  style: TextStyle(
                      color: Colors.white, fontSize: percentWidth * 0.14),
                ),
                principalHomeController.select[i]
                    ? Container(
                        color: Colors.white,
                        height: 2,
                        width: percentWidth / 2,
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ));
    }

    return Container(
      child: Row(
        children: cards,
      ),
    );
  }

  Widget listPersonas(
      PrincipalHomeController principalHomeController, List<Persona> personas) {
    List<Widget> listTile = [];
    var percentWidth = width / 4;
    for (var i = 0; i < personas.length; i++) {
      var nombre = personas[i]
          .nombres; // principalHomeController.equipo.personas[i].nombres[0];
      var apellido = personas[i].apellidos;
      var sexo = personas[i].sexo;
      var id = personas[i].id;

      listTile.add(Column(
        children: <Widget>[
          ListTile(
            leading: Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: sexo == "M" ? BereaColors.m : BereaColors.f,
                  child: Text(
                      "${nombre[0]}.${apellido == null || apellido.isEmpty ? '' : apellido[0]}"),
                ),
              ],
            ),
            trailing: GestureDetector(
                onTap: () {
                  showUpdate(context, personas[i]);
                },
                child: Icon(Icons.view_headline)),
            onTap: () {
              showPuntos(context, personas[i]);
              // showUpdate(context, personas[i]);
              //db.deletePersona(Persona(id:id));
            },
            //onTap: () {db.createPersona(Persona(nombres: "Carlos Eduardo",apellidos: "Arevalo",));},
            title: Text(
              "$nombre $apellido",
              style: TextStyle(
                  color: Colors.black54, fontSize: percentWidth * 0.16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${personas[i].getEdad()} años",
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
          showAgregar(context);
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

  void showPuntos(BuildContext context, Persona persona) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var time = DateTime(1995);
          var hombre = true;
          var motivo;
          int puntos;

          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Puntos para el ${principalHomeController.equipo.nombre}",
                          style: TextStyle(color: Colors.green, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.import_contacts)),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.description)),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.group_add)),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.account_balance)),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.timer)),
                              ),
                            ]),
                        TextField(
                          style: TextStyle(color: Colors.black54),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Puntos",
                          ),
                          onChanged: (val) {
                            setState(() {
                              puntos = int.parse(val);
                            });
                          },
                        ),
                        TextField(
                          style: TextStyle(color: Colors.black54),
                          decoration: InputDecoration(
                            labelText: "Motivo:",
                          ),
                          onChanged: (val) {
                            setState(() {
                              motivo = val;
                            });
                          },
                        ),
                        SizedBox(
                          width: 320.0,
                          child: RaisedButton(
                            onPressed: () {
                              var punto = Punto(
                                  idEquipo: principalHomeController.equipo.id,
                                  puntos: puntos,
                                  fecha: DateTime.now(),
                                  idPersona: persona.id,
                                  motivo: motivo ?? "");
                              var equipo = Equipo(
                                id: principalHomeController.equipo.id,
                                nombre: principalHomeController.equipo.nombre,
                                color: principalHomeController.equipo.color,
                                puntos: principalHomeController.equipo.puntos +
                                    puntos,
                              );
                              db.createPuntos(punto);
                              db.updateEquipo(equipo);

                              Navigator.pop(context);
                            },
                            child: Text(
                              "Agregar",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Color(0xFF1BC0C5),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  void showAgregar(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var time = DateTime(1995);
          var persona = principalHomeController.persona;
          var hombre = true;
          var apellidos;
          var nombres;

          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "NUEVO PARTICIPANTE",
                          style: TextStyle(color: Colors.green, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        TextField(
                          style: TextStyle(color: Colors.black54),
                          decoration: InputDecoration(
                            labelText: "Nombres:",
                          ),
                          onChanged: (val) {
                            setState(() {
                              nombres = val;
                            });
                          },
                        ),
                        TextField(
                          style: TextStyle(color: Colors.black54),
                          decoration: InputDecoration(
                            labelText: "Apellidos:",
                          ),
                          onChanged: (val) {
                            setState(() {
                              apellidos = val;
                            });
                          },
                        ),
                        DateTimeField(
                          decoration: InputDecoration(
                            labelText:
                                "Fecha de nacimiento:\n${time.day}/${time.month}/${time.year}",
                          ),
                          style: TextStyle(color: Colors.black54),
                          format: format,
                          onShowPicker: (context, currentValue) async {
                            var times = await showDatePicker(
                                context: context,
                                locale: Locale("es", "ES"),
                                initialDate: time,
                                firstDate: DateTime(1980),
                                lastDate: DateTime(2010),
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.dark(),
                                    child: child,
                                  );
                                });
                            setState(() {
                              time = times ?? DateTime(1995);
                            });
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Text("Masculino:",
                                style: TextStyle(color: Colors.black54)),
                            Checkbox(
                              value: hombre,
                              onChanged: (s) {
                                setState(() {
                                  hombre = true;
                                });
                              },
                            ),
                            Text("Femenino:",
                                style: TextStyle(color: Colors.black54)),
                            Checkbox(
                              value: !hombre,
                              onChanged: (s) {
                                setState(() {
                                  hombre = false;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 320.0,
                          child: RaisedButton(
                            onPressed: () {
                              persona = Persona(
                                  idEquipo: principalHomeController.equipo.id,
                                  apellidos: apellidos,
                                  nombres: nombres,
                                  fechaDeNacimiento: time,
                                  sexo: hombre ? "M" : "F");
                              db.createPersona(persona);

                              Navigator.pop(context);
                            },
                            child: Text(
                              "Crear",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Color(0xFF1BC0C5),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  void showUpdate(BuildContext context, Persona persona) {
    final format = DateFormat("yyyy-MM-dd");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var time = persona.fechaDeNacimiento;
          var hombre = persona.sexo == "M" ? true : false;
          var apellidos = persona.apellidos;
          var nombres = persona.nombres;

          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "INFORMACIÓN PARTICIPANTE",
                          style: TextStyle(color: Colors.green, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        TextFormField(
                          initialValue: nombres,
                          style: TextStyle(color: Colors.black54),
                          decoration: InputDecoration(
                            labelText: "Nombres:",
                          ),
                          onChanged: (val) {
                            setState(() {
                              nombres = val;
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: apellidos,
                          style: TextStyle(color: Colors.black54),
                          decoration: InputDecoration(
                            labelText: "Apellidos:",
                          ),
                          onChanged: (val) {
                            setState(() {
                              apellidos = val;
                            });
                          },
                        ),
                        DateTimeField(
                          decoration: InputDecoration(
                            labelText:
                                "Fecha de nacimiento:\n${time.day}/${time.month}/${time.year}",
                          ),
                          style: TextStyle(color: Colors.black54),
                          format: format,
                          onShowPicker: (context, currentValue) async {
                            var times = await showDatePicker(
                                context: context,
                                locale: Locale("es", "ES"),
                                initialDate: time,
                                firstDate: DateTime(1980),
                                lastDate: DateTime(2010),
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.dark(),
                                    child: child,
                                  );
                                });
                            setState(() {
                              time = times ?? DateTime(1995);
                            });
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Text("Masculino:",
                                style: TextStyle(color: Colors.black54)),
                            Checkbox(
                              value: hombre,
                              onChanged: (s) {
                                setState(() {
                                  hombre = true;
                                });
                              },
                            ),
                            Text("Femenino:",
                                style: TextStyle(color: Colors.black54)),
                            Checkbox(
                              value: !hombre,
                              onChanged: (s) {
                                setState(() {
                                  hombre = false;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 320.0,
                          child: RaisedButton(
                            onPressed: () {
                              persona = Persona(
                                  idEquipo: persona.idEquipo,
                                  id: persona.id,
                                  apellidos: apellidos,
                                  nombres: nombres,
                                  fechaDeNacimiento: time,
                                  sexo: hombre ? "M" : "F");
                              db.updatePersona(persona);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Actualizar",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Color(0xFF1BC0C5),
                          ),
                        ),
                        SizedBox(
                          width: 320.0,
                          child: FlatButton(
                            onPressed: () {
                              persona = Persona(
                                  idEquipo: persona.idEquipo,
                                  id: persona.id,
                                  apellidos: apellidos,
                                  nombres: nombres,
                                  fechaDeNacimiento: time,
                                  sexo: hombre ? "M" : "F");
                              db.deletePersona(persona);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Eliminar Participante",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}

class ProductCard extends StatelessWidget {
  final Persona productDetails;

  ProductCard({@required this.productDetails});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetails(product: productDetails)));
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Card(
          elevation: 5,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        productDetails.nombres[0],
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        ' \$',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            color: Colors.orangeAccent),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
