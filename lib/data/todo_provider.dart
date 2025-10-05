import 'package:flutter/material.dart';
import 'package:todo_with_db_provider/data/db_helper.dart';
import 'package:todo_with_db_provider/data/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  DbHelper dbHelper;
  TodoProvider({required this.dbHelper});
  List<TodoModel> _mData = [];

  List<TodoModel> getTodo() {
    return _mData;
  }

  ///event
  Future<bool> addTodo({required TodoModel todo}) async {
    bool isAdded = await dbHelper.addTodo(todo: todo);
    if (isAdded) {
      fetchALLTodo();
    }
    return isAdded;
  }

  fetchALLTodo({int filterType = 0}) async {
    _mData = await dbHelper.fetchAllTodo(filterType: filterType);
    notifyListeners();
  }

  completeTask({required int id, required bool isCompleted}) async {
    bool isUpdated = await dbHelper.updateTaskCompletion(
      id: id,
      isCompleted: isCompleted,
    );
    if (isUpdated) {
      fetchALLTodo();
    }
  }
}
