import 'dart:async';

import 'package:encontraste/controllers/auth_controller.dart';
import 'package:encontraste/views/screens/login.dart';
import 'package:encontraste/views/screens/principal_home_screen.dart';
import 'package:encontraste/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthController authProvider = Provider.of<AuthController>(context);
    
    Widget body;
    switch (authProvider.status) {
      case Status.Authenticated:
        body = PrincipalHomeScreen();
        break;
      case Status.Unauthenticated:
        body = LoginScreen();
        break;
      case Status.Authenticating:
        body = SplashScreen();
        break;
      case Status.Uninitialized:
        body = SplashScreen();
        break;
      case Status.AuthenticatedWithoutDate:
        body = Scaffold(body: Text("hola"),);
        break;
      default:
        body = SplashScreen();
    }

    return Scaffold(
      body: body,
    );
  }
}
