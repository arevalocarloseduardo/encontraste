library painter;

import 'dart:convert';

import 'package:encontraste/controllers/rtm_controller.dart';
import 'package:encontraste/models/game_pictonary.dart';
import 'package:encontraste/models/status_gamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'dart:ui';
import 'dart:async';
import 'dart:typed_data';

import 'package:provider/provider.dart';

class Painter extends StatefulWidget {
  final PainterController painterController;
  final bool draw;
  final List<Map<String, double>> map;
  final StatusGamer status;
  Painter({this.painterController, this.draw = true, this.map, this.status})
      : super(key: new ValueKey<PainterController>(painterController));

  @override
  _PainterState createState() => new _PainterState();
}

class _PainterState extends State<Painter> {
  bool _finished;
  List<Map<String, dynamic>> listDataPos = [];
  RtmController rtm;
  int limit = 300;
  int posIndex = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    rtm = Provider.of<RtmController>(context);
    rtm.streamMensajes.stream.listen(receiveData);
  }

  @override
  void initState() {
    super.initState();
    _finished = false;
    widget.painterController._widgetFinish = _finish;
  }

  Size _finish() {
    setState(() {
      _finished = true;
    });
    return context.size;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = new CustomPaint(
      willChange: true,
      painter: new _PainterPainter(widget.painterController._pathHistory,
          repaint: widget.painterController),
    );
    child = new ClipRect(child: child);
    if (!_finished && widget.draw) {
      child = new GestureDetector(
        onTap: () {},
        child: child,
        onPanStart: _onPanStart,
        onPanUpdate: posIndex <= limit ? _onPanUpdate : null,
        onPanEnd: _onPanEnd,
      );
    }
    return Stack(
      children: <Widget>[
        
        Container(
          child: child,
          width: double.infinity,
          height: double.infinity,
        ),Container(
          height: 5,
          width:  posIndex*MediaQuery.of(context).size.width/limit,
          color: Colors.red,
        ),
      ],
    );
  }

  onMsg(GamePictonary gameData) {
    var data = gameData.dataGamePictonary;
    //List<Map<String, double>> data;
    var first = data.first;
    var offs = Offset(first.dx, first.dy);
    widget.painterController._pathHistory.add(offs);
    widget.painterController._notifyListeners();

    data.forEach((f) {
      var pos = Offset(f.dx, f.dy);
      widget.painterController._pathHistory.updateCurrent(pos);
      widget.painterController._notifyListeners();
    });
    widget.painterController._pathHistory.endCurrent();
    widget.painterController._notifyListeners();
  }

  void _onPanStart(DragStartDetails start) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(start.globalPosition);
    var posSend = Offset(pos.dx, pos.dy);
    widget.painterController._pathHistory.add(pos);

    widget.painterController._notifyListeners();
    var map = {
      '"dx"': posSend.dx.toStringAsFixed(2),
      '"dy"': posSend.dy.toStringAsFixed(2)
    };

    listDataPos.clear();
    listDataPos.add(map);
    setState(() {
      posIndex = 0;
    });
  }

  void _onPanUpdate(DragUpdateDetails update) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);
    var posSend = Offset(pos.dx, pos.dy);
    widget.painterController._pathHistory.updateCurrent(pos);
    widget.painterController._notifyListeners();
    var map = {
      '"dx"': posSend.dx.toStringAsFixed(2),
      '"dy"': posSend.dy.toStringAsFixed(2)
    };
    listDataPos.add(map);
    setState(() {
      posIndex++;
    });
  }

  void _onPanEnd(DragEndDetails end) {
    widget.painterController._pathHistory.endCurrent();
    widget.painterController._notifyListeners();

    rtm.enviarMensajeGrupal('"dataGamePictonary":' + listDataPos.toString());
    setState(() {
      posIndex = 0;
    });
    listDataPos.clear();
  }

  Future<void> receiveData(String data) async {
    JsonCodec codec = new JsonCodec();
    var parsedJson = codec.decode("""$data""");
    var game = GamePictonary.fromMap(parsedJson);
    onMsg(game);
  }
}

