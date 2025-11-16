int? calculate([int? a]) {
  if (a == null) {
    return a;
  }
  return a * 7;
}


void main() {
  int? c;
  if (calculate() != null){
    c = calculate();
  } else{
    c = calculate(10);
  } 
  print(c); // 70

  if (calculate(3) != null){
    c = calculate(3);
  } else{
    c = calculate(10);
  } 
  print(c); // 21
}
