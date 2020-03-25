import 'package:encontraste/controllers/auth_controller.dart';
import 'package:encontraste/controllers/screen_controller.dart';
import 'package:encontraste/views/screens/login.dart';
import 'package:encontraste/views/screens/principal_home_screen.dart';
import 'package:encontraste/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  
  @override
  void initState() {
    super.initState();
    setState(){
      
    }
  }

  @override
  Widget build(BuildContext context) {
     ScreenController screenController= Provider.of<ScreenController>(context);
    return screenController.screen;
  }
}
