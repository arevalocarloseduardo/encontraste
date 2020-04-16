import 'package:encontraste/views/screens/authenticate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/global_controller.dart';
import 'controllers/juego_controller.dart';
import 'controllers/rtm_controller.dart';
import 'controllers/screen_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/screens/home_page/game_page/game_controller.dart';
import 'views/screens/home_page/game_page/juno/juno_controller.dart';
import 'views/screens/home_page/home_controller.dart';
import 'views/screens/onboard_team/onboard_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Encontraste());
  });
}

class Encontraste extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RtmController()),
          ChangeNotifierProvider(create: (_) => OnboardController()),
          ChangeNotifierProvider(create: (_) => GlobalController()),
          ChangeNotifierProvider(create: (_) => ScreenController()),
          ChangeNotifierProvider(create: (_) => JuegoController()),
          ChangeNotifierProvider(create: (_) => HomeController()),
          ChangeNotifierProvider(create: (_) => AuthController()),
          ChangeNotifierProvider(create: (_) => GameController()),
          ChangeNotifierProvider(create: (_) => JunoController()),
          
        ],
        child: MaterialApp(
          builder: (context, child) {
            AuthController.context = context;
            ScreenController.context = context;
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
          home: AuthenticateScreen(),
        ));
  }
}
