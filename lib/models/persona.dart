import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Persona {
  String id;
  String idEquipo;
  String nombres;
  String apellidos;
  DateTime fechaDeNacimiento;
  String sexo;
  String imagen;
  String celular;
  String email;

  Persona(
      {this.id,
      this.nombres,
      this.apellidos,
      this.idEquipo,
      this.fechaDeNacimiento,
      this.sexo,
      this.imagen,
      this.celular,
      this.email});
  factory Persona.fromMap(Map map) {
    var data = map ?? {};
    return Persona(
      id: data[Constanst.ID_PERSONA] ?? "",
      idEquipo: data[Constanst.ID_EQUIPO] ?? "",
      nombres: data[Constanst.NOMBRES] ?? "",
      apellidos: data[Constanst.APELLIDOS] ?? "",
      fechaDeNacimiento: DateTime.fromMicrosecondsSinceEpoch(
          data[Constanst.FECHA_NACIMIENTO] == null
              ? DateTime.now().microsecondsSinceEpoch
              : data[Constanst.FECHA_NACIMIENTO].microsecondsSinceEpoch),
      sexo: data[Constanst.SEXO] ?? "",
      imagen: data[Constanst.IMAGEN] ?? "",
      celular: data[Constanst.CELULAR] ?? "",
      email: data[Constanst.EMAIL] ?? "",
    );
  }

  factory Persona.fromAuth(AuthResult result) {
    var user = result.user;

    return Persona(
        id: user.uid ?? "",
        nombres: user.displayName ?? "",
        apellidos: "",
        fechaDeNacimiento: DateTime.now(),
        sexo: "M",
        celular: user.phoneNumber ?? "",
        idEquipo: "",
        email: user.email ?? "",
        imagen: user.photoUrl ?? "");
  }
  factory Persona.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    var cumple = DateTime.fromMicrosecondsSinceEpoch(
        data[Constanst.FECHA_NACIMIENTO] == null
            ? DateTime.now().microsecondsSinceEpoch
            : data[Constanst.FECHA_NACIMIENTO].microsecondsSinceEpoch);
    return Persona(
      id: doc.documentID ?? "",
      idEquipo: data[Constanst.ID_EQUIPO] ?? "",
      nombres: data[Constanst.NOMBRES] ?? "",
      apellidos: data[Constanst.APELLIDOS] ?? "",
      fechaDeNacimiento: cumple,
      sexo: data[Constanst.SEXO] ?? "",
      imagen: data[Constanst.IMAGEN] ?? "",
      celular: data[Constanst.CELULAR] ?? "",
      email: data[Constanst.EMAIL] ?? "",
    );
  }

  factory Persona.fromFirebase(FirebaseUser firebaseUser) {
    var user = firebaseUser;
    return Persona(
        id: user.uid ?? "",
        nombres: user.displayName ?? "",
        apellidos: "",
        fechaDeNacimiento: DateTime.now(),
        sexo: "M",
        celular: user.phoneNumber ?? "",
        idEquipo: "",
        email: user.email ?? "",
        imagen: user.photoUrl ?? "");
  }

  int getEdad() {
    var cumple = this.fechaDeNacimiento;
    var hoy = DateTime.now();
    var edad = hoy.year - cumple.year;
    var m = hoy.month - cumple.month;
    if (m < 0 || (m == 0 && hoy.month < cumple.month)) {
      edad--;
    }
    return edad;
  }
}
