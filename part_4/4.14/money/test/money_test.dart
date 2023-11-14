import 'package:money/money.dart';
import 'package:test/test.dart';

void main() {

  test('creation', () {
    var rub = Rub.kopek(100);
    IMoney money = rub;
    expect(money.value, 100);
    expect(rub.value, 100);
  });

  test('toString', () {
    var rub = Rub.kopek(100);
    expect(rub.toString(), 'Rub(1.00)');
  });

  test('addition', () {
    var rub = Rub.kopek(100);
    var rub2 = Rub.kopek(200);
    expect((rub + rub2).value, 300);
  });

  group(
    'subtraction',
    () {
      late var rub;
      late var rub2;
    setUp(() {
      rub = Rub.kopek(100);
      rub2 = Rub.kopek(200);
    });

      test('error', () {
        late dynamic err; 
        try {
          rub -= rub2;
        }catch(e){
          err = e;
        }               
        expect(err, isA<MoneyOperationError>());
      });
      test('correct', () {
        expect((rub2 - rub).value, 100);
      });
    }
  );
}