class _PainterPainter extends CustomPainter {
  final _PathHistory _path;

  _PainterPainter(this._path, {Listenable repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_PainterPainter oldDelegate) {
    return true;
  }
}

class _PathHistory {
  List<MapEntry<Path, Paint>> _paths;
  Paint currentPaint;
  Paint _backgroundPaint;
  bool _inDrag;

  Offset assd;

  List<Offset> lisOfs = List<Offset>();

  int suma = 0;

  Map newMap = {};

  _PathHistory() {
    _paths = new List<MapEntry<Path, Paint>>();
    _inDrag = false;
    _backgroundPaint = new Paint();
  }

  void setBackgroundColor(Color backgroundColor) {
    _backgroundPaint.color = backgroundColor;
  }

  void undo() {
    print(newMap.length);
    print(newMap.toString());
    if (!_inDrag) {
      _paths.removeLast();
    }
  }

  void clear() {
    if (!_inDrag) {
      _paths.clear();
    }
  }

  void imprimir(Map map) {}

  void add(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;
      Path path = new Path();
      path.moveTo(startPoint.dx, startPoint.dy);

      _paths.add(new MapEntry<Path, Paint>(path, currentPaint));
    }
  }

  void updateCurrent(Offset nextPoint) {
    suma++;

    newMap[suma] = {
      "dx": "${nextPoint.dx.toStringAsFixed(2)}",
      "dy": "${nextPoint.dx.toStringAsFixed(2)}"
    };

    lisOfs.add(nextPoint);
    if (_inDrag) {
      Path path = _paths.last.key;
      path.lineTo(nextPoint.dx, nextPoint.dy);
    }
  }

  void endCurrent() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    canvas.drawRect(
        new Rect.fromLTWH(0.0, 0.0, size.width, size.height), _backgroundPaint);
    for (MapEntry<Path, Paint> path in _paths) {
      canvas.drawPath(path.key, path.value);
    }
  }
}

typedef PictureDetails PictureCallback();

class PictureDetails {
  final Picture picture;
  final int width;
  final int height;

  const PictureDetails(this.picture, this.width, this.height);
}

class PainterController extends ChangeNotifier {
  Color _drawColor = new Color.fromARGB(255, 0, 0, 0);
  Color _backgroundColor = new Color.fromARGB(255, 255, 255, 255);

  double _thickness = 1.0;
  PictureDetails _cached;
  _PathHistory _pathHistory;
  ValueGetter<Size> _widgetFinish;

  PainterController() {
    _pathHistory = new _PathHistory();
  }

  Color get drawColor => _drawColor;
  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color color) {
    _backgroundColor = color;
    _updatePaint();
  }

  double get thickness => _thickness;
  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  void _updatePaint() {
    Paint paint = new Paint();
    paint.color = drawColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = thickness;
    _pathHistory.currentPaint = paint;
    _pathHistory.setBackgroundColor(backgroundColor);
    notifyListeners();
  }

  void undo() {
    if (!isFinished()) {
      _pathHistory.undo();
      notifyListeners();
    }
  }

  void _notifyListeners() {
    notifyListeners();
  }

  void clear() {
    if (!isFinished()) {
      _pathHistory.clear();
      notifyListeners();
    }
  }

  PictureDetails finish() {
    if (!isFinished()) {
      _cached = _render(_widgetFinish());
    }
    return _cached;
  }

  PictureDetails _render(Size size) {
    PictureRecorder recorder = new PictureRecorder();
    Canvas canvas = new Canvas(recorder);
    _pathHistory.draw(canvas, size);
    return new PictureDetails(
        recorder.endRecording(), size.width.floor(), size.height.floor());
  }

  bool isFinished() {
    return _cached != null;
  }
}
