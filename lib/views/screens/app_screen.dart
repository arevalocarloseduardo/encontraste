import 'package:encontraste/controllers/screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenController = Provider.of<ScreenController>(context);
    return MediaQuery.of(context).orientation == Orientation.portrait?Scaffold(
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
    ):Scaffold(
      body: screenController.screen,
    );
  }
}


