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
    var color = data[Constanst.COLOR] ?? "celeste";
    var materialColor = color == "rojo" ? Colors.red : Colors.lightBlue;
    return Equipo(puntos: 212,personas: [],
      id: data[Constanst.ID_EQUIPO] ?? "",
      nombre: data[Constanst.NOMBRE_EQUIPO] ?? "",
      color: materialColor,
    );
  }
  factory Equipo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    var color = data[Constanst.COLOR] ?? "celeste";
    var materialColor = color == "rojo" ? Colors.red : Colors.lightBlue;
    return Equipo(
      id: doc.documentID ?? "",puntos: 212,personas: [],
      nombre: data[Constanst.NOMBRE_EQUIPO] ?? "",
      color: materialColor,
    );
  }

  sumarPuntos(int cant) {
    this.puntos += cant;
  }
}
