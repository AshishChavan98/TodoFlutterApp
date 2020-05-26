import 'package:firebaseapp/pages/wrapper.dart';
import 'package:firebaseapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

import 'package:android_alarm_manager/android_alarm_manager.dart';


void main() async{
  runApp(MyApp());
  await AndroidAlarmManager.initialize();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value:AuthService().user,
      child: MaterialApp(
        home:Wrapper()
      ),
    );
  }
}
