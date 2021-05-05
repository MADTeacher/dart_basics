String myFunction(String name, int date, [String? monthName]){
  if(monthName != null){
    return '$name родился $date $monthName!';
  }
  return '$date числа, неустановленного месяца, родился $name!';
}

void main(List<String> arguments) {
  print(myFunction('Александр', 20));  
  print(myFunction('Александр', 20, 'мая')); 
}
