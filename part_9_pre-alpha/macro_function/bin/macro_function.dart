import 'package:macro_function/macro_function.dart';
import 'package:macro_function/macro_constructor.dart';
import 'package:macro_function/macro_class.dart';

@Hello()
@DefaultConstructor()
class Batman {
  final String name;
  final int age;

  @override
  String toString() {
    return 'Batman(name: $name, age: $age)';
  }
  
  @override
  void hello() {
    // TODO: implement hello
  }
}

class Superman {
  final String name;
  final int age;

  @Get()
  @Set()
  int _money;

  Superman(this.name, this.age, this._money);

  @override
  String toString() {
    return 'Superman(name: $name, age: $age, money: $_money)';
  }
}

@MulDef()
int add(int a, int b) => a + b;

void main() {
  print(add(4, 5)); // 20
  var batman = Batman('Bruce', 30);
  print(batman); // Batman(name: Bruce, age: 30)

  var superman = Superman('Clark', 40, 100);
  print(superman); // Superman(name: Clark, age: 40, money: 100)
  print(superman.money); // 100
  superman.money = 200;
  print(superman.money); // 200
}
