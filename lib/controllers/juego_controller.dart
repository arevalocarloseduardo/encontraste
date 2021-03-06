import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/models/equipo.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/models/reunion.dart';
//import 'package:encontraste/services/database_service.dart';
import 'package:encontraste/utils/constants.dart';
import 'package:flutter/material.dart';

class JuegoController with ChangeNotifier {
  JuegoController() {
    print("inicio provider");
    init();
  }
  Persona _persona = Persona();
  Persona get persona => _persona;
  set persona(Persona newPersona) {
    _persona = newPersona;
    notifyListeners();
  }

  DateTime _time = DateTime(1995);
  DateTime get time => _time;
  set time(DateTime time) {
    _time = time;
    print("SETEA");
    notifyListeners();
  }

  var _select = [];
  get select => _select;

  Reunion _reunion;
  List<Equipo> _equipos;
  Equipo _equipo = Equipo();

  Reunion get reunion => _reunion;
  List<Equipo> get equipos => _equipos;
  Equipo get equipo => _equipo;

  void selectEquipo(Equipo equipo) {
    _equipo = equipo;
    notifyListeners();
  }

  init() {
    //var personasS = DatabaseService().streamPersonaListen();
    List<Equipo> equiposStream = [];
    Firestore.instance
        .collection(Constanst.DB_EQUIPOS)
        .snapshots()
        .listen((onData) {
      var liste =
          onData.documents.map((snap) => Equipo.fromFirestore(snap)).toList();
      print(liste.length);

      notifyListeners();
      if (liste != null) {
        equiposStream = liste;
        _reunion = Reunion(tipo: "Jovenes", equipos: equiposStream);
        _select.clear();

        _reunion.equipos.forEach((f) {
          _select.add(false);
        });
      }
    });
  }
}
