import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/models/user.dart';
import 'package:firebaseapp/pages/custom_colors/custom_color.dart';
import 'package:firebaseapp/pages/todo_menu/add_todo_info.dart';
import 'package:firebaseapp/pages/todo_menu/subtask_menu.dart';
import 'package:firebaseapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';


//Todo Info view
class TodoInfoPage extends StatefulWidget {
  Todo todo;
  Todo mainTodo;
  TodoInfoPage({this.todo,this.mainTodo});
  @override
  _TodoInfoPageState createState() => _TodoInfoPageState();
}

class _TodoInfoPageState extends State<TodoInfoPage> {



  Todo todo;

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      todo=widget.todo;
    }


  updateTodo(Todo updatedTodo){
    setState(() {
      todo=updatedTodo;
    });
  }


  @override
  Widget build(BuildContext context) {


    subtasks(){
      return Column(
        children: <Widget>[
          Divider(color: CustomColor.TextDisabled,),
          SizedBox(height: 20.0,),
          Row(
            children: <Widget>[
              RotatedBox(
                quarterTurns: 1,
                child:SvgPicture.asset("assets/svg/route.svg",height: 25.0,width: 25.0,color: CustomColor.IconGreyColor,),
              ),
              SizedBox(width: 30.0,),
              Text('Subtask',style: TextStyle(color:CustomColor.RegularText,fontSize: 25.0),)

            ],
          ),
          SizedBox(height: 18.0,),
          Container(
//                height: MediaQuery.of(context).size.height*0.5,
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: SubtaskMenu(todo:todo)
          ),
        ],
      );
    }
    double bottomValue = MediaQuery.of(context).viewInsets.bottom;
    final user = Provider.of<User>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 30.0),
//      height: MediaQuery.of(context).size.height*0.90,
      child:  Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AddTodoInfoForm(todo: todo,updateTodo: updateTodo,),
            todo.subtask==-1?
                SizedBox.shrink():
                subtasks(),
            Container(

              decoration: BoxDecoration(
                color:CustomColor.AccentColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: FlatButton(
                onPressed: (){
                  print("Save Button pressed");
                  print(todo);
                  print(widget.mainTodo);
                  if(widget.mainTodo==null){
                    DatabaseService(uid:user.uid).updateTodoToFirestore(todo);
                  }
                  else{
                    DatabaseService(uid:user.uid).updateSubTodoToFirestore(todo, widget.todo.documentId);
                  }
                  Navigator.pop(context);
                },
                child: Text('Save',style: TextStyle(color: Colors.white,fontSize: 20.0),),
              ),
            ),
            SizedBox(height:bottomValue,),
          ],
        ),

    );
  }
}

