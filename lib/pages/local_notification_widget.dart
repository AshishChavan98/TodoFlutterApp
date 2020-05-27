import 'dart:isolate';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firebaseapp/models/user.dart';
import 'package:firebaseapp/pages/home.dart';
import 'package:firebaseapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebaseapp/pages/notification/local_notification_helper.dart';
import 'package:provider/provider.dart';

import 'notification/notifications.dart';


printHello() async{
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print('In printHell0');



  try{
    await showNotification();

  }catch(e){
    print(e.toString());
  }

  print("[$now] Hello, world! isolate=$isolateId function='$printHello'");
}







class LocalNotificationWidget extends StatefulWidget {
  @override
  _LocalNotificationWidgetState createState() => _LocalNotificationWidgetState();
}

class _LocalNotificationWidgetState extends State<LocalNotificationWidget> {
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);

  }

  Future onSelectNotification(String payload) async => await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Home()),
  );

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Basics',textAlign: TextAlign.center,),
          RaisedButton(
            child:Text('Show notification'),
            onPressed: () async{
              print('on Pressed');

              var time = DateTime.now().toLocal();
              time = new DateTime(time.year, time.month, time.day, time.hour, time.minute+2, time.second, time.millisecond, time.microsecond);
              print(time);

              await AndroidAlarmManager.periodic(const Duration(hours: 1), 0, printHello,exact: true,wakeup: true,startAt: time);

              print('on Pressed finished');
            }
          ),
          RaisedButton(
            child: Text('Cancel Notification'),
            onPressed: () async{
              print('In cancle');
              await AndroidAlarmManager.cancel(0);
              print('canceled');
            },
          ),
          RaisedButton(
            onPressed: (){
              var newHour = 5;
              var time = DateTime.now().toLocal();
              time = new DateTime(time.year, time.month, time.day, time.hour, time.minute+1, time.second, time.millisecond, time.microsecond);
              print(time);

              },
            child: Text('Fetch length of Todos'),
          )

        ],
      ),
    );
  }
}
