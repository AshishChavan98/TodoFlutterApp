import 'package:firebaseapp/models/labels.dart';
import 'package:firebaseapp/models/mini_todo.dart';
import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/models/user.dart';
import 'package:firebaseapp/pages/custom_colors/custom_color.dart';
import 'package:firebaseapp/pages/date_time_picker/date_and_time_picker.dart';
import 'package:firebaseapp/pages/local_notification_widget.dart';
import 'package:firebaseapp/pages/menus/label_popup_menu.dart';
import 'package:firebaseapp/services/database.dart';
import 'package:firebaseapp/services/offline_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'notification/helper_functions.dart';

class AddTodoForm extends StatefulWidget {


  Todo todo;
  BuildContext parentContext;
  AddTodoForm({this.todo,this.parentContext});

  @override
  _AddTodoFormState createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {

  final _formKey =GlobalKey<FormState>();

  Map<String,String> svgPath = {
    'label': "assets/svg/tag.svg",
    'calendar':"assets/svg/calendar.svg",
    'notification':"assets/svg/notification.svg"
  };

  String _title;
  bool loading=false;

  String labelValue=null;
  Color labelColor;
  //Reminder calendar Button Date and value
  DateTime reminderDate;
  String reminderDateString=null;
  setReminder(DateTime date){
    setState(() {
      reminderDate=date;
      print(reminderDate);
      if(date==null) {
        reminderDateString = null;
      }else{
        reminderDateString=DateFormat("d MMMM").format(date);
      }
    });
  }

  //Reminder Time
  TimeOfDay reminderTime;
  String reminderTimeString;

  setTime(TimeOfDay time){
    setState(() {
      reminderTime=time;
      print(reminderTime);
      if(time==null){
        reminderTimeString=null;
      }else{
          if(reminderTime.period==DayPeriod.am){
            reminderTimeString=reminderTime.hourOfPeriod.toString()+":"+reminderTime.minute.toString()+" AM";
          }
          else{
            reminderTimeString=reminderTime.hourOfPeriod.toString()+":"+reminderTime.minute.toString()+" PM";
          }
      }
    });
  }

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


//    final notficationProvider = Provider.of<LocalNotificationHelper>(widget.parentContext);


    setNotification(todo) async{
      print(reminderTime);
      print(reminderDate);

      DateTime dateTime = DateTime.now();
      int id;
      if(reminderTime==null){
        print("No Time");
      }else if(reminderDate==null)
      {
          print("reminderDate==null");
          dateTime=DateTime(dateTime.year,dateTime.month,dateTime.day,reminderTime.hour,reminderTime.minute);
          id = await getAlarmIDAfterInsertion(todo);
          LocalNotificationHelper.showNotification(id, dateTime);
      }
      else{
        dateTime=DateTime(reminderDate.year,reminderDate.month,reminderDate.day,reminderTime.hour,reminderTime.minute);
        id = await getAlarmIDAfterInsertion(todo);
        LocalNotificationHelper.showNotification(id, dateTime);
      }
    }

    //Label value
    selectLabelValue(String label) async{

        String table="labels";
        if(label!=null){
          int id=int.parse(label);
          List<Map<String,dynamic>> result= await  DB.queryId(table, id);
          List _labels = result.map((item)=>Labels.fromMap(item)).toList();

          setState(() {
            labelValue=_labels.first.label;
            labelColor=Color(int.parse(_labels.first.color));

          });
        }else{
          setState(() {
            labelValue=null;
          });
        }

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
//                focusNode: inputFieldNode,
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
//             Labels of label ,reminder etc

              SizedBox(height: 10.0,),
              Wrap(
                children: <Widget>[
                  labelValue==null?
                  SizedBox.shrink():
                  LabelWidget(labelText: labelValue,resetLabel:selectLabelValue,primaryColor:labelColor ,secondaryColor: labelColor.withAlpha(30),svgPath: svgPath['label']),
                  SizedBox(width: 10.0,),
                  reminderDateString==null?
                  SizedBox.shrink():
                  LabelWidget(labelText: reminderDateString,resetLabel:setReminder,primaryColor:CustomColor.GreenTheme[0] ,secondaryColor: CustomColor.GreenTheme[1],svgPath: svgPath['calendar']),
                  SizedBox(width: 10.0,),
                  reminderTimeString==null?
                  SizedBox.shrink():
                  LabelWidget(labelText: reminderTimeString,resetLabel:setTime,primaryColor:CustomColor.PurpleTheme[0] ,secondaryColor: CustomColor.PurpleTheme[1],svgPath: svgPath['notification']),

                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 10.0,),
                      LabelPopMenu(updateParentLabel:selectLabelValue),
                      SizedBox(width: 25.0,),
                      TimePicker(setTime: setTime,),
                      SizedBox(width: 25.0,),
                      DatePicker(setReminder:setReminder),
                    ],
                  ),

                  IconButton(
                      color:Colors.white,

                      onPressed: () async{

                        if(_formKey.currentState.validate()){
                          toggleLoading();
                          Todo todo = new Todo();
                          todo.title=_title;
                          todo.label=labelValue;
                          todo.dueDate=reminderDate;

                          todo.time=reminderTime;
                          print("Adding Reminder time : "+reminderTime.toString());
                          dynamic result;
                          if(widget.todo==null)
                          {
                             result =await DatabaseService(uid:user.uid).addTodoToFirestore(todo);
                          }else{
                              todo.subtask=-1;
                              if(widget.todo.subtask==0){
                                Todo tempTodo=widget.todo;
                                tempTodo.subtask=1;
                                await DatabaseService(uid:user.uid).updateTodoToFirestore(tempTodo);
                              }
                              result = await DatabaseService(uid:user.uid).addSubTodoToFirestore(todo, widget.todo.documentId);
                          }

                          setNotification(todo);
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
                      icon: SvgPicture.asset("assets/svg/send.svg",color: CustomColor.AccentColor,),
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


class LabelWidget extends StatelessWidget {

  final Function resetLabel;
  final String labelText;
  final Color primaryColor;
  final Color secondaryColor;
  String svgPath;
  LabelWidget({this.resetLabel,this.labelText,this.primaryColor,this.secondaryColor,this.svgPath});

  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: EdgeInsets.only(top: 10.0),
        padding:EdgeInsets.fromLTRB(12.0, 8.0, 18.0, 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: secondaryColor,
          border: Border.all(
            color: primaryColor,
          )
        ),
        child:Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
                onTap: (){
                  resetLabel(null);
                },
                child: Icon(Icons.close,color: primaryColor,size: 18.0,)
            ),
            SizedBox(width: 15.0,),
            SvgPicture.asset(svgPath,height: 17.0,width: 17.0,color: primaryColor,),
            SizedBox(width: 10.0,),
            Text(
              labelText,
              style: TextStyle(
                  color:primaryColor,
                  fontSize: 15.0
              ),
            ),
          ],

        )
    );
  }
}
