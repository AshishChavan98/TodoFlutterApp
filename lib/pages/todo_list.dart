import 'package:firebaseapp/models/labels.dart';
import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/pages/todo_tile.dart';
import 'package:firebaseapp/services/offline_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TodoList extends StatefulWidget {

  Todo mainTodo;
  TodoList({this.mainTodo});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('TodoList Init called');
    WidgetsBinding.instance.addPostFrameCallback((_){
      getLabelColor();
    });
  }

  noTodoSVG(){
      return  Center(
      heightFactor: 2.0,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset("assets/svg/no_todo.svg",height:263,),
            SizedBox(height: 8.0,),
            Text("No Tasks",style: TextStyle(fontSize: 20.0),)
          ],
        ),
      ),
    );
  }

  List _labels;
  Future getLabelColor() async{
    String table="labels";
    try{
      List<Map<String,dynamic>> result = await DB.query(table);
      setState(() {
        _labels= result.map((item)=>Labels.fromMap(item)).toList();
      });

    }catch(e){
      print(DB);
      print("Exception in getLabelColor : "+e.toString());


    }


  }

  @override
  Widget build(BuildContext context){

    getLabelColor();
    final todos = Provider.of<List<Todo>>(context) ?? [];

    todos.sort((a,b)=>a.insertionId.compareTo(b.insertionId));
    return todos.length>0 ?
    ListView.builder(
        shrinkWrap: true,
        itemCount: todos.length,
        itemBuilder: (context,index){
            return TodoTile(todo:todos[index],mainTodo: widget.mainTodo,labels: _labels,);
        }
    )
        :
    widget.mainTodo ==null?
    noTodoSVG()
      :
    SizedBox.shrink();

  }
}
