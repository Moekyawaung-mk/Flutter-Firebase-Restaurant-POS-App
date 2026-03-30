```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dining_table.dart';

class TableService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<DiningTable>> getTables(String restaurantId) {
    return _db
        .collection('tables')
        .where('restaurantId', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DiningTable.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateTableStatus(String tableId, String status) async {
    await _db.collection('tables').doc(tableId).update({
      'status': status,
    });
  }
}
```
