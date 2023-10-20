import 'lib_a.dart';

class MyMoney extends Rub{
  MyMoney(super.value);

  @override
  String toString() {
    return 'MyMoney(${value()})';
  }
}

void main() {
  var money = Money.fromInt(100);
  print(money);

  var myMoney = MyMoney('100');
  print(myMoney);

}