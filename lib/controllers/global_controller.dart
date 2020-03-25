import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalController with ChangeNotifier{
  static BuildContext context;

  static GlobalController get shared => Provider.of<GlobalController>(context);
 
}