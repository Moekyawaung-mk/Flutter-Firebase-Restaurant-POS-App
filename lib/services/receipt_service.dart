```dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptService {
  Future<void> printReceipt({
    required String restaurantName,
    required String tableName,
    required String orderId,
    required int subtotal,
    required int discount,
    required int taxAmount,
    required int grandTotal,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (_) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    restaurantName,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text('Order ID: $orderId'),
                pw.Text('Table: $tableName'),
                pw.Divider(),
                ...items.map(
                  (item) => pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Text('${item['name']} x ${item['qty']}'),
                      ),
                      pw.Text('${item['price'] * item['qty']} MMK'),
                    ],
                  ),
                ),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [pw.Text('Subtotal'), pw.Text('$subtotal MMK')],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [pw.Text('Discount'), pw.Text('$discount MMK')],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [pw.Text('Tax'), pw.Text('$taxAmount MMK')],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Grand Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('$grandTotal MMK',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Text('Payment: $paymentMethod'),
                pw.SizedBox(height: 20),
                pw.Center(child: pw.Text('Thank you')),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
```
