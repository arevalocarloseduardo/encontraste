import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/utils/constants.dart';

class Sala {
  String channelName;
  String id;
  bool disponible;
  int integrantes;
  String salaName;

  Sala(
      {this.channelName,
      this.id,
      this.disponible,
      this.integrantes,
      this.salaName});
  factory Sala.fromMap(Map map) {
    var data = map ?? {};
    return Sala(
      id: data[Constanst.ID_SALA] ?? "",
      channelName: data[Constanst.CHANNEL_NAME] ?? "",
      disponible: data[Constanst.DISPONIBLE] ?? false,
      integrantes: data[Constanst.INTEGRANTES] ?? 0,
      salaName: data[Constanst.SALA_NAME] ?? "",
    );
  }
  factory Sala.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    if (data != null) {
      return Sala(
        id: doc.documentID ?? "",
        channelName: data[Constanst.CHANNEL_NAME] ?? "",
        disponible: data[Constanst.DISPONIBLE] ?? false,
        integrantes: data[Constanst.INTEGRANTES] ?? 0,
        salaName: data[Constanst.SALA_NAME] ?? "",
      );
    }
    return null;
  }
}
