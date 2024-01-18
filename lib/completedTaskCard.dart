// ignore_for_file: file_names, non_constant_identifier_names

import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";

// ignore: must_be_immutable, camel_case_types
class completedTaskCard extends StatefulWidget {
  final String task;
  final String description;
  final VoidCallback onLongPress;
  final Function(bool?)? onChanged;

  const completedTaskCard(
      {super.key,
      required this.task,
      required this.description,
      required this.onLongPress,
      required this.onChanged});

  @override
  State<completedTaskCard> createState() => _completedTaskCardState();
}

// ignore: camel_case_types
class _completedTaskCardState extends State<completedTaskCard> {
  @override
  Widget build(BuildContext context) {
    bool? value = true;
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Checkbox(
            value: value,
            onChanged: (val) {
              widget.onChanged!.call(val);
            },
          )
        ],
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        splashColor: const Color.fromRGBO(0, 56, 99, 1),
        onLongPress: widget.onLongPress,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.check),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.task,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 0,
                  endIndent: Checkbox.width,
                  color: Colors.black,
                ),
                Text(widget.description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}