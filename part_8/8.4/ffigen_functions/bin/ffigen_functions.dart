import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import 'generated_bindings.dart';

void main(List<String> arguments) {
  // Загрузка библиотеки
  DynamicLibrary nativeLibrary;
  final String libraryPath;

  if (Platform.isWindows) {
    libraryPath = path.join(
      Directory.current.path,
      'bin',
      'libmyfunc.dll',
    );
  } else if (Platform.isLinux) {
    libraryPath = path.join(
      Directory.current.path,
      'bin',
      'libmyfunc.so',
    );
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  nativeLibrary = DynamicLibrary.open(libraryPath);
  var nativeFunc = NativeLibrary(nativeLibrary);

  int result = nativeFunc.add(5, 3); // вызов функции
  print('Результат сложения: $result');

  // Операции над массивами/списками
  // Выделение памяти для списка/массива на 5 элементов
  Pointer<Int> list = calloc<Int>(5);
  list[0] = 1; // заполнение
  list[1] = 2;
  list[2] = 3;
  list[3] = 4;
  list[4] = 5;
  int sum = nativeFunc.sumList(list, 5); // вызов функции
  stdout.write('Исходный список/массив: ');
  print('${list[0]}, ${list[1]}, ${list[2]}, ${list[3]}, ${list[4]}');
  print('Сумма элементов списка/массива: $sum');

  nativeFunc.increaseListValues(list, 5, 10); // вызов функции
  stdout.write('Измененный список/массив: ');
  print('${list[0]}, ${list[1]}, ${list[2]}, ${list[3]}, ${list[4]}');
  calloc.free(list); // освобождение памяти

  // Операции над строками
  // выделение памяти под строку и конвертация строки Dart в UTF-8
  Pointer<Utf8> strToReverse = 'Hello, World!'.toNativeUtf8();
  Pointer<Utf8> reversedStr = malloc<Uint8>(
    strToReverse.length + 1,
  ).cast(); // выделение памяти под результирующую строку

  nativeFunc.reverseString(strToReverse, reversedStr); // вызов функции
  print('Исходная строка: ${strToReverse.toDartString()}');
  print('Перевернутая строка: ${reversedStr.toDartString()}');
  calloc.free(strToReverse); // освобождение памяти
  calloc.free(reversedStr); // освобождение памяти
}
