```dart
class BillingHelper {
  static Map<String, int> calculate({
    required int subtotal,
    required int discount,
    required int taxPercent,
  }) {
    final safeDiscount = discount > subtotal ? subtotal : discount;
    final afterDiscount = subtotal - safeDiscount;
    final taxAmount = ((afterDiscount * taxPercent) / 100).round();
    final grandTotal = afterDiscount + taxAmount;

    return {
      'subtotal': subtotal,
      'discount': safeDiscount,
      'taxAmount': taxAmount,
      'grandTotal': grandTotal,
    };
  }
}
```
