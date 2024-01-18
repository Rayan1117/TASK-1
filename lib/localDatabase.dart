// ignore_for_file: file_names

import "package:hive/hive.dart";
import "package:todo_list/Completed.dart";
import "package:todo_list/TaskList.dart";

// ignore: camel_case_types
class localDatabase {
  final todo = Hive.box("ToDo");

  void loadT() {
    taskLists = todo.get("TASKLIST");
  }

  void updateT() {
    todo.put("TASKLIST", taskLists);
  }

  void updateC() {
    todo.put("COMPLETEDLIST", completedTask);
  }

  void loadC() {
    completedTask = todo.get("COMPLETEDLIST");
  }
}