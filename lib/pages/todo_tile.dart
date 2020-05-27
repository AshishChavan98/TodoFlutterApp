import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/models/user.dart';
import 'package:firebaseapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoTile extends StatelessWidget {

  Todo todo;
  TodoTile({this.todo});

  toggleTodo(String uid) async{
    await DatabaseService(uid:uid).updateTodoToFirestore(Todo(
        title:todo.title,task: todo.task,completed: !todo.completed,documentId:todo.documentId));
  }
  Widget taskIncompleteIcon(String uid){
    return IconButton(
      onPressed: (){
        toggleTodo(uid);
      },
      icon: Icon(
        Icons.radio_button_unchecked,
        color:Colors.grey[400],
        size: 35.0,
      ),
    );
  }
  Widget taskCompleteIcon(String uid){


    return IconButton(
      onPressed: (){
        toggleTodo(uid);
      },
      icon: Icon(
        Icons.check_circle,
        color: Colors.green[300],
        size: 35.0,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Padding(
      padding: EdgeInsets.only(top:0.0),
      child: Row(
        children: <Widget>[
          todo.completed ? taskCompleteIcon(user.uid):taskIncompleteIcon(user.uid),
          Container(
            padding:EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            width: MediaQuery.of(context).size.width*0.70,
            child:todo.completed ?Text(todo.title,style: TextStyle(color: Colors.blueGrey,fontSize: 20.0),):Text(todo.title,style: TextStyle(fontSize: 20.0),),

          ),
          IconButton(
          onPressed: () async{
              await DatabaseService(uid:user.uid).removeTodoFromFirestore(todo.documentId);
          },
          icon:Icon(Icons.delete,color:Colors.grey),

          )
        ],
      )
    );
  }
}

//child: ListTile(
//leading: todo.completed ? taskCompleteIcon(user.uid):taskIncompleteIcon(user.uid),
//title: todo.completed ?Text(todo.title,style: TextStyle(color: Colors.blueGrey),):Text(todo.title),
//subtitle: Text(todo.task),
//trailing: IconButton(
//onPressed: () async{
//await DatabaseService(uid:user.uid).removeTodoFromFirestore(todo.documentId);
//},
//icon:Icon(Icons.delete,color:Colors.grey),
//
//),
//),