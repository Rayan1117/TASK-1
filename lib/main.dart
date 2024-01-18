import "package:flutter/material.dart";
import "package:hive_flutter/adapters.dart";
import "package:todo_list/Completed.dart";
import "package:todo_list/TaskList.dart";

void main() async {
  await Hive.initFlutter();

  // ignore: unused_local_variable
  var data = await Hive.openBox("ToDo");

  runApp(const ToDo());
}

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
    final buttonBar = BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.task_rounded), label: "Tasks"),
        BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_rounded), label: "Completed")
      ],
      currentIndex: currIndex,
      onTap: (int i) {
        setState(
          () {
            currIndex = i;
          },
        );
      },
      type: BottomNavigationBarType.fixed,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardColor: const Color.fromRGBO(255, 255, 255, 0.950),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(0, 56, 99, 1),
        appBarTheme: const AppBarTheme(
          titleTextStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          color: Color.fromRGBO(1, 110, 175, 1),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.today_outlined,
            color: Colors.white,
          ),
          title: const Text("Todo list"),
        ),
        body: (currIndex == 0)
            ? TaskList(
                completed: (v) {},
              )
            : const Completed(),
        bottomNavigationBar: buttonBar,
      ),
    );
  }
}