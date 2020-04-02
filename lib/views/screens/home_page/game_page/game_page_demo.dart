import 'package:agora_rtm/agora_rtm.dart';
import 'package:encontraste/controllers/rtm_controller.dart';
import 'package:encontraste/models/sala.dart';
import 'package:encontraste/utils/settings.dart';
import 'package:encontraste/views/widgets/draw_widget.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class GamePageDemo extends StatefulWidget {
  GamePageDemo({this.sala});
  final Sala sala;

  @override
  _GamePageDemoState createState() => _GamePageDemoState();
}

class _GamePageDemoState extends State<GamePageDemo> {
 
  bool _finished;

  PainterController _controller;

  RtmController rtm;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    rtm = Provider.of<RtmController>(context);
  }
 @override
  void dispose() {
    super.dispose();
    rtm.salirSala(widget.sala);
  }
@override
  void initState() {
    super.initState();
    _finished=false;
    _controller=_newController();
  }
  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.white;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: <Widget>[
          Center(
              child: new AspectRatio(
                  aspectRatio: 1.0,
                  child: new Painter(painterController: _controller))),
          Center(
              child: new AspectRatio(
                  aspectRatio: 1.0,
                  child: new Painter(
                      painterController: _controller,
                      draw: true,
                      map: [
                        {"dx": 124.36, "dy": 124.36},
                        {"dx": 126.18, "dy": 126.18},
                        {"dx": 129.82, "dy": 129.82},
                        {"dx": 132.36, "dy": 132.36},
                        {"dx": 138.18, "dy": 138.18},
                        {"dx": 140.36, "dy": 140.36},
                        {"dx": 143.27, "dy": 143.27},
                        {"dx": 145.09, "dy": 145.09},
                        {"dx": 145.82, "dy": 145.82},
                        {"dx": 147.64, "dy": 147.64},
                        {"dx": 148.73, "dy": 148.73},
                        {"dx": 149.45, "dy": 149.45},
                        {"dx": 149.45, "dy": 149.45},
                        {"dx": 149.45, "dy": 149.45},
                        {"dx": 149.45, "dy": 149.45},
                        {"dx": 149.82, "dy": 149.82},
                        {"dx": 150.55, "dy": 150.55}
                      ]))),
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
 
