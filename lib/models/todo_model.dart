import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 1)
class ToDo {
  ToDo(this.text);

  @HiveField(0)
  String text;
}
