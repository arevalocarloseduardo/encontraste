import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/utils/constants.dart';

class Persona {
  String id;
  String idEquipo;
  String nombres;
  String apellidos;
  DateTime fechaDeNacimiento;
  String sexo;

  Persona(
      {this.id,
      this.nombres,
      this.apellidos,
      this.idEquipo,
      this.fechaDeNacimiento,
      this.sexo,});
  factory Persona.fromMap(Map data) {
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
    );
  }
  factory Persona.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    var cumple=DateTime.fromMicrosecondsSinceEpoch(
          data[Constanst.FECHA_NACIMIENTO] == null
              ? DateTime.now().microsecondsSinceEpoch
              : data[Constanst.FECHA_NACIMIENTO].microsecondsSinceEpoch);
    return Persona(
      id: doc.documentID ?? "",
      idEquipo: data[Constanst.ID_EQUIPO] ?? "",
      nombres: data[Constanst.NOMBRES] ?? "",
      apellidos: data[Constanst.APELLIDOS] ?? "",
      fechaDeNacimiento:cumple,
      sexo: data[Constanst.SEXO] ?? "",
    );
  }

  int getEdad(){    
    var cumple=this.fechaDeNacimiento;
   var hoy=DateTime.now();     
      var edad=hoy.year-cumple.year;
      var m = hoy.month-cumple.month;
       if (m < 0 || (m == 0 && hoy.month < cumple.month)) {
        edad--;
    }
    return edad;
  }
}
