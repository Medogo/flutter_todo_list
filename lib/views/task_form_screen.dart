import 'package:flutter/material.dart';
import '../models/todolist.dart';
import '../services/opertaion_database.dart';
import 'package:intl/intl.dart';

class TaskFormScreen extends StatefulWidget {
  final Todolist? task; // Si non null, c'est une tâche existante à modifier

  const TaskFormScreen({super.key, this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  String? _date;
  String? _time;
  String _status = 'En cours'; // Statut par défaut

  @override
  void initState() {
    super.initState();
    // Si on modifie une tâche, pré-remplir les champs
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _date = widget.task!.date;
      _time = widget.task!.time;
      _status = widget.task!.status;
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Sauvegarde les valeurs du formulaire

      final newTask = Todolist(
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(), // Utiliser un ID existant ou en générer un
        title: _title!,
        description: _description ?? '',
        date: _date ?? '',
        time: _time ?? '',
        status: _status,
      );

      if (widget.task == null) {
        await TodoOperations().insertTask(newTask); // Ajouter une nouvelle tâche
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tâche ajoutée avec succès !')),
        );
      } else {
        await TodoOperations().updateTask(newTask); // Mettre à jour une tâche existante
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tâche mise à jour avec succès !')),
        );
      }

      Navigator.of(context).pop(); // Retourner à l'écran précédent
    }
  }

  void _pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _date != null ? DateTime.parse(_date!) : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _date = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  void _pickTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _time != null
          ? TimeOfDay(
              hour: int.parse(_time!.split(':')[0]),
              minute: int.parse(_time!.split(':')[1]),
            )
          : TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        _time = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Ajouter une tâche' : 'Modifier la tâche'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Champ titre
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(labelText: 'Titre'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le titre est obligatoire';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value,
                ),

                // Champ description
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  onSaved: (value) => _description = value,
                ),

                // Sélecteur de date
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(text: _date),
                  onTap: _pickDate,
                ),

                // Sélecteur d'heure
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Heure',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  controller: TextEditingController(text: _time),
                  onTap: _pickTime,
                ),

                // Statut
                DropdownButtonFormField<String>(
                  value: _status,
                  items: ['En cours', 'Terminé']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Statut'),
                ),

                SizedBox(height: 20),

                // Bouton de sauvegarde
                ElevatedButton(
                  onPressed: _saveTask,
                  child: Text(widget.task == null ? 'Ajouter' : 'Mettre à jour'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
