void main(List<String> arguments) {
  // Проверка наличия переменной окружения
  print(const bool.hasEnvironment('ENV_INT')); // вернет true или false

  // Получение целого числа из переменной окружения
  var myIntEnv = const int.fromEnvironment(
    // Ключ для доступа к переменной окружения
    'ENV_INT', 
    // Значение по умолчанию, если такой переменной среды нет
    defaultValue: 0, 
  );
  print(myIntEnv);

  // Получение строки из переменной окружения
  var myStringEnv = const String.fromEnvironment(
    'ENV_STRING', 
    defaultValue: 'default', 
  );
  print(myStringEnv);

  // Получение логического значения из переменной окружения
  var myBoolEnv = const bool.fromEnvironment(
    'ENV_BOOL', 
    defaultValue: true, 
  );
  print(myBoolEnv);
  // 
}
