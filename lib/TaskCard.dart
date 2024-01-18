// ignore_for_file: file_names

import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:fluttertoast/fluttertoast.dart";

// ignore: must_be_immutable
class TaskCard extends StatelessWidget {
  final String task;
  final String description;
  Function(bool?)? onChanged;
  final bool isChecked;
  VoidCallback remove;
  Function(String, String) onEdit;

  TaskCard(
      {super.key,
      required this.task,
      required this.description,
      required this.isChecked,
      required this.onChanged,
      required this.remove,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final TextEditingController editedTask = TextEditingController(text: task);
    final TextEditingController editedDesc =
        TextEditingController(text: description);

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          TextFormField(
                            maxLength: 30,
                            controller: editedTask,
                            decoration: const InputDecoration(
                                counterText: '',
                                label: Text("Task"),
                                hintText: "edit your task"),
                          ),
                          TextFormField(
                            maxLength: 150,
                            controller: editedDesc,
                            decoration: const InputDecoration(
                                counterText: '',
                                label: Text("Description"),
                                hintText: "edit your description"),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          OutlinedButton(
                              onPressed: () {
                                onEdit.call(editedTask.text.trim(),
                                    editedDesc.text.trim());
                                editedTask.clear();
                                editedDesc.clear();
                              },
                              child: const Text("save"))
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              remove.call();
              Fluttertoast.showToast(msg: "task deleted");
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: onChanged,
                  ),
                  Text(
                    task,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const Divider(
                thickness: 0,
                endIndent: Checkbox.width,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}