import 'package:el_toda/models/category.dart';
import 'package:el_toda/screens/home_screen.dart';
import 'package:el_toda/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _formKey = GlobalKey<FormState>();

  var _categoryName = TextEditingController();
  var _categoryDescription = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        var model = Category();
        model.name = category['name'];
        _categoryList.add(model);
        //print(category['description']);
      });

    });
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () async {
                  //print("Category name : ${_categoryName.text}");
                  //print("Category description : ${_categoryDescription.text}");

                  _category.name = _categoryName.text;
                  _category.description = _categoryDescription.text;

                  var result = await _categoryService.saveCategory(_category);
                  print(result);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new CategoriesScreen()));
                },
                child: Text("Save"),
              ), //save
              FlatButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => CategoriesScreen()));
                },
                child: Text("Cancel"),
              ), //cancel
            ],
            title: Text('Category form'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _categoryName,
                    decoration: InputDecoration(
                      labelText: 'Category name',
                      hintText: 'Write category name',
                    ),
                  ),
                  TextField(
                    controller: _categoryDescription,
                    decoration: InputDecoration(
                      labelText: 'Category description',
                      hintText: 'Write category description',
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("El Todo"),
        leading: RaisedButton(
          elevation: 0.0,
          color: Colors.red,
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => new HomeScreen()));
          },
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: List.generate(_categoryList.length, (index) {
          return Column(
            children: [

            Card(
              child: ListTile(
                leading: IconButton(icon: Icon(Icons.edit),onPressed: (){},),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _categoryList[index].name,
                    ),
                    IconButton(icon: Icon(Icons.delete),onPressed: (){},),
                  ],
                ),
              ),
            ),

            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
