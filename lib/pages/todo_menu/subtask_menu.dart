import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/pages/add_todo_form.dart';
import 'package:firebaseapp/pages/custom_colors/custom_color.dart';
import 'package:firebaseapp/pages/todo_list.dart';
import 'package:firebaseapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:firebaseapp/models/user.dart';

class SubtaskMenu extends StatefulWidget {
  
  Todo todo;
  SubtaskMenu({this.todo});
  
  @override
  _SubtaskMenuState createState() => _SubtaskMenuState();
}

class _SubtaskMenuState extends State<SubtaskMenu> {
  @override
  Widget build(BuildContext context) {


    void _addTodo() {
      print(widget.todo);
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
              child: AddTodoForm(todo:widget.todo),
            );
          }
      );
    }



    final user = Provider.of<User>(context);
    return Container(
      child: StreamProvider<List<Todo>>.value(
                value: DatabaseService(uid:user.uid).subTodos(widget.todo.documentId),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TodoList(mainTodo: widget.todo,),
                    SizedBox(height: 10.0,),
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 20.0),
                      child: FlatButton.icon(
                        onPressed: (){
                          print("Add task clicked");
                          _addTodo();
                        },
                        icon: Icon(Icons.add,color: CustomColor.IconGreyColor,size: 25.0,),
                        label: Text('Add Subtask',style: TextStyle(color:CustomColor.IconGreyColor,fontSize: 18.0),),
                      ),
                    )
                  ],

                ),
            ),
    );

  }
}
