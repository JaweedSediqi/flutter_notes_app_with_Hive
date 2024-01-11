import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_hive/screens/home_screen.dart';


import 'constants.dart';
import 'models/todo_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgroundColor,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kIconColor,
          foregroundColor: kTaskColor,
        ),
        appBarTheme: const AppBarTheme(color: kBackgroundColor),
      ),
      home: const HomeScreen(),
    );
  }
}

