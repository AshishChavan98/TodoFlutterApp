
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseapp/models/todo.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference appCollection = Firestore.instance.collection('app');

  Future addTodoToFirestore(Todo todo) async{
    try{
      return await appCollection.document(uid).collection('todo').document().setData(todo.toMap());
    }catch(e){
      print(e.toString());
      return e.message;
    }

  }

  Future updateTodoToFirestore(Todo todo) async{
    try{

      print('${todo.title} ${todo.task} ${todo.completed} ${todo.documentId}');
      return await appCollection.document(uid).collection('todo').document(todo.documentId).updateData(todo.toMap());
    }catch(e){
      print(e.toString());
      return e.message;
    }
  }
  Future removeTodoFromFirestore(String documentId) async{
    try{
      return await appCollection.document(uid).collection('todo').document(documentId).delete();
    }catch(e){
      print(e.toString());
      return e.message;
    }
  }

  List<Todo> _todoListFromSnapshot(QuerySnapshot snapshot){


    return snapshot.documents.map((doc){

      return Todo(
        title:doc.data['title'] ?? '',
        task: doc.data['task'] ?? '',
        completed: doc.data['completed'] ?? false,
        documentId: doc.documentID ?? '',
      );
    }).toList();
  }
  Stream<List<Todo>> get todos{


    return appCollection.document(uid).collection('todo').snapshots()
    .map(_todoListFromSnapshot);

  }

  Future<int> getTodoListLength() async{

    int length;

    appCollection.document(uid).collection('todo').getDocuments().then((doc){
      length=doc.documents.length;
      print(length);
    });
    return length;
  }

}