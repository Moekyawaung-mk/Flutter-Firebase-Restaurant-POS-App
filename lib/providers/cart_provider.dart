```dart
import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/order_item_model.dart';

class CartProvider extends ChangeNotifier {
  final List<OrderItemModel> _items = [];

  List<OrderItemModel> get items => _items;

  void addItem(MenuItemModel item) {
    final index = _items.indexWhere((e) => e.itemId == item.id);
    if (index >= 0) {
      final old = _items[index];
      _items[index] = OrderItemModel(
        id: old.id,
        orderId: old.orderId,
        itemId: old.itemId,
        name: old.name,
        qty: old.qty + 1,
        price: old.price,
        note: old.note,
        status: old.status,
      );
    } else {
      _items.add(
        OrderItemModel(
          id: '',
          orderId: '',
          itemId: item.id,
          name: item.name,
          qty: 1,
          price: item.price,
          note: '',
          status: 'new',
        ),
      );
    }
    notifyListeners();
  }

  void increaseQty(int index) {
    final old = _items[index];
    _items[index] = OrderItemModel(
      id: old.id,
      orderId: old.orderId,
      itemId: old.itemId,
      name: old.name,
      qty: old.qty + 1,
      price: old.price,
      note: old.note,
      status: old.status,
    );
    notifyListeners();
  }

  void decreaseQty(int index) {
    final old = _items[index];
    if (old.qty <= 1) {
      _items.removeAt(index);
    } else {
      _items[index] = OrderItemModel(
        id: old.id,
        orderId: old.orderId,
        itemId: old.itemId,
        name: old.name,
        qty: old.qty - 1,
        price: old.price,
        note: old.note,
        status: old.status,
      );
    }
    notifyListeners();
  }

  void updateNote(int index, String note) {
    final old = _items[index];
    _items[index] = OrderItemModel(
      id: old.id,
      orderId: old.orderId,
      itemId: old.itemId,
      name: old.name,
      qty: old.qty,
      price: old.price,
      note: note,
      status: old.status,
    );
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  int get total => _items.fold(0, (sum, item) => sum + item.qty * item.price);

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
```
