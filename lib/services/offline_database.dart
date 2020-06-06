import 'dart:async';
import 'dart:core';
import 'package:firebaseapp/models/labels.dart';
import 'package:flutter/material.dart';
import 'package:firebaseapp/models/mini_todo.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {

  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {

    if (_db != null) { return; }

    try {
      String _path = await getDatabasesPath() + 'notificationDB';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
      print('DB initialised');
    }
    catch(ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE todo_notification (id INTEGER PRIMARY KEY AUTOINCREMENT,date STRING, title STRING)');
    await db.execute('CREATE TABLE labels (id INTEGER PRIMARY KEY AUTOINCREMENT,label STRING, color STRING)');

  }


  static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

  static Future<List<Map<String,dynamic>>> queryId(String table,int id) async => _db.query(table,where: 'id=?',whereArgs: [id]);

  static Future<List<Map<String,dynamic>>> queryString(String table,String date) async => _db.query(table,where: 'date=?',whereArgs: [date]);

  static Future<List<Map<String,dynamic>>> queryLabel(String table,String label) async => _db.query(table,where: 'label=?',whereArgs: [label]);

  static Future<List<Map<String,dynamic>>> queryLabelTesting(String table,String label) async => _db.query(table,where: 'label= ?',whereArgs: [label]);

//  static Future<List<Map<String,dynamic>>> queryStringReturnID(String table,String date) async => _db.query(table,columns: ['id'],where: 'date=?',whereArgs: [date],limit: 1);

  static Future<int> insert(String table, dynamic miniTodo) async =>
      await _db.insert(table, miniTodo.toMap());


  static Future<int> update(String table, dynamic miniTodo) async =>
      await _db.update(table, miniTodo.toMap(), where: 'id = ?', whereArgs: [miniTodo.id]);


  static Future<int> delete(String table, dynamic miniTodo) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [miniTodo.id]);


}