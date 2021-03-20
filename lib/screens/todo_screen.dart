import 'package:el_toda/models/todo.dart';
import 'package:el_toda/services/category_service.dart';
import 'package:el_toda/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:el_toda/services/category_service.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitle = TextEditingController();
  var _todoDescription = TextEditingController();
  var _todoDate = TextEditingController();
  var _categories = List<DropdownMenuItem>();
  var _selectedValues;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category["name"]),
          value: category['name'],
        ));
      });
    });
  }

  DateTime _date = DateTime.now();

  _selectTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
    if (_pickedDate != null) {
      setState(() {
        _date = _pickedDate;
        _todoDate.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  // _showSnackBar(message) {
  //   var _snackBar = SnackBar(
  //     content: message,
  //   );
  //   _scaffoldKey.currentState.showSnackBar(_snackBar);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Todo"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _todoTitle,
            decoration: InputDecoration(
              hintText: "Todo title",
              labelText: "Cook food",
            ),
          ),
          TextField(
            controller: _todoDescription,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Todo description",
              labelText: "Cook rice and curry",
            ),
          ),
          TextField(
            controller: _todoDate,
            decoration: InputDecoration(
              hintText: "YYYY-MM-DD",
              labelText: "YYYY-MM-DD",
              prefixIcon: InkWell(
                  onTap: () {
                    _selectTodoDate(context);
                  },
                  child: Icon(Icons.calendar_today)),
            ),
          ),
          DropdownButtonFormField(
            value: _selectedValues,
            items: _categories,
            hint: Text("Select one category"),
            onChanged: (value) {
              _selectedValues = value;
            },
          ),
          RaisedButton(
            onPressed: () async {

                var todoObj = Todo ();
                todoObj.title = _todoTitle.text;
                todoObj.description = _todoDescription.text;
                todoObj.todoDate = _todoDate.text;
                todoObj.category = _selectedValues as String;
                todoObj.isFinished = 0;

                var _todoService = TodoService();
                var result = _todoService.insertTodo(todoObj);
                print(result);

                //if(result > 0){
                 // _showSnackBar(Text('Success'));
                //}


            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
