import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/utils/constants.dart';

class Punto {
  String idEquipo;
  int puntos;
  String motivo;
  DateTime fecha;

  Punto({
    this.puntos,
    this.motivo,
    this.idEquipo,
    this.fecha,
  });
  factory Punto.fromMap(Map data) {
    return Punto(
      idEquipo: data[Constanst.ID_EQUIPO] ?? "",
      puntos: data[Constanst.PUNTOS] ?? 0,
      motivo: data[Constanst.MOTIVO] ?? "",
      fecha: DateTime.fromMicrosecondsSinceEpoch(data[Constanst.FECHA] == null
          ? DateTime.now().microsecondsSinceEpoch
          : data[Constanst.FECHA].microsecondsSinceEpoch),
    );
  }
  factory Punto.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Punto(
      idEquipo: data[Constanst.ID_EQUIPO] ?? "",
      puntos: data[Constanst.PUNTOS] ?? 0,
      motivo: data[Constanst.MOTIVO] ?? "",
      fecha: DateTime.fromMicrosecondsSinceEpoch(data[Constanst.FECHA] == null
          ? DateTime.now().microsecondsSinceEpoch
          : data[Constanst.FECHA].microsecondsSinceEpoch),
    );
  }
}
