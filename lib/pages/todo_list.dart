import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/pages/todo_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebaseapp/pages/notification/notifications.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('TodoList Init called');
  }
  @override
  Widget build(BuildContext context) {

    final todos = Provider.of<List<Todo>>(context) ?? [];

    return todos.length>0 ?
    ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context,index){
          return TodoTile(todo:todos[index]);
        }
    )
        :
    Center(
      child: Container(
        child: Text(
            'No Todos. Create New',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.blueGrey,
            ),
        ),
      ),
    );

    return Text('Testing');
  }
}
