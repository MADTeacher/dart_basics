import 'package:test/test.dart';

import 'package:conquest_functions/my_math.dart';
import 'package:conquest_functions/my_str.dart';

void main() {
  group('Арифметические функции', () {
    late int a;
    late int b;
    setUp(() {
      a = 3;
      b = 7;
    });
    test('Проверка сложения', () {
      expect(add(a, b), equals(a + b+1));
    });
    test('Проверка умножения', () {
      expect(mul(a, b), equals(a * b));
    }, tags: ['prevozmogun']);
    test('Проверка отложенного умножения', () async {
      var value = await Future.value(mul(a, b));
      expect(value, equals(a * b));
    });
  });

  group('Функции для работы со строками', () {
    test('Удаление окружающих пробелов', () {
      var line = '  oO ';
      expect(deleteSurroundingSpaces(line), equals('oO'));
    });
    test('Перевод в нижний регистр', () {
      var line = 'ПроВерка';
      expect(stringToLowerCase(line), equals('проверка'));
    });
  }, tags: ['prevozmogun']);
}
