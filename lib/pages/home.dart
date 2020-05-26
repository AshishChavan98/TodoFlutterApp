import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/models/user.dart';
import 'package:firebaseapp/pages/add_todo_form.dart';
import 'package:firebaseapp/pages/local_notification_widget.dart';
import 'package:firebaseapp/pages/notification/notifications.dart';
import 'package:firebaseapp/pages/todo_list.dart';
import 'package:firebaseapp/services/auth.dart';
import 'package:firebaseapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';



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
    print('Init run');

  }




  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    void _addTodo() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,

          builder: (context) {
            return Container(
//              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )
              ),
              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 60.0),
              child: AddTodoForm(),
            );
          }
      );
    }

      return StreamProvider<List<Todo>>.value(
      value: DatabaseService(uid:user.uid).todos,
      child: Scaffold(
//        resizeToAvoidBottomInset: true,
//        resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            title:Text('Todo App'),
            backgroundColor: Colors.deepPurple,
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () async{
                    await _auth.signOut();
                  },
                  icon: Icon(Icons.person,color: Colors.white,),
                  label: Text('Logout',style: TextStyle(color:Colors.white),))
            ],
          ),
          body:Container(
          child: TodoList(),
        ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              _addTodo();
            },
          child: Icon(Icons.add,size:50.0),
      ),
      ),
    );
  }
}

