import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../models/todo_model.dart';
import 'add_todo.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);



  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NOTES APP',
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyNavigator(context, 'add', -1, '');
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(35.0),
              child: Text(
                'TODAY\'S TASKS',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: kIconColor,
                ),
              ),
            ),
            const SizedBox(
              width: 250.0,
              child: Padding(
                padding: EdgeInsets.only(bottom: 35.0),
                child: Divider(
                  color: kIconColor,
                ),
              ),
            ),
            FutureBuilder(
              future: Hive.openBox('todo'),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return ToDoList();
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget ToDoList() {
    Box todoBox = Hive.box('todo');
    return ValueListenableBuilder(
      valueListenable: todoBox.listenable(),
      builder: (context, Box box, child) {
        if (box.values.isEmpty) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Text(
              'هیچ لیستی وجود ندارد',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: kIconColor,
              ),
            ),
          ));
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: todoBox.length,
              itemBuilder: (context, index) {
                final ToDo todo = box.getAt(index);
                return InkWell(
                  onTap: () => MyNavigator(context, 'update', index, todo.text),
                  child: Card(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: kTaskColor,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.circle_outlined,
                        color: kIconColor,
                      ),
                      title: Text(
                        todo.text,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: kWhiteColor,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () => remove(index),
                        icon: const Icon(Icons.delete),
                        color: kIconColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  MyNavigator(context, String type, int index, String text) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ToDoScreen(
          type: type,
          index: index,
          text: text,
        ),
      ),
    );
  }

  void remove(index) {
    Box box = Hive.box('todo');
    box.deleteAt(index);
  }
}
