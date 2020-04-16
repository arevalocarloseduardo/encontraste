import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/models/equipo.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/models/punto.dart';
import 'package:encontraste/models/sala.dart';
import 'package:encontraste/models/utils.dart';
import 'package:encontraste/utils/constants.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Persona personaListen(Persona persona) {
    _db
        .collection(Constanst.DB_PERSONAS)
        .document(persona.id)
        .snapshots()
        .listen((onData) {
      return onData.reference
          .snapshots()
          .map((snap) => Persona.fromMap(snap.data))
          .toList();
    });
    return persona;
  }

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
    return null;
  }

  Stream<DocumentSnapshot> streamSubPersonaListen(String id) {
    return _db.collection(Constanst.DB_PERSONAS).document(id).snapshots();
  }

  Stream<QuerySnapshot> streamSalasListen() {
    return _db.collection(Constanst.SALAS).snapshots();
  }

  Stream<DocumentSnapshot> streamGamerListen(Sala sala, String myId) {
    return _db
        .collection(Constanst.SALAS)
        .document(sala.id)
        .collection(Constanst.INTEGRANTES)
        .document(myId)
        .snapshots();
  }

  List<Equipo> streamEquiposListen() {
    _db.collection(Constanst.DB_EQUIPOS).snapshots().listen((onData) {
      return onData.documentChanges
          .map((snap) => Equipo.fromMap(snap.document.data))
          .toList();
    });

    return null;
  }

  Future<bool> createPersona(Persona persona) async {
    await _db.collection(Constanst.DB_PERSONAS).document(persona.id).setData({
      Constanst.NOMBRES: persona.nombres,
      Constanst.APELLIDOS: persona.apellidos,
      Constanst.FECHA_NACIMIENTO: persona.fechaDeNacimiento,
      Constanst.ID_EQUIPO: persona.idEquipo,
      Constanst.SEXO: persona.sexo,
      Constanst.ID_PERSONA: persona.id,
      Constanst.EMAIL: persona.email,
      Constanst.CELULAR: persona.celular,
      Constanst.IMAGEN: persona.imagen
    }).then((value) {
      print("cree esta persona: " + persona.toString());
      return true;
    });
    return false;
  }

  Future<bool> updatePersona(Persona persona) async {
    Map<String, dynamic> map = {
      Constanst.NOMBRES: persona.nombres,
      Constanst.APELLIDOS: persona.apellidos,
      Constanst.FECHA_NACIMIENTO: persona.fechaDeNacimiento,
      Constanst.ID_EQUIPO: persona.idEquipo,
      Constanst.SEXO: persona.sexo,
      Constanst.ID_PERSONA: persona.id,
      Constanst.EMAIL: persona.email,
      Constanst.CELULAR: persona.celular,
      Constanst.IMAGEN: persona.imagen,
    };
    await _db
        .collection(Constanst.DB_PERSONAS)
        .document(persona.id)
        .updateData(map)
        .then((value) {
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

  Stream<List<Persona>> streamListPersonas({
    String idEquipo,
    String nombre,
  }) {
    CollectionReference ref = _db.collection(Constanst.DB_PERSONAS);
    Query query;

    if (idEquipo != null) {
      query = ref.where(Constanst.ID_EQUIPO, isEqualTo: idEquipo);
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

  Future<bool> ingreseSala(Sala sala, String uid) async {
    var snap = await _db.collection(Constanst.SALAS).document(sala.id).get();
    var value = Sala.fromFirestore(snap);
    _db
        .collection(Constanst.SALAS)
        .document(sala.id)
        .updateData({Constanst.INTEGRANTES: value.integrantes + 1});
    _db
        .collection(Constanst.SALAS)
        .document(sala.id)
        .collection(Constanst.INTEGRANTES)
        .document(uid)
        .setData({
      Constanst.ID_PERSONA: uid,
      Constanst.AUDIO: false,
      Constanst.JUGADOR: false,
      Constanst.VIDEO: false,
    });
    return false;
  }

  Future<bool> saliSala(Sala sala, String uid) async {
    var snap = await _db.collection(Constanst.SALAS).document(sala.id).get();
    var value = Sala.fromFirestore(snap);
    _db
        .collection(Constanst.SALAS)
        .document(sala.id)
        .updateData({Constanst.INTEGRANTES: value.integrantes - 1});
    _db
        .collection(Constanst.SALAS)
        .document(sala.id)
        .collection(Constanst.INTEGRANTES)
        .document(uid)
        .delete();
    return false;
  }
}
