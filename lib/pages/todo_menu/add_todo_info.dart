import 'package:firebaseapp/models/labels.dart';
import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/models/user.dart';
import 'package:firebaseapp/pages/custom_colors/custom_color.dart';
import 'package:firebaseapp/pages/date_time_picker/date_and_time_picker.dart';
import 'package:firebaseapp/pages/local_notification_widget.dart';
import 'package:firebaseapp/pages/menus/label_popup_menu.dart';
import 'package:firebaseapp/pages/notification/helper_functions.dart';
import 'package:firebaseapp/services/database.dart';
import 'package:firebaseapp/services/offline_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddTodoInfoForm extends StatefulWidget {

  Todo todo;
  Function updateTodo;
  AddTodoInfoForm({this.todo,this.updateTodo});
  @override
  _AddTodoInfoFormState createState() => _AddTodoInfoFormState();
}

class _AddTodoInfoFormState extends State<AddTodoInfoForm> {

  Todo todo;

  final _formKey =GlobalKey<FormState>();
  String _title;
  bool loading=false;

  String labelValue;


  updateTodoVariable(){
    widget.updateTodo(todo);
  }

  //Reminder calendar Button Date and value
  DateTime reminderDate;
  String reminderDateString;
  setReminder(DateTime date){
    setState(() {
      reminderDate=date;
      print(reminderDate);
      if(date==null) {
        reminderDateString = null;
      }else{
        reminderDateString=DateFormat("d MMMM").format(date);
        todo.dueDate=date;
        updateTodoVariable();
      }



    });
  }

  //Reminder Time
  TimeOfDay reminderTime;
  String reminderTimeString;

  setTime(TimeOfDay time){
    setState(() {
      reminderTime=time;
      print("reminder Time "+reminderTime.toString());
      if(time==null){
        reminderTimeString=null;
      }else{
        if(reminderTime.period==DayPeriod.am){
          reminderTimeString=reminderTime.hourOfPeriod.toString()+":"+reminderTime.minute.toString()+" AM";
        }
        else{
          reminderTimeString=reminderTime.hourOfPeriod.toString()+":"+reminderTime.minute.toString()+" PM";
        }
        todo.time=time;
        updateTodoVariable();
      }
    });
  }

  Color labelColor=Colors.black;
  //Label value
  getLabelColor(String label) async{
    String table = "labels";
    List<Map<String,dynamic>> result = await DB.query(table);
    List _labels= result.map((item)=>Labels.fromMap(item)).toList();
    _labels.forEach((element) {
      if(element.label==label){
        labelColor=Color(int.parse(element.color));
      }
    });
  }


  selectLabelValue(String label) async{
    String table="labels";

    if(label!=null){
      int id;
      try{
        id=int.parse(label);


      }catch(e){
        print("In exception e: "+e.toString());
        setState(() {
          labelValue=label;
          todo.label=label;
          updateTodoVariable();
        });
        getLabelColor(label);
        return;
      }


      List<Map<String,dynamic>> result= await  DB.queryId(table, id);
      List _labels = result.map((item)=>Labels.fromMap(item)).toList();

      setState(() {
        labelValue=_labels.first.label;
        todo.label=labelValue;
        labelColor=Color(int.parse(_labels.first.color));
        updateTodoVariable();

      });
    }else{
      setState(() {
        labelValue=null;
        todo.label=labelValue;
        updateTodoVariable();
      });
    }

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


  @override
  void initState() {
    super.initState();
    todo=widget.todo;
    print("In AddTodoInfo init");
    print(todo);
    print(widget.todo);
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(todo!=null){
        setTime(todo.time);
        setReminder(todo.dueDate);
        selectLabelValue(todo.label);
        _title=todo.title;
      }
    });


  }

  Map<String,String> svgPath = {
    'label': "assets/svg/tag.svg",
    'calendar':"assets/svg/calendar.svg",
     'notification':"assets/svg/notification.svg"
  };


  dynamic notficationProvider;
  @override
  Widget build(BuildContext context) {


    final user = Provider.of<User>(context);
    double bottomValue = MediaQuery.of(context).viewInsets.bottom;

    deleteSubTodos() async{
      int id;
      print("Todo subtask : "+todo.subtask.toString());
      if(todo.subtask==1){
        Stream<List<Todo>> subTodosStream= DatabaseService(uid:user.uid).subTodos(todo.documentId);
        print("SubTodosStream : ");
        print(subTodosStream.length);


        subTodosStream.forEach((element) {
          element.forEach((t) async{
            print(t);
            int id = await getAlarmID(t);
            if(id!=0){
              print("yeahhhhh");
              LocalNotificationHelper.cancelNotification(id);
            }
          });
        });




      }
    }
    toggleLoading(){
      setState(() {
        loading=!loading;
      });
    }

    toggleTodo(String uid) async{
      todo.completed = !todo.completed;
      updateTodoVariable();
      await DatabaseService(uid:uid).updateTodoToFirestore(todo);

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



    return Container(
      child: Container(
        child: Form(
          key:_formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
//                focusNode: inputFieldNode,
                autofocus: false,
                validator: (val)=> val.isEmpty ? 'Input cannot be empty ':null,
                initialValue: todo.title,
                style: TextStyle(fontSize:24.0),
                decoration: InputDecoration(

                    icon: todo.completed ? taskCompleteIcon(user.uid):taskIncompleteIcon(user.uid),
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
                  setState((){
                    _title=val;
                    todo.title=_title;
                    updateTodoVariable();
                  });
                },
              ),
//             Labels of label ,reminder etc


              Wrap(

                children: <Widget>[
                  labelValue==null?
                  SizedBox.shrink():
                  LabelWidget(labelText: labelValue,resetLabel:selectLabelValue,primaryColor:labelColor ,secondaryColor: CustomColor.RedTheme[1],svgPath: svgPath['label'],),
                  SizedBox(width: 10.0,),
                  reminderDateString==null?
                  SizedBox.shrink():
                  LabelWidget(labelText: reminderDateString,resetLabel:setReminder,primaryColor:CustomColor.GreenTheme[0] ,secondaryColor: CustomColor.GreenTheme[1],svgPath: svgPath['calendar']),
                  SizedBox(width: 10.0,),
                  reminderTimeString==null?
                  SizedBox.shrink():
                  LabelWidget(labelText: reminderTimeString,resetLabel:setTime,primaryColor:CustomColor.PurpleTheme[0] ,secondaryColor: CustomColor.PurpleTheme[1],svgPath: svgPath['notification'] ),



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
                      int id = await getAlarmID(todo);
                      if(id!=0){
                        LocalNotificationHelper.cancelNotification(id);
                      }
                      deleteSubTodos();

                      DatabaseService(uid: user.uid).removeTodoFromFirestore(todo.documentId);
                      Navigator.pop(context);

                    },
                    icon: SvgPicture.asset("assets/svg/bin.svg",color: Colors.redAccent,height: 20.0,width: 20.0,),
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
            color: svgPath==null?secondaryColor:Colors.white,
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
                child:Icon(Icons.close,color: primaryColor,size: 18.0,)


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
