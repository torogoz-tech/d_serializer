// Example: Complete Polymorphic Union Workflow with JSON examples
//
// This file demonstrates how @SerializableUnion works with real JSON data.
// Run: dart run example/union_examples.dart

import 'dart:convert';

// ============================================
// E-COMMERCE PAYMENT SYSTEM EXAMPLE
// ============================================

// Here are example JSON payloads you would receive from an API:

// CARD PAYMENT JSON:
const String cardPaymentJson = '''
{
  "method": "card",
  "cardNumber": "**** **** **** 4242",
  "last4": "4242",
  "brand": "Visa",
  "expiryMonth": 12,
  "expiryYear": 2027
}''';

// PAYPAL PAYMENT JSON:
const String paypalPaymentJson = '''
{
  "method": "paypal",
  "email": "user@example.com",
  "payerId": "PAYER-12345",
  "verifiedAccount": true
}''';

// BANK TRANSFER JSON:
const String bankTransferJson = '''
{
  "method": "bank_transfer",
  "bankName": "Chase",
  "accountNumber": "****5678",
  "routingNumber": "021000021",
  "accountHolderName": "John Doe"
}''';

// ============================================
// EVENT ANALYTICS EXAMPLE
// ============================================

// PAGE VIEW EVENT JSON:
const String pageViewJson = '''
{
  "event_type": "page_view",
  "pageUrl": "/products/123",
  "referrer": "https://google.com",
  "deviceType": "mobile"
}''';

// PURCHASE EVENT JSON (with nested items):
const String purchaseJson = '''
{
  "event_type": "purchase",
  "orderId": "ORD-2026-001",
  "totalAmount": 129.99,
  "currency": "USD",
  "items": [
    {
      "productId": "PROD-001",
      "productName": "Wireless Headphones",
      "quantity": 1,
      "unitPrice": 79.99
    },
    {
      "productId": "PROD-002",
      "productName": "Phone Case",
      "quantity": 2,
      "unitPrice": 24.99
    }
  ]
}''';

// ERROR EVENT JSON:
const String errorJson = '''
{
  "event_type": "error",
  "errorCode": "E500",
  "message": "Failed to process payment",
  "severity": "critical"
}''';

// CUSTOM EVENT JSON:
const String customJson = '''
{
  "event_type": "custom",
  "eventName": "feature_flag_tested",
  "properties": {
    "flag_name": "new_checkout_v2",
    "enabled": true,
    "user_segment": "beta_testers"
  }
}''';

// ============================================
// MODEL DEFINITIONS (Copy to your project)
// ============================================
/*
// Models with @SerializableUnion and @Serializable(discriminator: ...)

import 'package:d_serializer/d_serializer.dart';
part 'models.g.dart';

@SerializableUnion(typeField: 'method')
sealed class PaymentMethod {
  const PaymentMethod();
}

@Serializable(discriminator: 'card')
class CardPayment extends PaymentMethod {
  final String cardNumber;
  final String last4;
  final String brand;
  final int expiryMonth;
  final int expiryYear;

  const CardPayment({
    required this.cardNumber,
    required this.last4,
    required this.brand,
    required this.expiryMonth,
    required this.expiryYear,
  });
}

@Serializable(discriminator: 'paypal')
class PayPalPayment extends PaymentMethod {
  final String email;
  final String payerId;
  final bool verifiedAccount;

  const PayPalPayment({
    required this.email,
    required this.payerId,
    required this.verifiedAccount,
  });
}

@Serializable(discriminator: 'bank_transfer')
class BankTransferPayment extends PaymentMethod {
  final String bankName;
  final String accountNumber;
  final String routingNumber;
  final String accountHolderName;

  const BankTransferPayment({
    required this.bankName,
    required this.accountNumber,
    required this.routingNumber,
    required this.accountHolderName,
  });
}

// Usage with API response handling:
void handlePaymentResponse(String jsonString) {
  initializeDSerializer();
  
  final payment = Serializer.fromJson<PaymentMethod>(jsonString);
  
  switch (payment) {
    case CardPayment():
      print('Processing card: ${payment.brand} ****${payment.last4}');
    case PayPalPayment():
      print('Processing PayPal: ${payment.email}');
    case BankTransferPayment():
      print('Processing bank: ${payment.bankName}');
  }
}
*/

