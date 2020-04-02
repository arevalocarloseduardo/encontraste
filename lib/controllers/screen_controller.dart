 import 'package:encontraste/views/screens/home_page/game_page/select_salas.dart';
import 'package:encontraste/views/screens/home_page/home_screen.dart';
import 'package:encontraste/views/screens/home_page/perfil_page/perfil_screen.dart';
import 'package:flutter/material.dart';
import 'package:encontraste/views/screens/ver_screen.dart';
import 'package:provider/provider.dart';

class ScreenController with ChangeNotifier {
  static BuildContext context;

  static ScreenController get shared => Provider.of<ScreenController>(context);

  Widget _screen;
  Widget get screen => _screen;

  set screen(Widget value) {
    _screen = value;
    notifyListeners();
  }

  bool _botomBarPrincipal = true;
  bool get botomBarPrincipal => _botomBarPrincipal;
  set botomBarPrincipal(bool value) {
    _botomBarPrincipal = value;
    notifyListeners();
  }

  bool _appBar = true;
  bool get appBar => _appBar;
  set appBar(bool value) {
    _appBar = value;
    notifyListeners();
  }

  int _currentIndexBottom = 0;
  int get currentIndexBottom => _currentIndexBottom;
  set currentIndexBottom(int value) {
    _currentIndexBottom = value;
    switchScreen(value);
    notifyListeners();
  }

  pushScreen(screen) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => screen));
  }

  void switchScreen(int value) {
    switch (value) {
      case 0:
        screen = HomeScreen();
        break;
      case 1:
        screen = SelectSala();
        break;
      case 2:
        screen = PerfilScreen();
        break;
      default:
    }
  }
}
