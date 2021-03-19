import 'package:el_toda/services/category_service.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitle = TextEditingController();
  var _todoDescription = TextEditingController();
  var _todoDate = TextEditingController();
  var _categories = List<DropdownMenuItem> ();
  var _selectedValues;

  @override
  void initState(){
    super.initState();
    _loadCategories();
  }

  _loadCategories() async{
    var _categoryService = CategoryService();
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(child: Text(category["name"]), value: category['name'], ));
      });
    });
  }

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
              hintText: "YY-MM-DD",
              labelText: "YY-MM-DD",
              prefixIcon: Icon(Icons.calendar_today),
            ),
          ),
          DropdownButtonFormField(
              value: _selectedValues,
              items: _categories,
              hint: Text("Select one category"),
              onChanged: (value){
                _selectedValues = value;
              },
          ),

          RaisedButton(onPressed: (){

          },child: Text("Save"),),
        ],
      ),
    );
  }
}
