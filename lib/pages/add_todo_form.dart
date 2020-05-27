import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/models/user.dart';
import 'package:firebaseapp/pages/menus/label_popup_menu.dart';
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

  String labelValue="None";



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

  FocusNode inputFieldNode;

  @override
  void initState() {
    super.initState();
    inputFieldNode = FocusNode();
  }

  @override
  void dispose() {
    inputFieldNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {




    selectLabelValue(String value){
      setState(() {
        labelValue=value;
      });
    }


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
              TextFormField(
                focusNode: inputFieldNode,
                autofocus: true,
                validator: (val)=> val.isEmpty ? 'Input cannot be empty ':null,
                style: TextStyle(fontSize:24.0),
                decoration: InputDecoration(

                    hintText: 'Enter Todo..',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.white,width: 1.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.white,width: 1.0),
                    ),
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.white,width: 1.0),
                  )

                ),
                onChanged: (val){
                  setState(()=>_title=val);
                },
              ),
              SizedBox(height: 10.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  labelValue=="None"?
                      SizedBox.shrink():
                      Container(
                        padding:EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.red[500]
                        ),
                        child:Text(
                          labelValue,
                          style: TextStyle(
                            color:Colors.white,
                            fontSize: 20.0
                          ),
                        )
                      ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: LabelPopMenu(updateParentLabel:selectLabelValue),
                  ),
                  SizedBox(width: 20.0,),
                  CircleAvatar(
                    radius:25.0,
                    backgroundColor: Colors.purple,
                    child: IconButton(
                        color:Colors.white,

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
                        icon: Icon(Icons.send,size: 30.0,),
                        ),

                  )
                ],
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
//Testing code