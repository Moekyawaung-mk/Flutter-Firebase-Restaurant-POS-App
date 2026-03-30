```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';

class MenuService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<MenuItemModel>> getMenuItems(String restaurantId) {
    return _db
        .collection('menu_items')
        .where('restaurantId', isEqualTo: restaurantId)
        .where('available', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MenuItemModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
```