// ============================================
// DEMONSTRATION
// ============================================

void main() {
  print('╔════════════════════════════════════════════════════════════════╗');
  print('║     Polymorphic Union - JSON Examples for @SerializableUnion   ║');
  print('╚════════════════════════════════════════════════════════════════╝\n');

  print('═══════════════════════════════════════════════════════════════════');
  print('PAYMENT SYSTEM EXAMPLES');
  print('═══════════════════════════════════════════════════════════════════\n');

  print('1. CARD PAYMENT:');
  print('   Discriminator field: "method"');
  print('   Discriminator value: "card"');
  print('\n   JSON Received:');
  print('   $cardPaymentJson\n');

  print('2. PAYPAL PAYMENT:');
  print('   Discriminator field: "method"');
  print('   Discriminator value: "paypal"');
  print('\n   JSON Received:');
  print('   $paypalPaymentJson\n');

  print('3. BANK TRANSFER:');
  print('   Discriminator field: "method"');
  print('   Discriminator value: "bank_transfer"');
  print('\n   JSON Received:');
  print('   $bankTransferJson\n');

  print('═══════════════════════════════════════════════════════════════════');
  print('EVENT ANALYTICS EXAMPLES');
  print('═══════════════════════════════════════════════════════════════════\n');

  print('4. PAGE VIEW EVENT:');
  print('   Discriminator field: "event_type"');
  print('   Discriminator value: "page_view"');
  print('\n   JSON Received:');
  print('   $pageViewJson\n');

  print('5. PURCHASE EVENT (with nested items):');
  print('   Discriminator field: "event_type"');
  print('   Discriminator value: "purchase"');
  print('\n   JSON Received:');
  print('   $purchaseJson\n');

  print('6. ERROR EVENT:');
  print('   Discriminator field: "event_type"');
  print('   Discriminator value: "error"');
  print('\n   JSON Received:');
  print('   $errorJson\n');

  print('7. CUSTOM EVENT (with dynamic properties):');
  print('   Discriminator field: "event_type"');
  print('   Discriminator value: "custom"');
  print('\n   JSON Received:');
  print('   $customJson\n');

  print('═══════════════════════════════════════════════════════════════════');
  print('HOW IT WORKS');
  print('═══════════════════════════════════════════════════════════════════\n');

  print('''
1. DEFINE UNION ROOT:
   @SerializableUnion(typeField: 'method')
   sealed class PaymentMethod {
     const PaymentMethod();
   }

2. ANNOTATE SUBTYPES WITH DISCRIMINATOR:
   @Serializable(discriminator: 'card')
   class CardPayment extends PaymentMethod { ... }

   @Serializable(discriminator: 'paypal')
   class PayPalPayment extends PaymentMethod { ... }

3. GENERATE CODE:
   dart run build_runner build --delete-conflicting-outputs

4. INITIALIZE AND USE:
   initializeDSerializer();
   final payment = Serializer.fromJson<PaymentMethod>(apiResponse);
   
   // Dart's exhaustive switch handles all cases:
   switch (payment) {
     case CardPayment(): ...
     case PayPalPayment(): ...
     case BankTransferPayment(): ...
   }
''');

  print('═══════════════════════════════════════════════════════════════════');
  print('KEY POINTS');
  print('═══════════════════════════════════════════════════════════════════\n');

  print('''
• The discriminator field ("method", "event_type") is included in EVERY JSON
• Each subtype has a unique discriminator value ("card", "paypal", etc.)
• Deserialization automatically resolves the correct type based on discriminator
• Works with sealed classes for exhaustive pattern matching
• Supports nested objects, lists, and dynamic properties

To use these examples:
1. Copy the model definitions from the comments above
2. Run build_runner to generate .g.dart files
3. Initialize with initializeDSerializer()
4. Use Serializer.fromJson<T>() for automatic type resolution
''');
}