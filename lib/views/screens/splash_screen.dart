import 'package:encontraste/utils/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BereaColors.purple,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                height: 200,
                child: Image(
                  image: AssetImage('assets/logoen.png'),
                  semanticLabel: 'App Name logo',
                ))
            //CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
