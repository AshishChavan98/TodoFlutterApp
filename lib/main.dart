import 'package:firebaseapp/pages/custom_colors/custom_color.dart';
import 'package:firebaseapp/pages/local_notification_widget.dart';
import 'package:firebaseapp/pages/wrapper.dart';
import 'package:firebaseapp/services/auth.dart';
import 'package:firebaseapp/services/main_context.dart';
import 'package:firebaseapp/services/offline_database.dart';
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
//    final LocalNotificationHelper localNotificationHelper  =LocalNotificationHelper(context);
    MainContext.init(context);
    LocalNotificationHelper.init(context);
    return StreamProvider<User>.value(
      value:AuthService().user,
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'CircularStd',accentColor: CustomColor.AccentColor),
//        home:Provider<LocalNotificationHelper>(
//            create: (context) => LocalNotificationHelper(context),
//            child: Wrapper())
      home:Wrapper()
      ),
    );
  }
}
