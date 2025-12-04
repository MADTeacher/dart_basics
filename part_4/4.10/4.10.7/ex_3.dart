mixin Inflation {
  void inflation(){
    print('Inflation');
  }
}

mixin GlobalInflation {
  void inflation(){
    print('GlobalInflation Inflation');
  }
}

class RUB with Inflation, GlobalInflation {}
class USD with GlobalInflation, Inflation {}

void main() {
  var rub = RUB();
  rub.inflation(); // GlobalInflation Inflation

  var usd = USD();
  usd.inflation(); // Inflation
}
