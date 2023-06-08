import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.orange,
    ),
  ),
  home: MyApp(),
));

class TodoItem {
  String name;
  IconData? icon;
  bool isCompleted;

  TodoItem(this.name, this.icon, {this.isCompleted = false});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<TodoItem> todos = [];
  String input = "";
  IconData? selectedIcon;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    todos.add(TodoItem("Item1", Icons.check_circle));
    todos.add(TodoItem("Item2", Icons.star));
    todos.add(TodoItem("Item3", Icons.check_circle));
    todos.add(TodoItem("Item4", Icons.star));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("mytodos"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Add Todolist"),
                content: Column(
                  children: [
                    TextField(
                      onChanged: (String value) {
                        setState(() {
                          input = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Select Icon"),
                              content: Wrap(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: selectedIcon == Icons.check_circle
                                          ? Colors.orange
                                          : null,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectedIcon = Icons.check_circle;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.star,
                                      color: selectedIcon == Icons.star
                                          ? Colors.orange
                                          : null,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectedIcon = Icons.star;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  // Add more icon selection buttons as needed
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text("Select Icon"),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        todos.add(TodoItem(input, selectedIcon));
                        input = '';
                        selectedIcon = null;
                        updateProgress();
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(todos[index].name),
                  onDismissed: (direction) {
                    setState(() {
                      todos.removeAt(index);
                      updateProgress();
                    });
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: todos[index].isCompleted ? Colors.grey : Colors.white,
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(
                          todos[index].icon,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            todos[index].isCompleted = !todos[index].isCompleted;
                            updateProgress();
                          });
                        },
                      ),
                      title: Center(
                        child: Text(todos[index].name),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            todos.removeAt(index);
                            updateProgress();
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void updateProgress() {
    int completedCount = todos.where((todo) => todo.isCompleted).length;
    double newProgress = completedCount / todos.length;
    setState(() {
      progress = newProgress;
    });
  }
}
