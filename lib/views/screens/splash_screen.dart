import 'package:encontraste/controllers/screen_controller.dart';
import 'package:encontraste/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  ScreenController screenController;
    screenController = Provider.of<ScreenController>(context);
    screenController.nextScreen();
    return Scaffold(
      backgroundColor: BereaColors.purple,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Image.asset("assets/logoen.png"),
              height: 200,
              width: 200,
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
