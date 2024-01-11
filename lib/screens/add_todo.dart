import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
// import 'package:todo_list/constants.dart';

import '../constants.dart';
import '../models/todo_model.dart';

class ToDoScreen extends StatelessWidget {
  ToDoScreen(
      {Key? key, required this.type, required this.index, required this.text})
      : super(key: key);

  final String type;
  final int index;
  final String text;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (type == 'update') {
      controller.text = text;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          type == 'add' ? 'Add ToDo' : 'Update ToDo',
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    width: 2,
                    color: kIconColor,
                  ),
                ),
                labelText:
                    type == 'add' ? 'Add Test Content' : 'Update Task Content',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                onButtonPressed(controller.text);
                Navigator.pop(context);
              },
              child: Text(
                type == 'add' ? 'Add Task' : 'Update Task',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kIconColor),
                fixedSize: MaterialStateProperty.all(
                  const Size(150.0, 50.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onButtonPressed(String text) {
    if (type == 'add') {
      add(text);
    } else {
      update(text);
    }
  }

  add(String text) async {
    var box = await Hive.openBox('todo');
    ToDo todo = ToDo(text);
    int result = await box.add(todo);
  }

  update(String text) async {
    var box = await Hive.openBox('todo');
    ToDo todo = ToDo(text);
    box.putAt(index, todo);
  }
}
