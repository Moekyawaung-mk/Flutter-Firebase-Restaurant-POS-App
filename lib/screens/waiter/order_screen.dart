```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_language.dart';
import '../../models/dining_table.dart';
import '../../models/menu_item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/menu_service.dart';
import '../../services/order_service.dart';

class OrderScreen extends StatefulWidget {
  final DiningTable table;

  const OrderScreen({super.key, required this.table});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final MenuService _menuService = MenuService();
  final OrderService _orderService = OrderService();

  Future<void> editNote(int index) async {
    final cart = context.read<CartProvider>();
    final controller = TextEditingController(text: cart.items[index].note);

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Item Note'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      cart.updateNote(index, result);
    }
  }

  Future<void> submitOrder() async {
    final user = context.read<AuthProvider>().currentUser!;
    final cart = context.read<CartProvider>();

    if (cart.items.isEmpty) return;

    await _orderService.createOrder(
      restaurantId: user.restaurantId,
      tableId: widget.table.id,
      createdBy: user.uid,
      items: cart.items,
    );

    cart.clear();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order submitted')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser!;
    final cart = context.watch<CartProvider>();
    final t = AppLanguage.t;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.table.name} Order')),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: StreamBuilder<List<MenuItemModel>>(
              stream: _menuService.getMenuItems(user.restaurantId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = snapshot.data!;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text('${item.price} MMK'),
                        trailing: ElevatedButton(
                          onPressed: () => cart.addItem(item),
                          child: Text(t('add')),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    t('cart'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (_, index) {
                        final item = cart.items[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('Qty: ${item.qty}'),
                                Text('Price: ${item.price} MMK'),
                                Text('Note: ${item.note.isEmpty ? '-' : item.note}'),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => cart.decreaseQty(index),
                                      icon: const Icon(Icons.remove_circle),
                                    ),
                                    IconButton(
                                      onPressed: () => cart.increaseQty(index),
                                      icon: const Icon(Icons.add_circle),
                                    ),
                                    IconButton(
                                      onPressed: () => editNote(index),
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () => cart.removeAt(index),
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text('${t('total')}: ${cart.total} MMK'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: submitOrder,
                          child: Text(t('submit_order')),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

