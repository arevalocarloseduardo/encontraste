import 'dart:math';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'juno_controller.dart';

class JunoPage extends StatefulWidget {
  @override
  _JunoPageState createState() => _JunoPageState();
}

class _JunoPageState extends State<JunoPage> {
  double x = 0;
  double y = 0;
  double z = 0;

  @override
  Widget build(BuildContext context) {
    var juno = Provider.of<JunoController>(context);
    var myCards = [];

    List<Widget> cardList = new List();

    var suma = 0;
    void removeCards(index) {
      setState(() {
        cardList.removeAt(index);
      });
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                juno.iniciarJuego();
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.009)
                ..rotateX(-0.65)
                ..rotateZ(-0.0),
              alignment: FractionalOffset.center,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    y = y - details.delta.dx / 100;
                    x = x + details.delta.dy / 100;
                  });
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        child: Image.network(
                          "https://www.wood4floors.co.uk/wp-content/uploads/2019/05/Avatara-Oak-Banta-Light-Brown-Plank-Man-Made-Wood-Floor-2.jpg",
                          fit: BoxFit.cover,
                        ),
                        height: 230.0,
                        width: 210.0,
                      ),
                    ),
                    Stack(
                        children: juno.masoEnMesa
                            .map((carta) => CartaJuno(carta: carta))
                            .toList())
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 550,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              child: Swiper(
                  layout: SwiperLayout.CUSTOM,
                  customLayoutOption:
                      new CustomLayoutOption(startIndex: -1, stateCount: 11)
                          .addRotate([
                    -0.5,
                    -0.4,
                    -0.3,
                    -0.2,
                    -0.1,
                    0.0,
                    0.1,
                    0.2,
                    0.3,
                    0.4,
                    0.5
                  ]).addTranslate([
                    new Offset(-120.0, -30.0),
                    new Offset(-100.0, -30.0),
                    new Offset(-80, -30.0),
                    new Offset(-60.0, -30.0),
                    new Offset(-40.0, -30.0),
                    new Offset(0.0, -80.0),
                    new Offset(40.0, -30.0),
                    new Offset(60, -30.0),
                    new Offset(80.0, -30.0),
                    new Offset(100.0, -30.0),
                    new Offset(120.0, -30.0),
                  ]),
                  loop: false,
                  itemWidth: 80.0,
                  itemHeight: 120.0,
                  itemBuilder: (context, index) {
                    return new Container(
                      color: juno.masoEnMesa[index].color,
                      child: new Center(
                        child: new Text("$index"),
                      ),
                    );
                  },
                  itemCount: 11),
            ),
          )
        ],
      ),
    );
  }
}

class CartaJuno extends StatelessWidget {
  const CartaJuno({Key key, this.carta}) : super(key: key);
  final Carta carta;
  Widget text(String s, Color color) {
    return Text(
      s,
      style: TextStyle(
          color: color ?? Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var rng = new Random();
    var number = rng.nextInt(9);
    var gira = rng.nextInt(10);
    var value;
    text("", Colors.red);
    switch (carta.valor) {
      case Valor.cero:
        value = text("0", carta.color);
        break;
      case Valor.uno:
        value = text("1", carta.color);
        break;
      case Valor.dos:
        value = text("2", carta.color);
        break;
      case Valor.tres:
        value = text("3", carta.color);
        break;
      case Valor.cuatro:
        value = text("4", carta.color);
        break;
      case Valor.cinco:
        value = text("5", carta.color);
        break;
      case Valor.seis:
        value = text("6", carta.color);
        break;
      case Valor.siete:
        value = text("7", carta.color);
        break;
      case Valor.ocho:
        value = text("8", carta.color);
        break;
      case Valor.nueve:
        value = text("9", carta.color);
        break;
      case Valor.cambiaColor:
        value = text("color", carta.color);
        break;
      case Valor.cambiaSentido:
        value = text("sentido", carta.color);
        break;
      case Valor.pierdeTurno:
        value = text("salta", carta.color);
        break;
      case Valor.mas2:
        value = text("+2", carta.color);
        break;
      case Valor.mas4:
        value = text("+4", carta.color);
        break;
      default:
        value = text("12", Colors.black);
    }
    return Positioned(
      top: size.height * (0.45 - (number / 1000)) - 40,
      left: size.width * .5 - 30,
      child: Transform.rotate(
        angle: -math.pi / -25 - (gira / 10),
        child: Container(
          height: 75,
          width: 60,
          // margin: EdgeInsets.all(10),
          // padding: EdgeInsets.all(3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: carta.color ?? Colors.red, //color carta
            border: Border.all(color: Colors.white, width: 2.5),
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
            /* boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: Colors.black,
                    offset: Offset(-0.1, 0.2))
              ] // make rounded corner of border
              */
          ),
          child: Stack(children: <Widget>[
            Transform.rotate(
              angle: -math.pi / -8.0,
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: value,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CardJuno extends StatelessWidget {
  const CardJuno({
    Key key,
    @required this.carta,
    this.heigth,
    this.width,
  }) : super(key: key);
  final Carta carta;
  final double heigth;
  final double width;

  Widget text(String s, Color color) {
    return Text(
      s,
      style: TextStyle(color: Colors.black, fontSize: 24),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    var value;
    text("", Colors.red);
    switch (carta.valor) {
      case Valor.cero:
        value = text("0", carta.color);
        break;
      case Valor.uno:
        value = text("1", carta.color);
        break;
      case Valor.dos:
        value = text("2", carta.color);
        break;
      case Valor.tres:
        value = text("3", carta.color);
        break;
      case Valor.cuatro:
        value = text("4", carta.color);
        break;
      case Valor.cinco:
        value = text("5", carta.color);
        break;
      case Valor.seis:
        value = text("6", carta.color);
        break;
      case Valor.siete:
        value = text("7", carta.color);
        break;
      case Valor.ocho:
        value = text("8", carta.color);
        break;
      case Valor.nueve:
        value = text("9", carta.color);
        break;
      case Valor.cambiaColor:
        value = text("color", carta.color);
        break;
      case Valor.cambiaSentido:
        value = text("sentido", carta.color);
        break;
      case Valor.pierdeTurno:
        value = text("salta", carta.color);
        break;
      case Valor.mas2:
        value = text("+2", carta.color);
        break;
      case Valor.mas4:
        value = text("+4", carta.color);
        break;
      default:
        value = text("12", Colors.black);
    }
    return Card(
      color: carta.color,
      child: Container(
        height: heigth ?? 120,
        width: width ?? 80,
        child: Stack(children: <Widget>[
          Center(
            child: Transform.rotate(
              angle: -math.pi / -12.0,
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  height: 110.0,
                  width: 70.0,
                  child: Center(
                    child: value,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
