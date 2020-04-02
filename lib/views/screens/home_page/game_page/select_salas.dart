import 'dart:async';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/controllers/rtm_controller.dart';
import 'package:encontraste/models/sala.dart';
import 'package:encontraste/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import './call.dart';
import 'chat.dart';
import 'game_page_demo.dart';

class SelectSala extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<SelectSala> {
  StreamSubscription salasStream;

  final _db = DatabaseService();
  List<Sala> salas = List<Sala>();

  RtmController rtm;
  @override
  void dispose() {
    super.dispose();
    salasStream.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    rtm = Provider.of<RtmController>(context);
    
  }
  @override
  void initState() {
    super.initState();
    salasStream = _db.streamSalasListen().listen(_onPersonChanged);
  }

  _onPersonChanged(QuerySnapshot onData) {
    setState(() {
      salas = onData.documents.map((docs) => Sala.fromMap(docs.data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          height: 400,
          child: ListView.builder(
            itemCount: salas.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () => selectSala(salas[index]),
                child: Card(
                    child: ListTile(
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      salas[index].disponible
                          ? Text("disponible")
                          : Text("no disponble")
                    ],
                  ),
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.arrow_forward_ios)],
                  ),
                  title: Text(salas[index].salaName),
                  subtitle: Text("${salas[index].integrantes} Usuarios"),
                )),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> selectSala(Sala sala) async {
    switch (sala.channelName) {
      case "room_game1":
        joinGameDraw(sala);
        break;
        case "room_game2":
        joinGameDraw(sala);
        break;
      default:
    }
  }

  Future<void> joinGameDraw(Sala sala) async {
    await rtm.ingresarSala(sala);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePageDemo(sala:sala),
      ),
    );
  }

  Future<void> onJoin(String channelName) async {
    if (channelName.isNotEmpty) {
      await _handleCameraAndMic();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: channelName,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
