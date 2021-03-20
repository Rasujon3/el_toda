import 'package:el_toda/models/todo.dart';
import 'package:el_toda/services/todo_service.dart';
import 'package:flutter/material.dart';

class TodosByCategory extends StatefulWidget {
  final String category;
  TodosByCategory({this.category});
  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {

  List<Todo> _todoList = List<Todo>();
  TodoService _todoService = TodoService();

  getTodosByCategory() async{
    var todos = _todoService.todosByCategory(this.widget.category);
    todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.title = todo['title'];
        _todoList.add(model);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTodosByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos By Category"),
      ),
      body: Column(
        children: [
          Text(this.widget.category),
          Expanded(
              child: ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: (context,index){
                    return Text(_todoList[index].title);
                  })),
        ],
      ),
    );
  }
}
