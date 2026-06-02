import 'package:d_serializer/d_serializer.dart';
import 'package:test/test.dart';

abstract class PaymentMethod {}

class CardPayment extends PaymentMethod {
  CardPayment(this.last4);
  final String last4;
}

class PaypalPayment extends PaymentMethod {
  PaypalPayment(this.email);
  final String email;
}

void registerUnionFixtures() {
  Serializer.register<CardPayment>(
    fromJson: (Map<String, dynamic> json) => CardPayment(json['last4'] as String),
    toJson: (CardPayment value) => <String, dynamic>{
      'type': 'card',
      'last4': value.last4,
    },
  );

  Serializer.register<PaypalPayment>(
    fromJson: (Map<String, dynamic> json) => PaypalPayment(json['email'] as String),
    toJson: (PaypalPayment value) => <String, dynamic>{
      'type': 'paypal',
      'email': value.email,
    },
  );

  Serializer.registerUnion<PaymentMethod>(
    typeField: 'type',
    discriminator: 'card',
    fromJson: (Map<String, dynamic> json) => CardPayment(json['last4'] as String),
  );

  Serializer.registerUnion<PaymentMethod>(
    typeField: 'type',
    discriminator: 'paypal',
    fromJson: (Map<String, dynamic> json) => PaypalPayment(json['email'] as String),
  );
}

void main() {
  setUpAll(registerUnionFixtures);

  test('fromJson resolves union subtype using discriminator', () {
    final PaymentMethod card = Serializer.fromJson<PaymentMethod>('''
      {"type":"card","last4":"4242"}
    ''');
    final PaymentMethod paypal = Serializer.fromJson<PaymentMethod>('''
      {"type":"paypal","email":"jane@example.com"}
    ''');

    expect(card, isA<CardPayment>());
    expect((card as CardPayment).last4, '4242');

    expect(paypal, isA<PaypalPayment>());
    expect((paypal as PaypalPayment).email, 'jane@example.com');
  });
}
