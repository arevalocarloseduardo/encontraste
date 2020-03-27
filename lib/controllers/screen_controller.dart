import 'package:flutter/material.dart';
import 'package:encontraste/views/screens/login.dart';
import 'package:encontraste/views/screens/ver_screen.dart';
import 'package:encontraste/views/screens/juego_screen.dart';
import 'package:encontraste/controllers/auth_controller.dart';
import 'package:encontraste/views/screens/splash_screen.dart';
import 'package:encontraste/views/screens/principal_home_screen.dart';
import 'package:provider/provider.dart';

class ScreenController with ChangeNotifier {
  
   // AuthController.shared.statusUserChanged.listen(_onAuthStateChanged);
  
  static BuildContext context;

  static ScreenController get shared => Provider.of<ScreenController>(context);

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

  onAuthStateChanged(Status userStatus) {
    switch (userStatus) {
      case Status.Uninitialized:
       // pushScreen(SplashScreen());
        break;
      case Status.Unauthenticated:
       pushScreen(LoginScreen());
        break;
      case Status.Authenticating:
       pushScreen(SplashScreen());
        break;
      case Status.Authenticated:
        pushScreen(PrincipalHomeScreen());
        break;
      default:
        pushScreen(SplashScreen());
    }
  }

  pushScreen(screen) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => screen));
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

  goto({Widget screen, int delay = 0}) async {
    await Future.delayed(Duration(seconds: delay), () {
      // _screen = screen;
    });
    notifyListeners();
  }
}
