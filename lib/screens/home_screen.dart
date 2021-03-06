import 'package:el_toda/helpers/drawer_navigation.dart';
import 'package:el_toda/models/todo.dart';
import 'package:el_toda/screens/todo_screen.dart';
import 'package:el_toda/services/todo_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService;
  List<Todo> _todoList = List<Todo>();

  @override
  void initState(){
    super.initState();
    getAllTodos();
  }

  getAllTodos () async {
    _todoService = TodoService();
    _todoList = List<Todo>();
    var todos = await _todoService.getTodos();
    todos.forEach((todo){
      var model = Todo();
      setState(() {
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['category'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("El Todo"),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_todoList[index].title ?? "No title"),
                ],
              ),
            ),
          );
        }
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => TodoScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
