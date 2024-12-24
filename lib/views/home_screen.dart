import 'package:flutter/material.dart';
import '../models/todolist.dart';
import 'task_form_screen.dart';
import '../services/opertaion_database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todolist> tasks = []; // Liste des tâches

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Charger les tâches au démarrage
  }

  Future<void> _loadTasks() async {
    final data = await TodoOperations().getAllTasks();
    setState(() {
      tasks = data;
    });
  }

  Future<void> _deleteTask(String id) async {
    await TodoOperations().deleteTask(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tâche supprimée avec succès !')),
    );
    _loadTasks(); // Recharger la liste après suppression
  }

  void _openTaskForm({Todolist? task}) async {
    // Naviguer vers le formulaire d'ajout ou de modification
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );
    _loadTasks(); // Recharger les tâches après retour du formulaire
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ma To-Do List'),
      ),
      body: tasks.isEmpty
          ? Center(child: Text('Aucune tâche pour le moment'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _openTaskForm(task: task); // Modifier la tâche
                      } else if (value == 'delete') {
                        _deleteTask(task.id); // Supprimer la tâche
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Modifier'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Supprimer'),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Optionnel : Afficher les détails de la tâche
                    _openTaskForm(task: task);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskForm(), // Ajouter une nouvelle tâche
        child: Icon(Icons.add),
      ),
    );
  }
}
