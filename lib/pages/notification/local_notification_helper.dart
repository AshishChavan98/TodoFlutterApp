import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications,{
      @required String title,
      @required String body,
      @required NotificationDetails type,
      int id=0,
  }
)=> notifications.show(id, title, body, type);

NotificationDetails get _ongoing{
  final androidChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'channel name',
      'channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: false,
      autoCancel: false,
  );

  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics,iOSChannelSpecifics);
}

Future showOnGoingNotification(
    FlutterLocalNotificationsPlugin notifications,{
      @required String title,
      @required String body,
      int id=0,
    }
)=> _showNotification(notifications, title: title, body: body, type: _ongoing);