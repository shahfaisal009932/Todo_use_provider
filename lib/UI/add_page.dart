import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_db_provider/data/todo_model.dart';
import 'package:todo_with_db_provider/data/todo_provider.dart';

// ignore: must_be_immutable
class AddPage extends StatelessWidget {
  var titleController = TextEditingController();
  var descController = TextEditingController();
  var selectedPriority = 3;

  AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Todo",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   "Add Todo",
              //   style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(height: 18),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  //prefixIcon: Icon(Icons.title),
                  hintText: "enter title",
                  hintStyle: TextStyle(color: Colors.grey.shade800),
                  labelText: "Title",
                  labelStyle: TextStyle(color: Colors.black87, fontSize: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                minLines: 3,
                maxLines: 3,
                controller: descController,
                decoration: InputDecoration(
                  //prefixIcon: Icon(Icons.description),
                  hintText: "enter desc",
                  hintStyle: TextStyle(color: Colors.grey.shade800),
                  labelText: "desc",
                  labelStyle: TextStyle(color: Colors.black87, fontSize: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
              ),
              SizedBox(height: 18),
              StatefulBuilder(
                builder: (context, ss) {
                  return Row(
                    children: [
                      RadioMenuButton(
                        value: 1,
                        groupValue: selectedPriority,
                        onChanged: (value) {
                          selectedPriority = value!;
                          ss(() {});
                        },
                        child: Text("Low"),
                      ),
                      RadioMenuButton(
                        value: 2,
                        groupValue: selectedPriority,
                        onChanged: (value) {
                          selectedPriority = value!;
                          ss(() {});
                        },
                        child: Text("Med"),
                      ),
                      RadioMenuButton(
                        value: 3,
                        groupValue: selectedPriority,
                        onChanged: (value) {
                          selectedPriority = value!;
                          ss(() {});
                        },
                        child: Text("High"),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isNotEmpty &&
                            descController.text.isNotEmpty) {
                          bool check = await context
                              .read<TodoProvider>()
                              .addTodo(
                                todo: TodoModel(
                                  title: titleController.text,
                                  desc: descController.text,
                                  created_at:
                                      DateTime.now().millisecondsSinceEpoch,
                                  priority: selectedPriority,
                                ),
                              );

                          if (check) {
                            titleController.clear();
                            descController.clear();
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Data added succecfully"),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.green.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please fill all the fields"),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      },
                      child: Text("Save", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        titleController.clear();
                        descController.clear();
                        Navigator.pop(context);
                      },
                      child: Text("Cancel", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
