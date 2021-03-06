import 'package:el_toda/models/todo.dart';
import 'package:el_toda/repositories/repository.dart';

class TodoService {
  Repository _repository;

  TodoService () {
    _repository = Repository();
  }

  insertTodo(Todo todo) async {
    return await _repository.save('todos', todo.todoMap());
  }

  getTodos() async {
    return await _repository.getAll('todos');
  }

  todosByCategory(String category) async {
    return await _repository.getColumnName('todos', 'category', category);
  }

}