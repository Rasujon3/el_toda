import 'package:el_toda/models/category.dart';
import 'package:el_toda/repositories/repository.dart';

class CategoryService {

  Repository _repository;

  CategoryService(){
    _repository = Repository();
  }



saveCategory(Category category) async{
  return  await _repository.save('categories', category.categoryMap());

  //print(category.name);
}
}