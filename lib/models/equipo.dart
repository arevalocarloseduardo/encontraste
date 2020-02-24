import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/utils/constants.dart';
import 'package:flutter/material.dart';

class Equipo {
  String id;
  String nombre;
  List<Persona> personas;
  int puntos;
  Color color;

  Equipo({this.id, this.nombre, this.personas, this.puntos, this.color});
  factory Equipo.fromMap(Map data) {
    print(data);
    var color = data[Constanst.COLOR] ?? "Celeste";
    var materialColor = color == "Celeste"
        ? Colors.lightBlue
        : color == "Naranja" ? Colors.orange : Colors.lightBlue;
    return Equipo(
      puntos: data[Constanst.PUNTOS]??0,
      personas: [],
      id: data[Constanst.ID_EQUIPO] ?? "",
      nombre: data[Constanst.NOMBRE_EQUIPO] ?? "",
      color: materialColor,
    );
  }
  factory Equipo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    var color = data[Constanst.COLOR] ?? "Celeste";
    var materialColor = color == "Celeste"
        ? Colors.lightBlue
        : color == "Naranja" ? Colors.orange : Colors.lightBlue;
    return Equipo(
      id: doc.documentID ?? "",
      puntos: data[Constanst.PUNTOS] ?? 0,
      personas: [],
      nombre: data[Constanst.NOMBRE_EQUIPO] ?? "",
      color: materialColor,
    );
  }

  sumarPuntos(int cant) {
    this.puntos += cant;
  }
}
