sealed class Money {}

class RUB extends Money {}
class USD extends Money {}
class EUR extends Money {}

void main() {
  Money money = RUB();
  
  switch (money) {
    case RUB():
      print('RUB'); // RUB
    case USD():
      print('USD');
    case EUR():
      print('EUR');
  }
}