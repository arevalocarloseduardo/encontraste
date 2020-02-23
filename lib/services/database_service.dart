import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/models/equipo.dart';
import 'package:encontraste/models/persona.dart';
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

  Stream<List<Persona>> streamListPersonas() {
    var ref = _db.collection(Constanst.DB_PERSONAS);
    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Persona.fromFirestore(doc)).toList());
  }
}
