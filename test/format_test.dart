import 'package:d_serializer/d_serializer.dart';
import 'package:test/test.dart';

void main() {
  group('Serializer.formatDate/parseDate', () {
    test('formats yyyy-MM-dd', () {
      final DateTime value = DateTime(2026, 5, 30);
      final String result = Serializer.formatDate(value, 'yyyy-MM-dd');
      expect(result, '2026-05-30');
    });

    test('parses yyyy-MM-dd', () {
      final DateTime result = Serializer.parseDate('2026-05-30', 'yyyy-MM-dd');
      expect(result.year, 2026);
      expect(result.month, 5);
      expect(result.day, 30);
    });

    test('throws on invalid yyyy-MM-dd payload', () {
      expect(
        () => Serializer.parseDate('30-05-2026', 'yyyy-MM-dd'),
        throwsA(isA<FormatException>()),
      );
    });

    test('supports iso8601 pass-through', () {
      final DateTime value = DateTime.utc(2026, 5, 30, 12, 0, 0);
      final String text = Serializer.formatDate(value, 'iso8601');
      final DateTime parsed = Serializer.parseDate(text, 'iso8601');
      expect(parsed.toUtc(), value.toUtc());
    });

    test('throws on unsupported pattern', () {
      expect(
        () => Serializer.formatDate(DateTime.now(), 'dd/MM/yyyy'),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
