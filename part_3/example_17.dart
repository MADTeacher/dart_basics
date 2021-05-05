int index_microwave = 0;

Function factory(String name_microwave, int power){
  var model = '$name_microwave-RX-0003$index_microwave';
  index_microwave++;
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
