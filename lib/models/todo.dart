import 'package:flutter/material.dart';

class Todo{
  //Server reference
  String documentId;
  DateTime insertionId;

  //Regarding Todo
  String title;
  bool completed;

  //Regarding Date and time
  DateTime _dueDate;

  //Subtask
  int subtask;

  DateTime get dueDate => _dueDate;

  set dueDate(DateTime value) {
    _dueDate = value;
  }

  TimeOfDay _time;

  //Labelling
  String _label;

  Todo({this.title,this.completed=false,this.documentId=''}){
    insertionId=DateTime.now();
    _time=null;
    _dueDate=null;
    _label=null;
    subtask=0;
  }



  Map<String,dynamic> toMap(){

    String timeString;
    if(time!=null){
      timeString=_time.hour.toString()+":"+_time.minute.toString();
    }
    return {
      'title':title,
      'completed':completed,
      'insertionId':insertionId,
      'time':timeString,
      'dueDate':_dueDate,
      'label':_label,
      'subtask':subtask,

    };
  }

  TimeOfDay get time => _time;

  set time(TimeOfDay value) {
    _time = value;
  }

  String get label => _label;

  set label(String value) {
    _label = value;
  }

  @override
  String toString() {
    return 'Todo{documentId: $documentId, insertionId: $insertionId, title: $title, completed: $completed, _dueDate: $_dueDate, subtask: $subtask, _time: $_time, _label: $_label}';
  }
}