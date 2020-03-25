import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/models/equipo.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/models/punto.dart';
import 'package:encontraste/models/utils.dart';
import 'package:encontraste/utils/constants.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Future<Persona> getPersona(String id) async {
    var snap = await _db.collection(Constanst.DB_PERSONAS).document(id).get();
    return Persona.fromMap(snap.data);
  }

  Stream<Persona> streamPersona(String id) {
    return _db
        .collection(Constanst.DB_PERSONAS)
        .document(id)
        .snapshots()
        .map((snap) => Persona.fromMap(snap.data));
  }

  List<Persona> streamPersonaListen() {
    _db.collection(Constanst.DB_PERSONAS).snapshots().listen((onData) {
      return onData.documentChanges
          .map((snap) => Persona.fromMap(snap.document.data))
          .toList();
    });
  }

  List<Equipo> streamEquiposListen() {
    _db.collection(Constanst.DB_EQUIPOS).snapshots().listen((onData) {
      return onData.documentChanges
          .map((snap) => Equipo.fromMap(snap.document.data))
          .toList();
    });
  }

  Future<bool> createPersona(Persona persona) async {
    await _db.collection(Constanst.DB_PERSONAS).document().setData({
      Constanst.NOMBRES: persona.nombres,
      Constanst.APELLIDOS: persona.apellidos,
      Constanst.FECHA_NACIMIENTO: persona.fechaDeNacimiento,
      Constanst.ID_EQUIPO: persona.idEquipo,
      Constanst.SEXO: persona.sexo,
      Constanst.ID_PERSONA: persona.id
    }).then((value) {
      return true;
    });
    return false;
  }

  Future<bool> updatePersona(Persona persona) async {
    await _db
        .collection(Constanst.DB_PERSONAS)
        .document(persona.id)
        .updateData({
      Constanst.NOMBRES: persona.nombres,
      Constanst.APELLIDOS: persona.apellidos,
      Constanst.FECHA_NACIMIENTO: persona.fechaDeNacimiento,
      Constanst.ID_EQUIPO: persona.idEquipo,
      Constanst.SEXO: persona.sexo,
      Constanst.ID_PERSONA: persona.id
    }).then((value) {
      return true;
    });
    return false;
  }

  Future<bool> deletePersona(Persona persona) async {
    await _db
        .collection(Constanst.DB_PERSONAS)
        .document(persona.id)
        .delete()
        .then((value) {
      return true;
    });
    return false;
  }

  Stream<List<Persona>> streamListPersonas({String idEquipo, String nombre,}) {
    CollectionReference ref = _db.collection(Constanst.DB_PERSONAS);
    Query query;

    if (idEquipo != null) {
      query = ref
          .where(Constanst.ID_EQUIPO, isEqualTo: idEquipo);
      return query.snapshots().map((list) =>
          list.documents.map((doc) => Persona.fromFirestore(doc)).toList());
    } else {
      
     

      return ref.snapshots().map((list) =>
          list.documents.map((doc) => Persona.fromFirestore(doc)).toList());
    }
  }
  Stream<List<Punto>> streamListPuntos() {
    CollectionReference ref = _db.collection(Constanst.PUNTOS);
    Query query;

      query = ref;
      return query.snapshots().map((list) =>
          list.documents.map((doc) => Punto.fromFirestore(doc)).toList());
   
  }

  Stream<List<Utils>> streamVer() {
    var ref = _db.collection("utils");
    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Utils.fromFirestore(doc)).toList());
  }

  bool createPuntos(Punto punto) {
    _db.collection(Constanst.PUNTOS).document().setData({
      Constanst.FECHA: punto.fecha,
      Constanst.ID_EQUIPO: punto.idEquipo,
      Constanst.MOTIVO: punto.motivo,
      Constanst.PUNTOS: punto.puntos,
      Constanst.ID_PERSONA: punto.idPersona
    }).then((value) {
      return true;
    });
    return false;
  }

  Future<bool> updateEquipo(Equipo equipo) async {
    await _db.collection(Constanst.DB_EQUIPOS).document(equipo.id).updateData({
      Constanst.COLOR: equipo.nombre,
      Constanst.ID_EQUIPO: equipo.id,
      Constanst.NOMBRE_EQUIPO: equipo.nombre,
      Constanst.PUNTOS: equipo.puntos,
    }).then((value) {
      return true;
    });
    return false;
  }

  Future<bool> juegoUser(String user) async {
    if (user == "celeste") {
      await _db
          .collection("utils")
          .document("GGRiMDcXMFc9jYl2fX4S")
          .updateData({
        "id_apreto": user,
        "apreto_2": true,
      }).then((value) {
        return true;
      });
      return false;
    } else {
      await _db
          .collection("utils")
          .document("GGRiMDcXMFc9jYl2fX4S")
          .updateData({
        "id_apreto": user,
        "apreto_1": true,
      }).then((value) {
        return true;
      });
      return false;
    }
  }

  Future<bool> juegoUserClean(String user) async {
    await _db.collection("utils").document("GGRiMDcXMFc9jYl2fX4S").updateData({
      "id_apreto": "default",
      "apreto_1": false,
      "apreto_2": false,
    }).then((value) {
      return true;
    });
    return false;
  }
}
