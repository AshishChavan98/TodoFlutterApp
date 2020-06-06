import 'package:firebaseapp/models/mini_todo.dart';
import 'package:firebaseapp/models/todo.dart';
import 'package:firebaseapp/services/offline_database.dart';

Future<int> getAlarmIDAfterInsertion(Todo todo) async{
  String table='todo_notification';
  List<Map<String,dynamic>> result;
  List _tasks;
  print("getAlarmIdAfterInsertion");
  String date=todo.insertionId.toIso8601String();
  date=date.substring(0,date.length-3);
  print(date);
  await DB.insert(table, MiniTodo(title: todo.title,insertionDate: date));

  result = await DB.queryString(table, date);
  _tasks = result.map((item)=>MiniTodo.fromMap(item)).toList();

//  print("getAlarmId");
//  print(_tasks.first.id);
  return _tasks.first.id;
}

Future<int> getAlarmID(Todo todo) async{
  String table='todo_notification';

  List _tasks;

  List<Map<String,dynamic>> result = await DB.queryString(table, todo.insertionId.toIso8601String());
  _tasks = result.map((item)=>MiniTodo.fromMap(item)).toList();
  print("getAlarmId");
  print(todo.insertionId.toIso8601String());
  print(_tasks);
  if(_tasks.isEmpty){
    return 0;
  }
  print("getAlarmId");

  print(_tasks.first.id);
  return _tasks.first.id;
}


