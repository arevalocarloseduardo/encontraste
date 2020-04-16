import 'dart:async';
import 'package:encontraste/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:encontraste/models/persona.dart';
import 'screen_controller.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  AuthenticatedWithoutDate,
  Unauthenticated,
  Empty
}

class AuthController with ChangeNotifier {
  static BuildContext context;

  static AuthController get shared => Provider.of<AuthController>(context);
  //StreamController<Status> _statusUser = StreamController.broadcast();
  final db = DatabaseService();
  StreamSubscription userAuthSub;
  var screen = ScreenController.shared;
  FirebaseAuth _auth;
  FirebaseUser _user;
  GoogleSignIn _googleSignIn;
  Status _status = Status.Uninitialized;

  AuthController()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    userAuthSub = _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  bool get isAuthenticated {
    return _user != null;
  }

  /* Stream<Status> get statusUserChanged {
    return _statusUser.stream;
  }*/

  Status get status => _status;
  FirebaseUser get user => _user;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      //en debug n funciona
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = await addUserToBase(Persona.fromFirebase(firebaseUser));
    }
    notifyListeners();
  }

  Future<Status> addUserToBase(Persona user) async {
    Persona persona = await db.getPersona(user.id);
    bool isPersonaIntoBase = persona.id.isNotEmpty;
    bool isPersonaWithEquipo = persona.idEquipo.isNotEmpty;

    if (isPersonaIntoBase) {
      if (isPersonaWithEquipo) {
        print("usuario registrado y con equipo asignado");
        return Status.Authenticated;
      } else {
        print("usuario registrado y sin equipo asignado");
        return Status.AuthenticatedWithoutDate;
      }
    } else {
      await db.createPersona(user);
      print("usuario registrado y agregado a la base");
      return Status.AuthenticatedWithoutDate;
    }
  }

  @override
  void dispose() {
    if (userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
    }
    super.dispose();
  }
}
