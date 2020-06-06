import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/models/user.dart';
import 'package:firebaseapp/pages/add_todo_form.dart';
import 'package:firebaseapp/pages/drawer/main_drawer.dart';
import 'package:firebaseapp/pages/local_notification_widget.dart';
import 'package:firebaseapp/pages/notification/notifications.dart';
import 'package:firebaseapp/pages/todo_list.dart';
import 'package:firebaseapp/services/auth.dart';
import 'package:firebaseapp/services/database.dart';
import 'package:firebaseapp/services/offline_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'custom_colors/custom_color.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final AuthService _auth = AuthService();
  final notifications = FlutterLocalNotificationsPlugin();


  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDatabase();
    print('Init run');

  }

  initDatabase() async{
    await DB.init();
  }


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
//    final notficationProvider = Provider.of<LocalNotificationHelper>(context);

    BuildContext parentContext=context;
    void _addTodo() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,

          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                )
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
              child: AddTodoForm(parentContext: parentContext,),
            );
          }
      );
    }

      return StreamProvider<List<Todo>>.value(
      value: DatabaseService(uid:user.uid).todos,
      child: Scaffold(
          appBar: AppBar(
            title:Text('Todo App',style: TextStyle(color: CustomColor.AccentColor,fontWeight: FontWeight.bold),),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(color: CustomColor.AccentColor),
          ),
          drawer: MainDrawer(),
          body:Container(
          child: TodoList(),
        ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              _addTodo();
            },
          child: SvgPicture.asset("assets/svg/plus.svg",height: 30.0,width: 30.0,color: Colors.white,)
      ),
      ),
    );
  }
}

