enum CoffeMachineState {
  none,
  idle,
  choose,
  cappuccino,
  latte,
  espresso,
  changeMoney
}

abstract interface class State {
  void insertMoney(ICoffeMachine coffeMachine);
  void ejectMoney(ICoffeMachine coffeMachine);
  void makeCoffe(ICoffeMachine coffeMachine);
}

abstract interface class ICoffeMachine {
  double getWaterValue();
  double getMilkValue();
  int getOrderMoney();

  void setWaterValue(double value);
  void setMilkValue(double value);
  void setOrderMoney(int money);

  void setState(CoffeMachineState state);
  CoffeMachineState selectedCoffee();
  void returnMoney();
}

class IdleState implements State {
  @override
  void ejectMoney(ICoffeMachine coffeMachine) {
    print('What the money? Oo');
  }

  @override
  void insertMoney(ICoffeMachine coffeMachine) {
    print('Go to the choose state');
    coffeMachine.setState(CoffeMachineState.choose);
  }

  @override
  void makeCoffe(ICoffeMachine coffeMachine) {
    print('Get out of here, rogue');
  }
}

class WaitChooseState implements State {
  @override
  void ejectMoney(ICoffeMachine coffeMachine) {
    print('Order or leave your money!');
  }

  @override
  void insertMoney(ICoffeMachine coffeMachine) {
    print('Enough funds uploaded to order?');
    coffeMachine.setState(CoffeMachineState.choose);
  }

  @override
  void makeCoffe(ICoffeMachine coffeMachine) {
    if (coffeMachine.selectedCoffee() == CoffeMachineState.none) {
      print('Choose the coffee you want to make!');
    } else {
      coffeMachine.setState(coffeMachine.selectedCoffee());
    }
  }
}

class ChangeState implements State {
  @override
  void ejectMoney(ICoffeMachine coffeMachine) {
    print('Return ${coffeMachine.getOrderMoney()} parrots');
    coffeMachine.setOrderMoney(0);
    coffeMachine.setState(CoffeMachineState.idle);
  }

  @override
  void insertMoney(ICoffeMachine coffeMachine) {
    ejectMoney(coffeMachine);
  }

  @override
  void makeCoffe(ICoffeMachine coffeMachine) {
    ejectMoney(coffeMachine);
  }
}

class CappuccinoState implements State {
  @override
  void ejectMoney(ICoffeMachine coffeMachine) {
    print('You will not get it!!!');
  }

  @override
  void insertMoney(ICoffeMachine coffeMachine) {
    makeCoffe(coffeMachine);
  }

  @override
  void makeCoffe(ICoffeMachine coffeMachine) {
    final cost = 32;
    final needWater = 0.3;
    final needMilk = 0.1;
    var waterResidues = coffeMachine.getWaterValue() - needWater;
    var milkResidues = coffeMachine.getMilkValue() - needMilk;
    var moneyResidues = coffeMachine.getOrderMoney() - cost;
    if (moneyResidues >= 0) {
      if (waterResidues >= 0 && milkResidues >= 0) {
        print('Cooking Cappuccino!');
        coffeMachine.setWaterValue(waterResidues);
        coffeMachine.setMilkValue(milkResidues);
        coffeMachine.setOrderMoney(moneyResidues);
      } else {
        print('Not enough ingredients!');
      }
      if (coffeMachine.getOrderMoney() > 0) {
        coffeMachine.setState(CoffeMachineState.changeMoney);
        coffeMachine.returnMoney();
      } else {
        coffeMachine.setState(CoffeMachineState.idle);
      }
    } else {
      print('Not enough funds!');
    }
  }
}

class LatteState implements State {
  @override
  void ejectMoney(ICoffeMachine coffeMachine) {
    print('You will not get it!!!');
  }

  @override
  void insertMoney(ICoffeMachine coffeMachine) {
    makeCoffe(coffeMachine);
  }

  @override
  void makeCoffe(ICoffeMachine coffeMachine) {
    final cost = 40;
    final needWater = 0.3;
    final needMilk = 0.2;
    var waterResidues = coffeMachine.getWaterValue() - needWater;
    var milkResidues = coffeMachine.getMilkValue() - needMilk;
    var moneyResidues = coffeMachine.getOrderMoney() - cost;
    if (moneyResidues >= 0) {
      if (waterResidues >= 0 && milkResidues >= 0) {
        print('Cooking Latte!');
        coffeMachine.setWaterValue(waterResidues);
        coffeMachine.setMilkValue(milkResidues);
        coffeMachine.setOrderMoney(moneyResidues);
      } else {
        print('Not enough ingredients!');
      }
      if (coffeMachine.getOrderMoney() > 0) {
        coffeMachine.setState(CoffeMachineState.changeMoney);
        coffeMachine.returnMoney();
      } else {
        coffeMachine.setState(CoffeMachineState.idle);
      }
    } else {
      print('Not enough funds!');
    }
  }
}

