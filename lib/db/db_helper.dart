import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static const _version = 1;
  static const String _tableName = 'tasks';
  static Database? _database;

  static Future<void> initData() async {
    if (_database != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        String path = '${await getDatabasesPath()}task.db';
        _database = await openDatabase(path, version: _version,
            onCreate: (Database db, int version) async {
              await db.execute('CREATE TABLE $_tableName ( '
                  'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                  'title STRING , note Text,'
                  'isCompleted INTEGER , date STRING'
                  'startTime STRING , endTime STRING'
                  'repeat  STRING, remind INTEGER'
                  'color INTEGER,'
                  ')');
            });
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task task) async {
    print('data inserted');
    return await _database!.insert(_tableName, task.toMap());
  }

  static Future<int> delete(Task task) async {
    print('row deleted ');
    return await _database!.delete(
        _tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<List<Map<String, Object?>>> query(Task task) async {
    print('query done');
    return await _database!.query(_tableName);
  }

  static Future<int> update(int id) async {
    print('update done');
    return await _database!.rawUpdate('''
      UPDATE tasks
      set isCompleted = ?
      WHERE id = ?
    ''', [
        1,id
    ]);
  }

}
