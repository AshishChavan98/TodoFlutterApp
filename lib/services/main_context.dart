
import 'package:flutter/cupertino.dart';

abstract class MainContext{
  static BuildContext mainContext;
  static Future<void> init(BuildContext context) async {
    if(mainContext!=null){
      mainContext=context;
    }
  }
}