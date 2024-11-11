import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new item to Firestore
  Future<void> addItem(String name, String description) async {
    await _db.collection('inventory').add({
      'name': name,
      'description': description,
      'createdAt': Timestamp.now(),
    });
  }

  // Update an existing item
  Future<void> updateItem(String id, String name, String description) async {
    await _db.collection('inventory').doc(id).update({
      'name': name,
      'description': description,
      'updatedAt': Timestamp.now(),
    });
  }

  // Delete an item
  Future<void> deleteItem(String id) async {
    await _db.collection('inventory').doc(id).delete();
  }

  // Fetch items in real-time
  Stream<List<Map<String, dynamic>>> getItems() {
    return _db.collection('inventory')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {
              'id': doc.id,
              'name': doc['name'],
              'description': doc['description']
            }).toList());
  }
}
