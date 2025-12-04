part of 'money.dart';

class PaperRUB extends RUB {
  PaperRUB._(super.val);

  PaperRUB.rub50() : super(5000);
  PaperRUB.rub100() : super(10000);
  PaperRUB.rub500() : super(50000);
  PaperRUB.rub1000() : super(100000);
  PaperRUB.rub5000() : super(500000);

  @override
  PaperRUB operator +(Money other) {
    return PaperRUB._(value + other.value);
  }
}