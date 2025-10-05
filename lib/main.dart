import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_db_provider/UI/home_page.dart';
import 'package:todo_with_db_provider/data/db_helper.dart';
import 'package:todo_with_db_provider/data/todo_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoProvider(dbHelper: DbHelper.getInstance()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
