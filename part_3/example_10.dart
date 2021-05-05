String myFunction({required String name, 
                  int date=10, 
                  required String monthName}){
  return '$name родился $date $monthName!';
}

void main(List<String> arguments) {
  print(myFunction(name:'Александр', monthName:'мая'));  
  print(myFunction(date:14, name:'Александр', monthName:'мая'));  
}
