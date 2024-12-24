import 'package:sqflite/sqflite.dart';
import '../models/todolist.dart';
import 'database_helper.dart';
class TodoOperations {
  final DatabaseConfig _dbConfig = DatabaseConfig();

  // Ajouter une tâche
  Future<int> insertTask(Todolist task) async {
    final db = await _dbConfig.database;
    return await db.insert('tasks', {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'date': task.date,
      'time': task.time,
      'status': task.status,
    });
  }

  // Récupérer toutes les tâches
  Future<List<Todolist>> getAllTasks() async {
    final db = await _dbConfig.database;
    final data = await db.query('tasks');
    return data.map((task) => Todolist.fromJson(task)).toList();
  }

  // Mettre à jour une tâche
  Future<int> updateTask(Todolist task) async {
    final db = await _dbConfig.database;
    return await db.update(
      'tasks',
      {
        'title': task.title,
        'description': task.description,
        'date': task.date,
        'time': task.time,
        'status': task.status,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Supprimer une tâche
  Future<int> deleteTask(String id) async {
    final db = await _dbConfig.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
