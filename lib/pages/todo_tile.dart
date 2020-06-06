import 'package:firebaseapp/main.dart';
import 'package:firebaseapp/models/labels.dart';
import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/models/user.dart';
import 'package:firebaseapp/pages/local_notification_widget.dart';
import 'package:firebaseapp/pages/notification/helper_functions.dart';
import 'package:firebaseapp/pages/todo_menu/todo_info.dart';
import 'package:firebaseapp/services/database.dart';
import 'package:firebaseapp/services/main_context.dart';
import 'package:firebaseapp/services/offline_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'custom_colors/custom_color.dart';

class TodoTile extends StatefulWidget {
  Todo todo;
  Todo mainTodo;
  List labels;
  TodoTile({this.todo,this.mainTodo,this.labels});


  @override
  _TodoTileState createState() => _TodoTileState();
}



class _TodoTileState extends State<TodoTile> {
  @override
  void initState(){
    print('Init state TodoListState');

  }
  Todo todo,mainTodo;


  toggleTodo(String uid) async{
    todo.completed = !todo.completed;
    print(todo);
    if(mainTodo==null){
      await DatabaseService(uid:uid).updateTodoToFirestore(todo);
    }
    else{
      await DatabaseService(uid:uid).updateSubTodoToFirestore(todo, mainTodo.documentId);
    }


  }

  Widget taskIncompleteIcon(String uid){

    return IconButton(
      onPressed: (){
        toggleTodo(uid);
      },
      icon: SvgPicture.asset("assets/svg/circle_outline.svg",height: 25.0,width: 25.0,color:CustomColor.TextDisabled,),
    );
  }
  Widget taskCompleteIcon(String uid){

    return IconButton(
      onPressed: (){
        toggleTodo(uid);
      },
      icon: SvgPicture.asset("assets/svg/tick.svg",height: 25.0,width: 25.0,color: CustomColor.AccentColor,),
    );
  }

  Color labelColor=Colors.black;

  getLabelColor() async{

    if(labelColor!=Colors.black){
      return ;
    }
    String table="labels";
    if(todo.label==null || DB==null)
      return;
    print("getLabelColor() : "+todo.label);
    String temp;
    if(widget.labels!=null){
      widget.labels.forEach((element) {
        if(element.label==todo.label){
          temp=element.color;
        }
      });
    }

    if(temp!=null){
      labelColor=Color(int.parse(temp));
    }
    else{
      labelColor=Colors.black;
    }

  }

  @override
  Widget build(BuildContext context) {
    todo=widget.todo;
    mainTodo=widget.mainTodo;
      getLabelColor();


//    print("Main Context : "+MainContext.mainContext.toString());
    getDateString(){
      DateTime today=DateTime.now();
      today=DateTime(today.year,today.month,today.day-1);
      DateTime dueDate=todo.dueDate;
//      month,day,
      final difference = dueDate.difference(today).inDays;
      if(difference==1){
        return "Today";
      }
      else if(difference==2){
        return "Tommorow";
      }
      return DateFormat("d MMMM").format(todo.dueDate);
    }
    void _viewTodoMenu() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color:Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    )
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
                child: TodoInfoPage(todo: todo,mainTodo: mainTodo,),
              ),
            );
          }
      );
    }



    final user = Provider.of<User>(context);
    return GestureDetector(
      onTap: (){
        print('clicked');
        _viewTodoMenu();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex:2,
              child: todo.completed ? taskCompleteIcon(user.uid):taskIncompleteIcon(user.uid),
            ),

            Expanded(
              flex:9,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top:10.0),
                    child:Wrap(
                      children: <Widget>[
                      todo.completed ?Text(todo.title,style: TextStyle(color: CustomColor.TextDisabled,fontSize: 20.0,decoration: TextDecoration.lineThrough),):Text(todo.title,style: TextStyle(fontSize: 20.0,color:CustomColor.RegularText),),
                      todo.subtask==1?
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 4.0, 0.0, 0.0),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: SvgPicture.asset("assets/svg/route.svg",height: 20.0,color: CustomColor.TextDisabled,),
                            ),
                          )
                              :
                          SizedBox.shrink(),
                      ],

                    ),
//                    child:todo.completed ?Text(todo.title,style: TextStyle(color: CustomColor.TextDisabled,fontSize: 20.0,decoration: TextDecoration.lineThrough),):Text(todo.title,style: TextStyle(fontSize: 20.0,color:CustomColor.RegularText),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      todo.dueDate == null?
                      SizedBox.shrink():
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SvgPicture.asset("assets/svg/calendar.svg",height: 15.0,color:Colors.green,),
                            SizedBox(width: 10.0,),
                            Text(
                              getDateString(),
                              style: TextStyle(color: Colors.green),
                            ),

                          ],

                        ),
                      ),
                      todo.label!=null?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.brightness_1,color:labelColor,size: 15.0,),
                          SizedBox(width: 5.0,),
                          Text(todo.label,style: TextStyle(color:labelColor)),
                          SizedBox(width: 15.0,),
                        ],
                      )
                          :
                      SizedBox.shrink()
                    ],
                  ),



                ],
              )

            ),
            todo.subtask == -1?
            Expanded(
              flex:1,
              child:IconButton(
                onPressed: () async{

                  int id = await getAlarmID(todo);
                  LocalNotificationHelper.cancelNotification(id);
                  DatabaseService(uid: user.uid).removeTodoFromFirestore(todo.documentId);

                  int length = await DatabaseService(uid:user.uid).removeSubTodoFromFirestore(mainTodo.documentId,todo.documentId);
                  if(length==0){
                    mainTodo.subtask=0;
                    await DatabaseService(uid:user.uid).updateTodoToFirestore(mainTodo);
                  }

                },
                icon:Icon(Icons.close,color:Colors.grey),

              )
              ,
            )
                :
              SizedBox.shrink(),

          ],
        ),
      ),
    );
  }
}

