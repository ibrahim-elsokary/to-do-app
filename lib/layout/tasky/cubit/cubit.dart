// ignore_for_file: avoid_print

import 'dart:async';

import 'package:first_app/modules/todo_app/s1/s1.dart';
import 'package:first_app/modules/todo_app/s2/s2.dart';
import 'package:first_app/modules/todo_app/s3/s3.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';

import 'states.dart';

class TaskyCubit extends Cubit<TaskyStates> {
  TaskyCubit() : super(TaskyInitState());

  static TaskyCubit get(context) => BlocProvider.of(context);
  //////////////////////////////////////////////////
  bool isShow = false;

  int navIndex = 0;

  var databasesPath;

  late Database database;

  IconData fab = Icons.edit;

  List<Map>? tasks = [];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  List<Widget>? screens = [S1(), S2(), S3()];

  void changFab() {
    emit(TaskychangFab());
  }

  void changeNav() {
    emit(TaskyChangeNav());
  }

  void creatDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    final Future<Database>? db = openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      version: 1,
      onCreate: (db, version) async {
        return await db.execute(
            'CREATE TABLE todo (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time Text,status Text)');
      },
      onOpen: (db) {
        getDataFromDatabase(db);
      },
    ).then((value) {
      return database = value;
    });
  }

  Future<void> insrtIntoDatabase(
      {String? title, String? date, String? time}) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO todo(title, date, time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('inserted valus $value');
        emit(TaskyinsrtIntoDatabase());
      });
    });
  }

  Future<void> getDataFromDatabase(Database database) async {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(TaskygetDataFromDatabase());
    List<Map>? t = await database.rawQuery('SELECT * FROM todo').then((value) {
      tasks = value;
      for (var element in value) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      }
    });
  }

  void updateDatabase(Database database, {int? id, String? status}) async {
    await database
        .rawUpdate('UPDATE todo SET status = ? WHERE id = $id', ['$status']);
    emit(TaskyUpdateDatabase());
    getDataFromDatabase(database);
  }

  void delDatabase(Database database, {int? id}) async {
    await database.rawDelete('DELETE FROM todo WHERE id = ?', ['$id']);
    emit(TaskyDeleteDatabase());
    getDataFromDatabase(database);
  }
}
