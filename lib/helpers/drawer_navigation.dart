import 'package:el_toda/screens/categories_screen.dart';
import 'package:el_toda/screens/home_screen.dart';
import 'package:el_toda/screens/todos_by_category.dart';
import 'package:el_toda/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:el_toda/screens/home_screen.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList = List<Widget>();
  CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.getCategories();
    categories.foreach((category) {
      setState(() {
        _categoryList.add(InkWell(
          onTap: (){
            Navigator.push(context, new MaterialPageRoute(builder: (context) =>  TodosByCategory(category: category['name'])));
          },
            child: ListTile(
          title: Text(category['name']),
        )));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("El Todo"),
              accountEmail: Text("Category & Privacy based Todo App"),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new HomeScreen()));
              },
            ),
            ListTile(
              title: Text("Categories"),
              leading: Icon(Icons.view_list),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new CategoriesScreen()));
              },
            ),
            Divider(),
            Column(
              children: _categoryList,
            ),
          ],
        ),
      ),
    );
  }
}
