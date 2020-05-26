import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/models/user.dart';
import 'package:firebaseapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTodoForm extends StatefulWidget {
  @override
  _AddTodoFormState createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {

  final _formKey =GlobalKey<FormState>();
  String _title;
  String _task;
  bool loading=false;

  loadingWidget(){
    if(!loading)
      {
        return SizedBox.shrink();
      }
    else{
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    double bottomValue = MediaQuery.of(context).viewInsets.bottom;

    toggleLoading(){
      setState(() {
        loading=!loading;
      });
    }

    return Container(
      margin:EdgeInsets.only(bottom: bottomValue),
      child: Container(
        child: Form(
          key:_formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Add Todo',textAlign:TextAlign.center,style: TextStyle(fontSize: 26.0),),
              SizedBox(height: 20.0,),
              TextFormField(
                validator: (val)=> val.isEmpty ? 'Input cannot be empty ':null,
                decoration: InputDecoration(
                    hintText: 'Todo..',
                    fillColor: Colors.grey[100],
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.deepPurpleAccent,width: 1.0),
                    ),
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.blueGrey,width: 1.0),

                  )

                ),
                onChanged: (val){
                  setState(()=>_title=val);
                },
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                validator: (val)=> val.isEmpty ? 'Description cannot be empty ':null,
                decoration: InputDecoration(
                    hintText: 'Description..',
                    fillColor: Colors.grey[100],
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.deepPurple[200],width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.blueGrey,width: 1.0),

                    )

                ),
                onChanged: (val){
                  setState(()=>_task=val);
                },
              ),
              SizedBox(height: 30.0,),
              Container(
                height: 50.0,
                child: FlatButton.icon(
                    color:Colors.deepPurple,
                    textColor: Colors.white,
                    onPressed: () async{

                      if(_formKey.currentState.validate()){
                        toggleLoading();
                        dynamic result=await DatabaseService(uid:user.uid).addTodoToFirestore(Todo(title:_title,task: _task));
                        toggleLoading();
                        if(result==null)
                          {

                            Navigator.pop(context);
                          }
                        else{
                          print('in result');
                          print(result);
                        }
                      }

                    },
                    icon: Icon(Icons.send,size: 24.0,),
                    label: Text('Add',style: TextStyle(fontSize: 20.0),)),

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  loadingWidget(),
                ],
              )




            ],
          ),
        ),
      ),
    );
  }
}
