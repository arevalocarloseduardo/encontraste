import 'dart:typed_data';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:encontraste/models/sala.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/utils/settings.dart';
import 'package:flutter/material.dart';

class SalaPage extends StatefulWidget {
  SalaPage({this.sala, this.myDataPersona});
  final Sala sala;
  final Persona myDataPersona;
  @override
  _SalaPageState createState() => _SalaPageState();
}

class _SalaPageState extends State<SalaPage> {
  bool _isInChannel = false;
  final _infoStrings = <String>[];

  static final _sessions = List<VideoSession>();
  String dropdownValue = 'Off';


  /// remote user list
  final _remoteUsers = List<int>();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(height: 320, child: _viewRows()),
            OutlineButton(
              child: Text(_isInChannel ? 'Leave Channel' : 'Join Channel',
                  style: textStyle),
              onPressed:(){},
            ),
            Expanded(child: Container(child: _buildInfoList())),
          ],
        ),
      ),
    );
  }

 
  Widget _viewRows() {
    return Row(
      children: <Widget>[
        for (final widget in _renderWidget)
          Expanded(
            child: Container(
              child: widget,
            ),
          )
      ],
    );
  }

  Iterable<Widget> get _renderWidget sync* {
    yield AgoraRenderWidget(0, local: true, preview: false);

    for (final uid in _remoteUsers) {
      yield AgoraRenderWidget(uid);
    }
  }

  VideoSession _getVideoSession(int uid) {
    return _sessions.firstWhere((session) {
      return session.uid == uid;
    });
  }

  List<Widget> _getRenderViews() {
    return _sessions.map((session) => session.view).toList();
  }

  static TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.blue);

  Widget _buildInfoList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemExtent: 24,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(_infoStrings[i]),
        );
      },
      itemCount: _infoStrings.length,
    );
  }
}

class VideoSession {
  int uid;
  Widget view;
  int viewId;

  VideoSession(int uid, Widget view) {
    this.uid = uid;
    this.view = view;
  }
}
