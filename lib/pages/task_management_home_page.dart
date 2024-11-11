import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskManagementHomePage extends StatefulWidget {
  @override
  _TaskManagementHomePageState createState() => _TaskManagementHomePageState();
}

class _TaskManagementHomePageState extends State<TaskManagementHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Management")),
      body: StreamBuilder(
        stream: _firestore.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var task = snapshot.data!.docs[index];
              return ListTile(
                title: Text(task['taskTitle']),
                subtitle: Text("Due Date: ${task['dueDate']} \nStatus: ${task['status']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editTask(context, task),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteTask(task.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _addTask(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController dueDateController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Task Title")),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
            TextField(controller: dueDateController, decoration: InputDecoration(labelText: "Due Date")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && dueDateController.text.isNotEmpty) {
                await _firestore.collection('tasks').add({
                  'taskTitle': titleController.text,
                  'description': descriptionController.text,
                  'dueDate': dueDateController.text,
                  'status': 'Pending', // Default status
                });
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> _editTask(BuildContext context, QueryDocumentSnapshot task) async {
    TextEditingController titleController = TextEditingController(text: task['taskTitle']);
    TextEditingController descriptionController = TextEditingController(text: task['description']);
    TextEditingController dueDateController = TextEditingController(text: task['dueDate']);
    TextEditingController statusController = TextEditingController(text: task['status']);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Task Title")),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
            TextField(controller: dueDateController, decoration: InputDecoration(labelText: "Due Date")),
            TextField(controller: statusController, decoration: InputDecoration(labelText: "Status")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await _firestore.collection('tasks').doc(task.id).update({
                'taskTitle': titleController.text,
                'description': descriptionController.text,
                'dueDate': dueDateController.text,
                'status': statusController.text,
              });
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTask(String id) async {
    await _firestore.collection('tasks').doc(id).delete();
  }
}
