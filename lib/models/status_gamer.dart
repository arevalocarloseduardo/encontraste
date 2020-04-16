import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/utils/constants.dart';

class StatusGamer {
  bool audio;
  String id;
  bool jugador;
  bool video;
  String adivina;
  StatusGamer({this.audio, this.id, this.jugador, this.video, this.adivina});
  factory StatusGamer.fromMap(Map map) {
    var data = map ?? {};
    return StatusGamer(
      id: data[Constanst.ID_PERSONA] ?? "",
      audio: data[Constanst.AUDIO] ?? false,
      jugador: data[Constanst.JUGADOR] ?? false,
      video: data[Constanst.VIDEO] ?? false,
      adivina: data[Constanst.ADIVINA] ?? "",
    );
  }
  factory StatusGamer.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    if (data != null) {
      return StatusGamer(
        id: doc.documentID ?? "",
        audio: data[Constanst.AUDIO] ?? false,
        jugador: data[Constanst.JUGADOR] ?? false,
        video: data[Constanst.VIDEO] ?? false,
        adivina: data[Constanst.ADIVINA] ?? "",
      );
    }
    return null;
  }
}
