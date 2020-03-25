import 'package:encontraste/controllers/auth_controller.dart';
import 'package:encontraste/views/screens/juego_screen.dart';
import 'package:encontraste/views/screens/login.dart';
import 'package:encontraste/views/screens/principal_home_screen.dart';
import 'package:encontraste/views/screens/splash_screen.dart';
import 'package:encontraste/views/screens/ver_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenController with ChangeNotifier {
  ScreenController() {
    AuthController.shared.statusUserChanged.listen(_onAuthStateChanged);
  }
  Widget _screen = SplashScreen();

  Widget get screen => _screen;
  set screen(Widget value) {
    _screen = value;
    notifyListeners();
  }

  _onAuthStateChanged(Status userStatus) {
    switch (userStatus) {
      case Status.Uninitialized:
        screen = SplashScreen();
        break;
      case Status.Unauthenticated:
        screen = LoginScreen();
        break;
      case Status.Authenticating:
        screen = LoginScreen();
        break;
      case Status.Authenticated:
        screen = PrincipalHomeScreen();
        break;
      default:
        screen = SplashScreen();
    }
  }

  bool _botomBarPrincipal = false;
  bool get botomBarPrincipal => _botomBarPrincipal;

  void setBotomBarPrincipal(bool value) {
    _botomBarPrincipal = value;

    notifyListeners();
  }

  int _currentIndexBottom = 0;
  int get currentIndexBottom => _currentIndexBottom;
  set currentIndexBottom(int value) {
    _currentIndexBottom = value;
    switchScreen(value);
    notifyListeners();
  }

  void nextScreen() {
    _botomBarPrincipal = false;
    goto(screen: PrincipalHomeScreen(), delay: 2);
    _botomBarPrincipal = true;
  }

  goto({Widget screen, int delay = 0}) async {
    await Future.delayed(Duration(seconds: delay), () {
      _screen = screen;
    });
    notifyListeners();
  }

  void switchScreen(int value) {
    switch (value) {
      case 0:
        goto(screen: PrincipalHomeScreen());
        break;
      case 1:
        goto(screen: VerScreen());
        break;
      case 2:
        goto(screen: JuegoScreen());
        break;
      default:
    }
  }
}
