// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/Completed.dart';
import 'package:todo_list/TaskCard.dart';
import 'package:todo_list/localDatabase.dart';

// ignore: must_be_immutable
class TaskList extends StatefulWidget {
  Function(int) completed;

  TaskList({Key? superkey, required this.completed}) : super(key: superkey);

  @override
  State<TaskList> createState() => _TaskListState();
}

List taskLists = [];

final todo = Hive.box("ToDo");
localDatabase db = localDatabase();

TextEditingController _description = TextEditingController();
TextEditingController _task = TextEditingController();

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    if (todo.get("TASKLIST") != null) {
      db.loadT();
    }

    super.initState();
  }

  Widget editScreen() {
    List task;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.exit_to_app)),
        title: const Text("New Task"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What is to be done?",
                style: TextStyle(color: Colors.white),
              ),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      maxLength: 30,
                      style: const TextStyle(color: Colors.white),
                      textCapitalization: TextCapitalization.sentences,
                      controller: _task,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.task,
                          color: Colors.white,
                        ),
                        helperStyle: TextStyle(color: Colors.white),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        label: Text("Enter Task Here"),
                        labelStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Describe about the Task",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      maxLength: 150,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _description,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.description_outlined,
                          color: Colors.white,
                        ),
                        helperStyle: TextStyle(color: Colors.white),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        label: Text("Enter the description"),
                        labelStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                    const SizedBox(height: 100),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: RawMaterialButton(
                        shape: const CircleBorder(eccentricity: 0.4),
                        fillColor: const Color.fromRGBO(1, 110, 175, 1),
                        onPressed: () {
                          task = [
                            _task.text.trim(),
                            _description.text.trim(),
                            false
                          ];
                          if (task[0] != "") {
                            Navigator.pop(context, task);
                            _description.clear();
                            _task.clear();
                            Fluttertoast.showToast(msg: "new task added");
                          } else {
                            Fluttertoast.showToast(msg: "no tasks entered");
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emptyScreen() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              height: 150,
              width: 150,
              "assets/fresh.png",
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: RawMaterialButton(
              fillColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.black, size: 50),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => editScreen(),
                  ),
                ).then(
                  (value) {
                    setState(
                      () {
                        (value != null) ? taskLists.add(value) : taskLists;
                        db.updateT();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (taskLists.isEmpty) {
      return emptyScreen();
    }
    db.loadT();
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: taskLists.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: taskLists[index][0],
                  description: taskLists[index][1],
                  isChecked: taskLists[index][2],
                  onChanged: (val) {
                    setState(
                      () {
                        widget.completed.call(index);
                        completedTask.add(List.from(taskLists[index]));
                        taskLists[index][2] = !taskLists[index][2];
                        taskLists.removeAt(index);
                        db.updateT();
                        db.updateC();
                        Fluttertoast.showToast(msg: "task completed");
                      },
                    );
                  },
                  remove: () {
                    setState(() {
                      taskLists.removeAt(index);
                      db.updateT();
                    });
                  },
                  onEdit: (s1, s2) {
                    setState(() {
                      if (s1 != '') {
                        taskLists[index][0] = s1;
                        taskLists[index][1] = s2;
                        db.updateT();
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(msg: "enter a task");
                      }
                    });
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: RawMaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => editScreen(),
                  ),
                ).then(
                  (value) {
                    setState(
                      () {
                        (value != null) ? taskLists.add(value) : taskLists;
                        db.updateT();
                      },
                    );
                  },
                );
              },
              fillColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.black, size: 50),
            ),
          ),
        ],
      ),
    );
  }
}