class EspressoState implements State {
  @override
  void ejectMoney(ICoffeMachine coffeMachine) {
    print('You will not get it!!!');
  }

  @override
  void insertMoney(ICoffeMachine coffeMachine) {
    makeCoffe(coffeMachine);
  }

  @override
  void makeCoffe(ICoffeMachine coffeMachine) {
    final cost = 25;
    final needWater = 0.3;
    var waterResidues = coffeMachine.getWaterValue() - needWater;
    var moneyResidues = coffeMachine.getOrderMoney() - cost;
    if (moneyResidues >= 0) {
      if (waterResidues >= 0) {
        print('Cooking Latte!');
        coffeMachine.setWaterValue(waterResidues);
        coffeMachine.setOrderMoney(moneyResidues);
      } else {
        print('Not enough ingredients!');
      }
      if (coffeMachine.getOrderMoney() > 0) {
        coffeMachine.setState(CoffeMachineState.changeMoney);
        coffeMachine.returnMoney();
      } else {
        coffeMachine.setState(CoffeMachineState.idle);
      }
    } else {
      print('Not enough funds!');
    }
  }
}

class CoffeeMachine implements ICoffeMachine {
  double _waterCapacity;
  double _milkCapacity;
  var _orderMopney = 0;
  CoffeMachineState _selectedCoffee = CoffeMachineState.none;
  final _allStates = <CoffeMachineState, State>{
    CoffeMachineState.idle: IdleState(),
    CoffeMachineState.choose: WaitChooseState(),
    CoffeMachineState.changeMoney: ChangeState(),
    CoffeMachineState.cappuccino: CappuccinoState(),
    CoffeMachineState.latte: LatteState(),
    CoffeMachineState.espresso: EspressoState()
  };
  late State _currentState;

  CoffeeMachine(this._waterCapacity, this._milkCapacity) {
    _currentState = _allStates[CoffeMachineState.idle]!;
  }

  @override
  double getMilkValue() => _milkCapacity;

  @override
  int getOrderMoney() => _orderMopney;

  @override
  double getWaterValue() => _waterCapacity;

  @override
  CoffeMachineState selectedCoffee() => _selectedCoffee;

  @override
  void setMilkValue(double value) {
    _milkCapacity = value;
  }

  @override
  void setOrderMoney(int money) {
    _orderMopney = money;
  }

  @override
  void setWaterValue(double value) {
    _waterCapacity = value;
  }

  void cappuccino() {
    print('Cappuccino preparation selected');
    _selectedCoffee = CoffeMachineState.cappuccino;
    _currentState.makeCoffe(this);
  }

  void latte() {
    print('Latte preparation selected');
    _selectedCoffee = CoffeMachineState.latte;
    _currentState.makeCoffe(this);
  }

  void espresso() {
    print('Espresso preparation selected');
    _selectedCoffee = CoffeMachineState.espresso;
    _currentState.makeCoffe(this);
  }

  @override
  void setState(CoffeMachineState state) {
    if (state == CoffeMachineState.idle) {
      _selectedCoffee = CoffeMachineState.none;
    }
    _currentState = _allStates[state]!;
  }

  @override
  void returnMoney() {
    _currentState.ejectMoney(this);
  }

  void insertMoney(int money) {
    _orderMopney += money;
    print('Inserted $_orderMopney parrots');
    _currentState.insertMoney(this);
  }

  void makeCoffee() {
    print('Start preparation of the selected coffee!');
    _currentState.makeCoffe(this);
  }
}

void main() {
  var coffeeMachine = CoffeeMachine(1.0, 1.0);
  coffeeMachine.makeCoffee();
  coffeeMachine.insertMoney(10);
  coffeeMachine.insertMoney(10);
  coffeeMachine.cappuccino();
  coffeeMachine.makeCoffee();
  coffeeMachine.insertMoney(20);
  print('**** When not enough products to make coffee ****');
  coffeeMachine = CoffeeMachine(0.1, 0.1);
  coffeeMachine.insertMoney(100);
  coffeeMachine.makeCoffee();
  coffeeMachine.latte();
  coffeeMachine.makeCoffee();
}