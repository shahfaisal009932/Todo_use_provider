import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_db_provider/UI/add_page.dart';
import 'package:todo_with_db_provider/data/todo_model.dart';
import 'package:todo_with_db_provider/data/todo_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

///1
class _HomePageState extends State<HomePage> {
  //DbHelper? dbHelper;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<TodoModel> allTodo = [];
  int selectedPriority = 0;

  @override
  void initState() {
    super.initState();
    context.read<TodoProvider>().fetchALLTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TODO",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  filterButton("All", 0),
                  filterButton("Low", 1),
                  filterButton("Medium", 2),
                  filterButton("High", 3),
                  filterButton("Completed", 4),
                  filterButton("Pending", 5),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (_, provider, __) {
                allTodo = provider.getTodo();
                return allTodo.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: allTodo.length,
                          itemBuilder: (_, index) {
                            /// Background color based on priority
                            int priority = allTodo[index].priority;
                            Color bgColor = Colors.white;

                            if (priority == 1) {
                              bgColor = Colors.green.shade100;
                            } else if (priority == 2) {
                              bgColor = Colors.yellow.shade100;
                            } else if (priority == 3) {
                              bgColor = Colors.red.shade100;
                            }

                            ///1
                            int rawDate = allTodo[index].created_at;
                            DateTime parsedDate =
                                DateTime.fromMillisecondsSinceEpoch(rawDate);
                            String formattedDate = DateFormat(
                              'dd MMM yyyy, hh:mm a',
                            ).format(parsedDate);

                            ///1
                            return Card(
                              child: CheckboxListTile(
                                tileColor: bgColor,
                                value: allTodo[index].isCompleted,
                                onChanged: (value) async {
                                  provider.completeTask(
                                    id: allTodo[index].id!,
                                    isCompleted: value ?? false,
                                  );
                                },
                                title: Text(
                                  allTodo[index].title,
                                  style: TextStyle(
                                    decoration: allTodo[index].isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allTodo[index].desc,
                                      style: TextStyle(
                                        fontSize: 15,
                                        decoration: allTodo[index].isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(child: Text("Empty Todo"));
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget filterButton(String label, int filteredKey) {
    bool isSelected = selectedPriority == filteredKey;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedPriority = filteredKey;
          });
          context.read<TodoProvider>().fetchALLTodo(filterType: filteredKey);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey.shade400,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
