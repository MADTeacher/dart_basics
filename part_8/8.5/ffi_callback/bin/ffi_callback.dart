import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:ffi_callback/ffi_gen.dart';

void finishTimer() {
  print('Timer callback');
}

void addWithOutReturn(int a, int b) {
  var result = a + b;
  print('Add result: $a + $b = $result');
}

int addWithReturn(int a, int b) {
  return a + b;
}

void resultCallback(int result) {
  print('Result callback: $result');
}

void main() {
  // Загрузка библиотеки
  final String libraryPath;

  if (Platform.isWindows) {
    libraryPath = path.join(
      Directory.current.path,
      'bin',
      'lib_func.dll',
    );
  } else if (Platform.isLinux) {
    libraryPath = path.join(
      Directory.current.path,
      'bin',
      'lib_func.so',
    );
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  var library = DynamicLibrary.open(libraryPath);
  var nativeLibrary = NativeLibrary(library);

  // Работаем с таймером
  nativeLibrary.startTimer(
    1000,
    Pointer.fromFunction<Void Function()>(
      finishTimer,
    ),
  );

  // работаем с функцией addValue, вызывающей функцию
  // Dart - addWithOutReturn
  nativeLibrary.addValue(
    5,
    10,
    Pointer.fromFunction<Void Function(Int, Int)>(
      addWithOutReturn,
    ),
  );

  // работаем с функцией addWithResult, вызывающей 
  // 2 функции Dart.
  // Первая вызываемая функция - addWithReturn
  // Вторая вызываемая функция - resultCallback
  nativeLibrary.addWithResult(
      5,
      10,
      Pointer.fromFunction<Int Function(Int, Int)>(
        addWithReturn, 0
      ),
      Pointer.fromFunction<Void Function(Int)>(
        resultCallback,
    ));
}