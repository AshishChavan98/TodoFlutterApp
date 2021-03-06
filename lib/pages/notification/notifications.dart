
import 'package:firebaseapp/models/mini_todo.dart';
import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/services/offline_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseapp/models/todo.dart';
import 'package:sqflite/sqflite.dart';

Future showNotification(int id) async{

  final CollectionReference appCollection = Firestore.instance.collection('app');



  int length;
  print('App collection $appCollection');
  String uid='ya44yCBzjqWhIuHdyw9ZfgFiXPC2';
  await appCollection.document(uid).collection('todo').getDocuments().then((doc){
    length=doc.documents.length;
    print(length);
  });


  print(length);

  FlutterLocalNotificationsPlugin notifications=FlutterLocalNotificationsPlugin();

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      );
//  importance: Importance.Low, priority: Priority.Low, ticker: 'ticker'
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await notifications.show(
      id, length.toString(), 'Tasks remaining today', platformChannelSpecifics,
      payload: 'item x');

}

Future showNotificationTodo(int id) async{
  String table='todo_notification';

  print("showNotificationTodo id :"+id.toString());
  String _path = await getDatabasesPath() + 'notificationDB';
  Database _db = await openDatabase(_path, version: 1,);
  List<Map<String, dynamic>> result = await _db.query(table);
  List _tasks = result.map((item)=>MiniTodo.fromMap(item)).toList();
//  print(_tasks);
//  print(_tasks);
  String title='null';
  for(MiniTodo mini in _tasks){
     if(mini.id==id){
       title=mini.title;
     }
   }


  FlutterLocalNotificationsPlugin notifications=FlutterLocalNotificationsPlugin();

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '2', 'Todo Notification', 'Todo reminders notifications',
      );
//  importance: Importance.Low, priority: Priority.Low, ticker: 'ticker'
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await notifications.show(
      id, title, 'Tap to review task', platformChannelSpecifics,
      payload: 'item x');

}


scheduledNotification(FlutterLocalNotificationsPlugin notifications){
  var scheduledNotificationDateTime =
  DateTime.now().add(Duration(seconds: 5));
  var androidPlatformChannelSpecifics =
  AndroidNotificationDetails('your other channel id',
      'your other channel name', 'your other channel description');
  var iOSPlatformChannelSpecifics =
  IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  notifications.schedule(
      0,
      'scheduled title',
      'scheduled body',
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}

periodicNotification(FlutterLocalNotificationsPlugin notifications){
  var androidPlatformChannelSpecifics =
  AndroidNotificationDetails('repeating channel id',
      'repeating channel name', 'repeating description');
  var iOSPlatformChannelSpecifics =
  IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  notifications.periodicallyShow(0, dynamicTitle(),
      'repeating body', RepeatInterval.EveryMinute, platformChannelSpecifics);
}

dailyNotification(FlutterLocalNotificationsPlugin notifications){
  var time = Time(14, 15, 0);
  var androidPlatformChannelSpecifics =
  AndroidNotificationDetails('repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
  var iOSPlatformChannelSpecifics =
  IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  notifications.showDailyAtTime(
      0,
      'show daily title',
      'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
      time,
      platformChannelSpecifics);
}

_toTwoDigitString(int x){
  var time = Time(14,15,0);
  print(time.hour);
  print(time.minute);
  print(time.second);
}
toTwoDigitString(int x){
  var time = Time(14,15,0);
  print(time.hour.toString());
  print(time.minute);
  print(time.second);
}

String dynamicTitle(){
  return DateTime.now().toString();
}