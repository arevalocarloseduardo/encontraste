import 'package:flutter/material.dart';

enum Valor {
  cero,
  uno,
  dos,
  tres,
  cuatro,
  cinco,
  seis,
  siete,
  ocho,
  nueve,
  pierdeTurno,
  cambiaSentido,
  cambiaColor,
  mas2,
  mas4
}

class JunoController with ChangeNotifier {
  List<Carta> maso = [];
  int indexTurno = 0;
  bool sentidoHorario = true;
  int tiempoXJugador = 10;
  int tiempoXRonda = 200;

  List<Jugador> _listJugador = [];
  List<Jugador> get listJugador => _listJugador;
  set listJugador(value) {
    _listJugador = value;
    notifyListeners();
  }

  List<Carta> _masoEnMesa = [];
  List<Carta> get masoEnMesa => _masoEnMesa;
  set masoEnMesa(value) {
    _masoEnMesa = value;
    notifyListeners();
  }

  void iniciarJuego() {
    var maso = crearMaso();
    masoEnMesa = mesclarCartas(maso);
    List<Jugador> listJugadorTemp = [];
    listJugadorTemp.add(Jugador(nombre: "carlos1", misCartas: []));
    listJugadorTemp.add(Jugador(nombre: "carlos2", misCartas: []));
    listJugadorTemp.add(Jugador(nombre: "carlos3", misCartas: []));
    rapartirCartas(masoEnMesa, listJugadorTemp);
  }

  void rapartirCartas(List<Carta> maso, List<Jugador> listJugadorTemp) {
    print("tengo ${masoEnMesa.length} en el maso");
    List<Carta> masoTemp = [];
    int jugador = 0;
    int cartasRepartidasXPersona = 0;
    maso.map((carta) {
      if (listJugadorTemp.last.misCartas.length == 7) {
        masoTemp.add(carta);
      } else {
        listJugadorTemp[jugador].misCartas.add(carta);
        print("agrego ${carta.valor} a ${listJugadorTemp[jugador].nombre}");
        if (jugador == listJugadorTemp.length - 1) {
          jugador = 0;
        } else {
          jugador++;
        }
      }
    }).toList();
    listJugador = listJugadorTemp;
    masoEnMesa = masoTemp;
    print("me quedan ${masoEnMesa.length} en el maso");
    print("cada Jugador tiene ${listJugadorTemp.last.misCartas.length} cartas");
  }

  List<Carta> crearMaso() {
    List<Carta> masoTemp = [];
    const List<Color> colores = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green
    ];

    Valor.values.forEach((valor) {
      colores.forEach((color) {
        masoTemp.add(Carta.createCartas(Carta(valor: valor, color: color)));
      });
    });
    print("cree maso: ${masoTemp.length}");
    return masoTemp;
  }

  List<Carta> mesclarCartas(List<Carta> cartas) {
    cartas.shuffle();
    print("aca Mescle");
    return cartas;
  }
}

class Carta {
  String id;
  Color color;
  Valor valor;
  bool isEspecial;
  Carta({this.id, this.color, this.valor, this.isEspecial});

  factory Carta.createCartas(Carta carta) {
    Color myColor = carta.color;
    bool especial = false;
    switch (carta.valor) {
      case Valor.cambiaColor:
        myColor = Colors.black;
        especial = true;
        break;
      case Valor.mas4:
        myColor = Colors.black;
        especial = true;
        break;
      case Valor.cambiaSentido:
        especial = true;
        break;
      case Valor.mas2:
        especial = true;
        break;
      case Valor.pierdeTurno:
        especial = true;
        break;
      default:
    }
    return Carta(
        id: carta.id, isEspecial: especial, color: myColor, valor: carta.valor);
  }
}

class Jugador {
  String id;
  String nombre;
  List<Carta> misCartas;

  Jugador({this.nombre, this.misCartas});
  String decirJuno() {
    print("Dije uno");
    return "uno";
  }

  Carta tirarCarta(int index) {
    misCartas.removeAt(index);
    print("tire esta carta: ${misCartas[index]}");
    return misCartas[index];
  }

  void recibirCartas(List<Carta> cartas) {
    cartas.forEach((carta) {
      print("recibi estas carta: $cartas");
    });
    misCartas.addAll(cartas);
  }

  void reiniciar() {
    misCartas.clear();
  }
}
