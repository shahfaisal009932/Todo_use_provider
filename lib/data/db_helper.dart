///1
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_with_db_provider/data/todo_model.dart';

class DbHelper {
  DbHelper._();
  static DbHelper getInstance() => DbHelper._();
  Database? DB;

  static const TODO_NAME = "todo";
  static const TODO_COLUMN_ID = "id";
  static const TODO_COLUMN_TITLE = "title";
  static const TODO_COLUMN_DESC = "desc";
  static const TODO_COLUMN_CREATED_AT = "created_at";
  static const TODO_COLUMN_PRIORITY = "priority";
  static const TODO_COLUMN_IS_COMPLETED = "is_completed";

  Future<Database> initDB() async {
    DB ??= await openDB();
    return DB!;
  }

  /// open Database
  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String tPath = join(appDir.path, "todo.db");
    return await openDatabase(
      tPath,
      version: 2,
      onCreate: (db, version) => db.execute(
        "create table $TODO_NAME($TODO_COLUMN_ID integer primary key autoincrement, $TODO_COLUMN_TITLE text, $TODO_COLUMN_DESC text, $TODO_COLUMN_CREATED_AT integer, $TODO_COLUMN_PRIORITY integer, $TODO_COLUMN_IS_COMPLETED integer)",
      ),
    );
  }

  ///Events
  ///add todo

  Future<bool> addTodo({required TodoModel todo}) async {
    var db = await initDB();
    int rowsEffected = await db.insert(
      TODO_NAME,
      todo.toMap(),
      // {
      //   TODO_COLUMN_TITLE: title,
      //   TODO_COLUMN_DESC: desc,
      //   TODO_COLUMN_PRIORITY: priority,
      //   TODO_COLUMN_CREATED_AT: DateTime.now().millisecondsSinceEpoch,
      //   TODO_COLUMN_IS_COMPLETED: 0,
      // }
    );
    return rowsEffected > 0;
  }

  ///fetch todo
  Future<List<TodoModel>> fetchAllTodo({required int filterType}) async {
    var db = await initDB();

    ///1-> low, 2-> medium, 3-> high,
    ///4-> completed, 5-> pending,
    ///14-> (low & completed), 24-> (medium & completed), 34-> (high & completed)
    ///15-> (low & pending), 25-> (medium & pending), 35-> (high & pending)
    ///0-> all

    ///1-> low,
    if (filterType == 1) {
      return TodoModel.getAllTodo(
        await db.query(
          TODO_NAME,
          where: "$TODO_COLUMN_PRIORITY =?",
          whereArgs: [1],
        ),
      );
    }
    ///2-> medium,
    else if (filterType == 2) {
      return TodoModel.getAllTodo(
        await db.query(
          TODO_NAME,
          where: "$TODO_COLUMN_PRIORITY =?",
          whereArgs: [2],
        ),
      );
    }
    ///3-> high
    else if (filterType == 3) {
      return TodoModel.getAllTodo(
        await db.query(
          TODO_NAME,
          where: "$TODO_COLUMN_PRIORITY =?",
          whereArgs: [3],
        ),
      );
    }
    ///4-> completed
    else if (filterType == 4) {
      return TodoModel.getAllTodo(
        await db.query(
          TODO_NAME,
          where: "$TODO_COLUMN_IS_COMPLETED =?",
          whereArgs: [1],
        ),
      );
    }
    ///5-> pending
    else if (filterType == 5) {
      return TodoModel.getAllTodo(
        await db.query(
          TODO_NAME,
          where: "$TODO_COLUMN_IS_COMPLETED =?",
          whereArgs: [0],
        ),
      );
    }
    ///14-> (low & completed),
    // else if (filterType == 14) {
    //   return TodoModel.getAllTodo(
    //     await db.query(
    //       TODO_NAME,
    //       where: "$TODO_COLUMN_PRIORITY = ? and $TODO_COLUMN_IS_COMPLETED = ?",
    //       whereArgs: [1, 1],
    //     ),
    //   );
    // }
    ///24-> (medium & completed),
    // else if (filterType == 24) {
    //   return TodoModel.getAllTodo(
    //     await db.query(
    //       TODO_NAME,
    //       where: "$TODO_COLUMN_PRIORITY = ? and $TODO_COLUMN_IS_COMPLETED = ?",
    //       whereArgs: [2, 1],
    //     ),
    //   );
    // }
    // ///34-> (high & completed)
    // else if (filterType == 34) {
    //   return TodoModel.getAllTodo(
    //     await db.query(
    //       TODO_NAME,
    //       where: "$TODO_COLUMN_PRIORITY=? and $TODO_COLUMN_IS_COMPLETED=?",
    //       whereArgs: [3, 1],
    //     ),
    //   );
    // }
    // ///15-> (low & pending)
    // else if (filterType == 15) {
    //   return TodoModel.getAllTodo(
    //     await db.query(
    //       TODO_NAME,
    //       where: "$TODO_COLUMN_PRIORITY=? and $TODO_COLUMN_IS_COMPLETED=?",
    //       whereArgs: [1, 0],
    //     ),
    //   );
    // }
    // ///25-> (medium & pending)
    // else if (filterType == 25) {
    //   return TodoModel.getAllTodo(
    //     await db.query(
    //       TODO_NAME,
    //       where: "$TODO_COLUMN_PRIORITY=? and $TODO_COLUMN_IS_COMPLETED=?",
    //       whereArgs: [2, 0],
    //     ),
    //   );
    // }
    // ///35-> (high & pending)
    // else if (filterType == 35) {
    //   return TodoModel.getAllTodo(
    //     await db.query(
    //       TODO_NAME,
    //       where: "$TODO_COLUMN_PRIORITY=? and $TODO_COLUMN_IS_COMPLETED=?",
    //       whereArgs: [3, 0],
    //     ),
    //   );
    // }
    ///0-> all
    else {
      return TodoModel.getAllTodo(await db.query(TODO_NAME));
    }
  }

  ///1

  ///update todo
  updateTodo({
    required int id,
    required String title,
    required String desc,
    required int priority,
  }) async {
    var db = await initDB();
    int rowsEffected = await db.update(
      TODO_NAME,
      {
        TODO_COLUMN_TITLE: title,
        TODO_COLUMN_DESC: desc,
        TODO_COLUMN_PRIORITY: priority,
      },
      where: "$TODO_COLUMN_ID = ?",
      whereArgs: [id],
    );
    return rowsEffected > 0;
  }

  //delete todo
  Future<bool> deleteTodo({required int id}) async {
    var db = await initDB();
    int rowsEffected = await db.delete(
      TODO_NAME,
      where: "$TODO_COLUMN_ID = ?",
      whereArgs: [id],
    );
    return rowsEffected > 0;
  }

  ///2
  ///TaskCompletion
  Future<bool> updateTaskCompletion({
    required int id,
    required bool isCompleted,
  }) async {
    var db = await initDB();

    int rowsEffected = await db.update(
      TODO_NAME,
      {TODO_COLUMN_IS_COMPLETED: isCompleted ? 1 : 0},

      ///2
      where: "$TODO_COLUMN_ID = ?",
      whereArgs: [id],
    );
    return rowsEffected > 0;
  }
}
