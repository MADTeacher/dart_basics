typedef OMyMap = Map<String, Map<(int, List<int>), int>>;
typedef OMyMapFunc = int Function(OMyMap)?;

int myFunc(OMyMap data) {
  var sum = 0.0;
  for (var MapEntry(:value) in data.entries) {
    for (var MapEntry(key: recKey, value: recValue) in value.entries) {
      var (int a, List<int> b) = recKey;
      sum += (a * b.reduce((value, element) => value + element))/recValue;        
    }
  }
  return sum.floor();
}

int add(
  int a,
  OMyMap data, {
  OMyMapFunc func,
}) {
  if (func == null) {
    return 0;
  }
  return a + func(data);
}


void main(List<String> arguments) {
  OMyMap map = {
    'a': {
      (1, [1, 2, 3]): 100,
      (2, [2, -4, 9]): -98,
      (3, [3, 4, 5]): 3,
    },
    'b': {
      (10, [1, 0, 3]): 100,
      (20, [6, -4, 2]): -98,
      (30, [-3, 4, -5]): 3,
    }
  };
  print(add(22, map, func: myFunc)); // -7
}
