import 'package:encontraste/controllers/auth_controller.dart';
import 'package:encontraste/controllers/global_controller.dart';
import 'package:encontraste/controllers/screen_controller.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/services/database_service.dart';
import 'package:encontraste/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = DatabaseService();

  HomeController principalHomeController;
  ScreenController stateScreen;
  AuthController authUser;
  double height;
  double width;
  List<Persona> personas;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    principalHomeController = Provider.of<HomeController>(context);
    stateScreen = Provider.of<ScreenController>(context);
    authUser = Provider.of<AuthController>(context);

    GlobalController state = Provider.of<GlobalController>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: stateScreen.currentIndexBottom,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.tv),
            title: new Text('Salas'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Perfil'),
          )
        ],
        onTap: (val) {
          stateScreen.currentIndexBottom = val;
        },
      ),
      appBar: AppBar(
        backgroundColor: BereaColors.purple,
        title: GestureDetector(
          onTap: () {
            authUser.signOut();
          },
          child: Container(
            child: Image.asset(
              "assets/logoen.png",
            ),
            height: width * 0.2,
            width: width,
          ),
        ),
      ),
      body: stateScreen.screen,
    );
  }
}
