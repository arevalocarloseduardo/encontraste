import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontraste/controllers/rtm_controller.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/models/sala.dart';
import 'package:encontraste/models/status_gamer.dart';
import 'package:encontraste/services/database_service.dart';
import 'package:encontraste/views/widgets/draw_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GamePageDemo extends StatefulWidget {
  GamePageDemo({this.sala, this.persona});
  final Sala sala;
  final Persona persona;
  @override
  _GamePageDemoState createState() => _GamePageDemoState();
}

class _GamePageDemoState extends State<GamePageDemo> {
  StreamSubscription gamerStatus;
  final _db = DatabaseService();
  bool _finished;

  PainterController _controller;

  RtmController rtm;
  StatusGamer status;

  TextEditingController text = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    rtm.salirSala(widget.sala);
    text.dispose();
    gamerStatus.cancel();
  }

  @override
  void initState() {
    text.text = "";
    _finished = false;
    _controller = _newController();
    gamerStatus = _db
        .streamGamerListen(widget.sala, widget.persona.id)
        .listen(_onGamerChanged);
    super.initState();
  }

  _onGamerChanged(DocumentSnapshot onData) {
    setState(() {
      status = StatusGamer.fromMap(onData.data);
    });
  }

  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 3.0;
    controller.backgroundColor = Colors.white;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    rtm = Provider.of<RtmController>(context);
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        new IconButton(
          icon: new Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
            _finished = false;
            _controller = _newController();
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        new IconButton(
            icon: new Icon(Icons.undo),
            tooltip: 'Undo',
            onPressed: _controller.undo),
        new IconButton(
            icon: new Icon(Icons.delete),
            tooltip: 'Clear',
            onPressed: _controller.clear),
      ];
    }
    return new Scaffold(
      appBar: new AppBar(
          title: const Text('Painter Example'),
          actions: actions,
          bottom: new PreferredSize(
            child: new DrawBar(_controller),
            preferredSize: new Size(MediaQuery.of(context).size.width, 30.0),
          )),
      body: status == null
          ? CircularProgressIndicator()
          : status.jugador
              ? Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Dibuja lo siguiente: ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${status.adivina}",
                          style: TextStyle(fontSize: 26, color: Colors.green),
                        ),
                      ],
                    ),
                    Center(
                        child: new AspectRatio(
                            aspectRatio: 1.0,
                            child:
                                new Painter(painterController: _controller))),
                  ],
                )
              : Column(
                  children: <Widget>[
                    Center(
                      child: new AspectRatio(
                          aspectRatio: 1.0,
                          child: new Painter(
                              painterController: _controller,
                              draw: false,
                              status: status)),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          child: TextFormField(
                            controller: text,
                            decoration: InputDecoration(
                                hintText: "escribe lo que es",
                                suffixIcon: InkWell(
                                    onTap: () {
                                      if (text.text == status.adivina) {
                                        print("gano");
                                        text.text = "";
                                      } else {
                                        print("sigue intentando");
                                        text.text = "";
                                      }
                                    },
                                    child: Icon(Icons.send))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Flexible(child: new StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return new Container(
              child: new Slider(
            value: _controller.thickness,
            onChanged: (double value) => setState(() {
              _controller.thickness = value;
            }),
            min: 1.0,
            max: 20.0,
            activeColor: Colors.white,
          ));
        })),
      ],
    );
  }
}
