String myFunction(String name, int date, [String monthName = 'июля']){
  return '$name родился $date $monthName!';
}

void main(List<String> arguments) {
  print(myFunction('Александр', 20));  
  print(myFunction('Александр', 20, 'мая')); 
}
