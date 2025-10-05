import 'package:todo_with_db_provider/data/db_helper.dart';

class TodoModel {
  int? id;
  String title;
  String desc;
  int priority;
  int created_at;
  bool isCompleted;
  TodoModel({
    this.id,
    required this.title,
    required this.desc,
    required this.created_at,
    this.priority = 3,
    this.isCompleted = false,
  });

  ///2
  /// Model to Map
  Map<String, dynamic> toMap() {
    return {
      DbHelper.TODO_COLUMN_TITLE: title,
      DbHelper.TODO_COLUMN_DESC: desc,
      DbHelper.TODO_COLUMN_CREATED_AT: created_at,
      DbHelper.TODO_COLUMN_PRIORITY: priority,
      DbHelper.TODO_COLUMN_IS_COMPLETED: isCompleted ? 1 : 0,
    };
  }
  // { TODO_COLUMN_TITLE: title,
  //     TODO_COLUMN_DESC: desc,
  //     TODO_COLUMN_PRIORITY: priority,
  //     TODO_COLUMN_CREATED_AT: DateTime.now().millisecondsSinceEpoch,
  //     TODO_COLUMN_IS_COMPLETED: 0,}

  static List<TodoModel> getAllTodo(List<Map<String, dynamic>> allData) {
    List<TodoModel> mTodo = [];
    for (Map<String, dynamic> eachTodo in allData) {
      TodoModel todo = TodoModel.fromMap(eachTodo);
      mTodo.add(todo);
    }
    return mTodo;
  }

  /// Map to Model
  static TodoModel fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map[DbHelper.TODO_COLUMN_ID],
      isCompleted: map[DbHelper.TODO_COLUMN_IS_COMPLETED] == 1,
      priority: map[DbHelper.TODO_COLUMN_PRIORITY],
      title: map[DbHelper.TODO_COLUMN_TITLE],
      desc: map[DbHelper.TODO_COLUMN_DESC],
      created_at: map[DbHelper.TODO_COLUMN_CREATED_AT],
    );
  }
}
