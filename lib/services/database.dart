
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseapp/models/todo.dart';
import 'package:flutter/material.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference appCollection = Firestore.instance.collection('app');

  Future addTodoToFirestore(Todo todo) async{
    try{
      return await appCollection.document(uid).collection('todo').document().setData(todo.toMap());
    }catch(e){
      print('In addTodoToFirestor error');
      print(e.toString());
      return e.message;
    }

  }

  //Subtodo
  Future addSubTodoToFirestore(Todo todo,String documentId) async{
    try{
      return await appCollection.document(uid).collection('todo').document(documentId).collection('subtasks').document().setData(todo.toMap());
    }catch(e){
      print('In addSubTodoToFirestore error');
      print(e.toString());
      return e.message;
    }

  }

  Future updateTodoToFirestore(Todo todo) async{
    try{

      print(todo.toString());
      return await appCollection.document(uid).collection('todo').document(todo.documentId).updateData(todo.toMap());
    }catch(e){
      print(e.toString());
      return e.message;
    }
  }

  Future updateSubTodoToFirestore(Todo todo,String documentId) async{
    try{

      print(todo.toString());
      return await appCollection.document(uid).collection('todo').document(documentId).collection('subtasks').document(todo.documentId).updateData(todo.toMap());
    }catch(e){
      print(e.toString());
      return e.message;
    }
  }


  Future deleteSubCollection(String documentId){


      appCollection.document(uid).collection('todo').document(documentId).collection('subtasks').getDocuments().then((value){
          value.documents.map((e){
            e.reference.delete();
          });
      });



  }
  Future removeTodoFromFirestore(String documentId) async{
    try{
      await deleteSubCollection(documentId);
      return await appCollection.document(uid).collection('todo').document(documentId).delete();
    }catch(e){
      print(e.toString());
      return e.message;
    }
  }

  Future<int>  getSubTodosCount(String documentId) async{
    int length=0;
    await appCollection.document(uid).collection('todo').document(documentId).collection('subtasks').getDocuments().then(
            (value){
          length=value.documents.length;
    });

    return length;
  }
  Future removeSubTodoFromFirestore(String documentId,String subDocumentId) async{
    try{
       await appCollection.document(uid).collection('todo').document(documentId).collection('subtasks').document(subDocumentId).delete();
      return getSubTodosCount(documentId);

    }catch(e){
      print(e.toString());
      return e.message;
    }
  }


  List<Todo> _todoListFromSnapshot(QuerySnapshot snapshot){


    return snapshot.documents.map((doc){
      Todo todo = new Todo(
        title:doc.data['title'] ?? '',
        completed: doc.data['completed'] ?? false,
        documentId: doc.documentID ?? '',
      );
      todo.label=doc.data['label'] ?? null;
      doc.data['dueDate']!=null ? todo.dueDate = (doc.data['dueDate'] as Timestamp).toDate() : null;
      doc.data['insertionId']!=null ? todo.insertionId = (doc.data['insertionId'] as Timestamp).toDate() : null;
      if(doc.data['time']!=null){
        List<String> temp=doc.data['time'].toString().split(":");
        todo.time=TimeOfDay(hour: int.parse(temp[0]),minute: int.parse(temp[1]));
      }else{
        todo.time=null;
      }
      todo.subtask=doc.data['subtask'];

      return todo;
    }).toList();
  }

  Stream<List<Todo>> get todos{


    return appCollection.document(uid).collection('todo').snapshots()
    .map(_todoListFromSnapshot);

  }

  Stream<List<Todo>> subTodos(String documentId){
    return appCollection.document(uid).collection('todo').document(documentId).collection('subtasks').snapshots()
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