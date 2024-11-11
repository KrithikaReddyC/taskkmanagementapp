import 'package:flutter/material.dart';
import '../firestore_service.dart';

class EditItemPage extends StatelessWidget {
  final String id;
  final String name;
  final String description;

  EditItemPage({required this.id, required this.name, required this.description});

  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = name;
    _descriptionController.text = description;

    return Scaffold(
      appBar: AppBar(title: Text("Edit Item")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Item Name"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Update Item"),
              onPressed: () {
                _firestoreService.updateItem(
                  id,
                  _nameController.text,
                  _descriptionController.text,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
