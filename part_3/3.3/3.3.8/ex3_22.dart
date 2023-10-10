int indexMicrowave = 0;

Function factory(String nameMicrowave, int power){
// Function – обобщенный тип данных для функций, к
// которому их можно приводить
  var model = '$nameMicrowave-RX-0003$indexMicrowave';
  indexMicrowave++;
  return (String dish, int mode){
   var myStr = StringBuffer('Микроволновка "$model" мощностью $power Вт');
    myStr.write(', греет блюдо "$dish" в режиме $mode');
    return myStr;
  };
}

void main(List<String> arguments) {
  var microwave = factory('Scarlet', 750);
  print(microwave('Борщ', 3));
  print(microwave('Котлеты', 5));
  var newMicrowave = factory('Scarlet', 1000);
  print(newMicrowave('Рагу', 2));
}
