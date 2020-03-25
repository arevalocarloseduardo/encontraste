import 'package:encontraste/utils/locator.dart';
import 'package:encontraste/views/screens/app_screen.dart';
import 'package:encontraste/views/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/global_controller.dart';
import 'controllers/juego_controller.dart';
import 'controllers/principal_home_controller.dart';
import 'controllers/screen_controller.dart';
import 'utils/crud.dart';
import 'views/screens/principal_home_screen.dart';
import 'views/screens/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(Encontraste());

class Encontraste extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ScreenController()),
          ChangeNotifierProvider(create: (_) => PrincipalHomeController()),
          ChangeNotifierProvider(create: (_) => JuegoController()),
          ChangeNotifierProvider(create: (_) => AuthController.instance()),
          ChangeNotifierProvider(create: (_) => GlobalController()),
        ],
        child: MaterialApp(
          builder: (context, child) {
            AuthController.context = context;
            GlobalController.context = context;
            return MediaQuery(
              child: child,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('es', 'ES'),
          ],
          debugShowCheckedModeBanner: false,
          title: 'En Contraste',
          home: HomePage(),
        ));
  }
}
