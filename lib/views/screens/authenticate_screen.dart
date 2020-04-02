
import 'package:encontraste/controllers/auth_controller.dart';
import 'package:encontraste/controllers/global_controller.dart';
import 'package:encontraste/views/screens/login.dart'; 
import 'package:encontraste/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page/home_page.dart';
import 'onboard_team/onboard_welcome.dart';

class AuthenticateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthController authProvider = Provider.of<AuthController>(context);
      print("inicializo en context" );
    Widget body;
    switch (authProvider.status) {
      case Status.Authenticated:
        body = HomePage();
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
        body = OnboardWelcome(authProvider.user);
        break;
      default:
        body = SplashScreen();
    }
    return Scaffold(
      body: body,
    );
  }
}
