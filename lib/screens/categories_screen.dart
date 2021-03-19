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

  var _editCategoryName = TextEditingController();
  var _editCategoryDescription= TextEditingController();

  var category;

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        var model = Category();
        model.name = category['name'];
        model.id = category['id'];
        model.description = category['description'];
        _categoryList.add(model);
        //print(category['description']);
      });

    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                  if(result > 0){
                    Navigator.of(context).pop(context);
                  }

                  print(result);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new CategoriesScreen()));
                },
                child: Text("Save"),
              ), //save
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(context);
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


  _editCategoryDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () async {
                  _category.id = category[0]['id'];

                  _category.name = _editCategoryName.text;
                  _category.description = _editCategoryDescription.text;

                  var result = await _categoryService.updateCategory(_category);
                  //print(result);
                  if(result > 0){
                    //Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>CategoriesScreen()));
                  Navigator.pop(context);
                    getAllCategories();
                    _showSnackBar(Text("Updated Successfully"));
                  }
                },
                child: Text("Update"),
              ), //update
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(context);
                },
                child: Text("Cancel"),
              ), //cancel
            ],
            title: Text('Edit Category form'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _editCategoryName,
                    decoration: InputDecoration(
                      labelText: 'Category name',
                      hintText: 'Write category name',
                    ),
                  ),
                  TextField(
                    controller: _editCategoryDescription,
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


  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.getCategoriesById(categoryId);
    setState(() {
      _editCategoryName.text = category[0]['name'] ?? 'No name' ;
      _editCategoryDescription.text = category[0]['description'] ?? 'No description' ;
    });
    _editCategoryDialog(context);
  }

  _showSnackBar(message) {
    var _snackBar = SnackBar(
        content: message,
    );
    _scaffoldKey.currentState.showSnackBar(_snackBar);
  }


  _deleteCategoryDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () async {
                  var result = await _categoryService.deleteCategory(categoryId);
                  if(result > 0){
                    //Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>CategoriesScreen()));
                    Navigator.pop(context);
                    getAllCategories();
                    _showSnackBar(Text("Category Deleted Successfully"));
                  }

                },
                color: Colors.red,
                child: Text("Delete",style: TextStyle(color: Colors.white),),
              ), //update
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(context);
                },
                color: Colors.green,
                child: Text("Cancel",style: TextStyle(color: Colors.white),),
              ), //cancel
            ],
            title: Text('Are you sure to delete this category?'),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index){
            return Card(
              child: ListTile(
                leading: IconButton(icon: Icon(Icons.edit),onPressed: (){
                  _editCategory(context, _categoryList[index].id);
                },),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _categoryList[index].name,
                    ),
                    IconButton(icon: Icon(Icons.delete),onPressed: (){
                      _deleteCategoryDialog(context, _categoryList[index].id);
                    },),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
