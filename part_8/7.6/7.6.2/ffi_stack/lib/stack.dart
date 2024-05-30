import 'dart:io';

import 'package:path/path.dart' as path;
import 'dart:ffi' as ffi;

part 'ffi_stack.dart';

final _nativeLibrary = ffi.DynamicLibrary.open(path.join(
  Directory.current.path,
  'bin',
  'lib_stack.dll',
));
final _nativeStackLib = NativeStack(_nativeLibrary);

final class MyStack implements ffi.Finalizable {
  ffi.Pointer<Stack> _stack;

  static final _finalizer = ffi.NativeFinalizer(
    _nativeStackLib._deleteStackPtr.cast(),
    // функция, вызываемая при удалении объекта
  );

  MyStack._(this._stack);

  factory MyStack() {
    final stack = _nativeStackLib.createStack();
    final wrapper = MyStack._(stack);
    // прикрепляем к обертку к финализатору
    _finalizer.attach(wrapper, stack.cast(), detach: wrapper);
    return wrapper;
  }

  bool isEmpty() {
    return _nativeStackLib.isEmpty(_stack).isOdd;
  }

  void push(int value) {
    _nativeStackLib.push(_stack, value);
  }

  int pop() {
    return _nativeStackLib.pop(_stack);
  }

  int peek() {
    // метод возвращает без изъятия из стека данные, находящиеся
    // на его вершине. Доступ к этому числу производится через поле
    // указателя – ref
    return _stack.ref.top.ref.data;
  }

  void freeMemory() {
    _finalizer.detach(this);
    _nativeStackLib.deleteStack(_stack);
  }
}
