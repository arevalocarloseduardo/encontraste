import 'package:cloud_firestore/cloud_firestore.dart'; 

class Utils {
  bool apreto1;
  bool apreto2;

  String idApreto;

  Utils({
    this.apreto1,
    this.apreto2,
    this.idApreto,
  });
  factory Utils.fromMap(Map data) {
    return Utils(
      apreto1: data["apreto_1"] ?? false,
      apreto2: data["apreto_2"] ?? false,
      idApreto: data["id_apreto"] ?? "",
    );
  }
  factory Utils.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
   return Utils(
      apreto1: data["apreto_1"] ?? false,
      apreto2: data["apreto_2"] ?? false,
      idApreto: data["id_apreto"] ?? "",
    );
  }
}
