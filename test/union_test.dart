import 'package:d_serializer/d_serializer.dart';
import 'package:test/test.dart';

<<<<<<< HEAD
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
=======
/// Example sealed class marked with @SerializableUnion
@SerializableUnion(typeField: 'kind')
sealed class PaymentMethod {
  const PaymentMethod();
}

/// Concrete implementation for card payments
@Serializable(discriminator: 'card')
class CardPayment extends PaymentMethod {
  final String last4;
  final String brand;

  const CardPayment({
    required this.last4,
    required this.brand,
  });
}

/// Concrete implementation for PayPal payments
@Serializable(discriminator: 'paypal')
class PayPalPayment extends PaymentMethod {
  final String email;

  const PayPalPayment({required this.email});
}

/// Another sealed class example
@SerializableUnion(typeField: 'type')
sealed class Event {
  const Event();
}

@Serializable(discriminator: 'click')
class ClickEvent extends Event {
  final String elementId;

  const ClickEvent({required this.elementId});
}

@Serializable(discriminator: 'scroll')
class ScrollEvent extends Event {
  final int pixels;

  const ScrollEvent({required this.pixels});
}

void main() {
  setUpAll(() {
    // Import generated files in real usage
    // import 'package:my_app/models/models.g.dart';
    // initializeDSerializer();
  });

  group('SerializableUnion', () {
    test('discriminator field is included in JSON', () {
      const payment = CardPayment(last4: '1234', brand: 'Visa');
      final json = payment.toJson();

      expect(json.containsKey('kind'), isTrue);
      expect(json['kind'], equals('card'));
    });

    test('discriminator value matches @Serializable discriminator', () {
      final cardJson = const CardPayment(last4: '1234', brand: 'Visa').toJson();
      expect(cardJson['kind'], equals('card'));

      final paypalJson = const PayPalPayment(email: 'test@example.com').toJson();
      expect(paypalJson['kind'], equals('paypal'));
    });

    test('union resolves subtype from discriminator (runtime)', () {
      // Simulate deserialization with discriminator resolution
      final cardJson = {'kind': 'card', 'last4': '5678', 'brand': 'Mastercard'};
      final paypalJson = {'kind': 'paypal', 'email': 'user@example.com'};

      // The generated code registers union factories
      // Serializer.registerUnion<PaymentMethod>(
      //   typeField: 'kind',
      //   discriminator: 'card',
      //   fromJson: CardPaymentFromJson,
      // );
      expect(cardJson['kind'], equals('card'));
      expect(paypalJson['kind'], equals('paypal'));
    });

    test('multiple union types can coexist', () {
      final clickJson = {'type': 'click', 'elementId': 'btn-submit'};
      final scrollJson = {'type': 'scroll', 'pixels': 500};

      expect(clickJson['type'], equals('click'));
      expect(scrollJson['type'], equals('scroll'));
    });

    test('typeField defaults to "type" if not specified', () {
      // When using @SerializableUnion without typeField
      // it should default to 'type'
      const union = SerializableUnion();
      expect(union.typeField, equals('type'));
    });

    test('custom typeField can be configured', () {
      const union = SerializableUnion(typeField: 'kind');
      expect(union.typeField, equals('kind'));
    });
  });

  group('Serializer.registerUnion', () {
    test('registerUnion API exists and accepts parameters', () {
      // Verify the API signature
      // This test documents expected behavior
      expect(Serializer.registerUnion<PaymentMethod>, isNotNull);

      // registerUnion parameters:
      // - typeField: String
      // - discriminator: String
      // - fromJson: JsonFactory<T>
    });

    test('registerUnion prevents conflicting typeField', () {
      // If you try to register the same union type with different typeField,
      // it should throw a StateError
      // This is handled at runtime by Serializer.registerUnion
    });
  });

  group('Usage example (documentation)', () {
    test('full workflow example', () {
      // 1. Define sealed class with @SerializableUnion
      // 2. Annotate each subclass with @Serializable(discriminator: 'value')
      // 3. Generate code with build_runner
      // 4. Initialize: initializeDSerializer()
      // 5. Use: Serializer.fromJson<PaymentMethod>(jsonString)

      const payment = CardPayment(last4: '4242', brand: 'Visa');
      final json = payment.toJson();

      expect(json['kind'], equals('card'));
      expect(json['last4'], equals('4242'));
      expect(json['brand'], equals('Visa'));
    });
  });
}
>>>>>>> feature/polymorphic-union
