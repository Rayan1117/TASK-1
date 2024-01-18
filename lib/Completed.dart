// ignore_for_file: file_names
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:hive/hive.dart";
import "package:todo_list/TaskList.dart";
import "package:todo_list/completedTaskCard.dart";
import "package:todo_list/localDatabase.dart";

// ignore: must_be_immutable
class Completed extends StatefulWidget {
  const Completed({super.key});

  @override
  State<Completed> createState() => _CompletedState();
}

localDatabase db=localDatabase();

List completedTask = [];

final todo = Hive.box("ToDo");

void updateList() {
  TaskList(
    completed: (index) {
      completedTask.add(
        List.from(
          taskLists[index],
        ),
      );
    },
  );
}

class _CompletedState extends State<Completed> {
  @override
  void initState() {
    if (todo.get("COMPLETEDLIST") != null) {
      db.loadC();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (completedTask.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Text(
            "No Tasks Completed",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
      );
    }

    setState(
      () {
        updateList();
        db.updateC();
      },
    );
    db.loadC();
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ListView.builder(
        itemCount: completedTask.length,
        itemBuilder: (context, index) {
          return completedTaskCard(
            task: completedTask[index][0],
            description: completedTask[index][1],
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(50, 300, 50, 300),
                    child: Card(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "are you want to delete?",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 50,
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      completedTask.removeAt(index);
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(msg: "deleted");
                                      db.updateC();
                                    },
                                  );
                                },
                                child: const Text("Yes"),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                child: const Text("No"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            onChanged: (val) {
              setState(
                () {
                  taskLists.add(completedTask[index]);
                  completedTask.removeAt(index);
                  Fluttertoast.showToast(msg: "task unchecked");
                  db.updateC();
                  db.updateT();
                },
              );
            },
          );
        },
      ),
    );
  }
}
