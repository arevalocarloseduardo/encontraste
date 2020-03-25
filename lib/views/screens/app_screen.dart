import 'package:encontraste/controllers/screen_controller.dart';
import 'package:encontraste/services/base_auth.dart';
import 'package:encontraste/views/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  BaseAuth auth;
  @override
  void initState() {
    super.initState();
    auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenController = Provider.of<ScreenController>(context);
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
       // return LoginScreen();
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return view(context, screenController);
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}

Scaffold view(BuildContext context, ScreenController screenController) {
  return (MediaQuery.of(context).orientation == Orientation.portrait
      ? portrait(screenController)
      : Scaffold(
          body: screenController.screen,
        ));
}

Scaffold portrait(ScreenController screenController) {
  return Scaffold(
    bottomNavigationBar: screenController.botomBarPrincipal
        ? BottomNavigationBar(
            currentIndex: screenController
                .currentIndexBottom, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.tv),
                title: new Text('ver'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.games), title: Text('juego'))
            ],
            onTap: (val) {
              screenController.currentIndexBottom = val;
            },
          )
        : null,
    body: screenController.screen,
  );
}
