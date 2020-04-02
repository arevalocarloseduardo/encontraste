import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_controller.dart';

class GlobalController with ChangeNotifier {
  DatabaseService _db;
  AuthController _aut;
  StreamSubscription userDate;

  static BuildContext context;
  static GlobalController get shared => Provider.of<GlobalController>(context);

  Persona _myDataPersona = Persona();
  GlobalController() : _db = DatabaseService(),_aut= AuthController.shared{
    userDate = _db.streamSubPersonaListen(_aut.user.uid).listen(_onPersonChanged);
  }
  
  Future<void> _onPersonChanged(DocumentSnapshot document) async {
    if (document.data != null) {
      myDataPersona = Persona.fromFirestore(document);
    }
  }

  Persona get myDataPersona => _myDataPersona;
  set myDataPersona(Persona value) { 
    _myDataPersona = value;
    notifyListeners();
  }

  @override
  void dispose() {
    userDate.cancel();
    super.dispose();
  }
}
