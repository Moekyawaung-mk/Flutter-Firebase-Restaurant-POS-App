```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/helpers/billing_helper.dart';
import '../../providers/auth_provider.dart';
import '../../services/order_service.dart';
import '../../services/payment_service.dart';
import '../../services/receipt_service.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser!;
    final orderService = OrderService();

    return Scaffold(
      appBar: AppBar(title: const Text('Billing')),
      body: StreamBuilder(
        stream: orderService.getOpenOrders(user.restaurantId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('No open orders'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Order ${order['id']}'),
                  subtitle: Text(
                    'Table: ${order['tableId']} | Total: ${order['total']} MMK | Status: ${order['status']}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _showPaymentDialog(
                      context: context,
                      order: order,
                    ),
                    child: const Text('Pay'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showPaymentDialog({
    required BuildContext context,
    required Map<String, dynamic> order,
  }) async {
    final user = context.read<AuthProvider>().currentUser!;
    final paymentService = PaymentService();
    final orderService = OrderService();
    final receiptService = ReceiptService();

    final discountController = TextEditingController(text: '0');
    final taxController = TextEditingController(text: '5');
    String paymentMethod = 'cash';

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final subtotal = order['total'] as int;
            final discount = int.tryParse(discountController.text) ?? 0;
            final taxPercent = int.tryParse(taxController.text) ?? 0;

            final calc = BillingHelper.calculate(
              subtotal: subtotal,
              discount: discount,
              taxPercent: taxPercent,
            );

            return AlertDialog(
              title: const Text('Payment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Subtotal: ${calc['subtotal']} MMK'),
                  TextField(
                    controller: discountController,
                    decoration: const InputDecoration(labelText: 'Discount'),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                  TextField(
                    controller: taxController,
                    decoration: const InputDecoration(labelText: 'Tax %'),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                  DropdownButton<String>(
                    value: paymentMethod,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'kbzpay', child: Text('KBZPay')),
                      DropdownMenuItem(value: 'wavepay', child: Text('WavePay')),
                      DropdownMenuItem(value: 'card', child: Text('Card')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => paymentMethod = value);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Text('Tax Amount: ${calc['taxAmount']} MMK'),
                  Text(
                    'Grand Total: ${calc['grandTotal']} MMK',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await paymentService.makePayment(
                      restaurantId: user.restaurantId,
                      orderId: order['id'],
                      tableId: order['tableId'],
                      subtotal: calc['subtotal']!,
                      discount: calc['discount']!,
                      taxAmount: calc['taxAmount']!,
                      grandTotal: calc['grandTotal']!,
                      method: paymentMethod,
                    );

                    final items = await orderService.getOrderItems(
                      user.restaurantId,
                      order['id'],
                    );

                    await receiptService.printReceipt(
                      restaurantName: 'ABC Restaurant',
                      tableName: order['tableId'],
                      orderId: order['id'],
                      subtotal: calc['subtotal']!,
                      discount: calc['discount']!,
                      taxAmount: calc['taxAmount']!,
                      grandTotal: calc['grandTotal']!,
                      paymentMethod: paymentMethod,
                      items: items,
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment successful')),
                      );
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
```
