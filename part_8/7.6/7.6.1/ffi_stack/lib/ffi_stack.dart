// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

/// Bindings to `src/lib_stack.h`.
class NativeStack {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeStack(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeStack.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  ffi.Pointer<Stack> createStack() {
    return _createStack();
  }

  late final _createStackPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<Stack> Function()>>('createStack');
  late final _createStack =
      _createStackPtr.asFunction<ffi.Pointer<Stack> Function()>();

  int isEmpty(
    ffi.Pointer<Stack> stack,
  ) {
    return _isEmpty(
      stack,
    );
  }

  late final _isEmptyPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Pointer<Stack>)>>(
          'isEmpty');
  late final _isEmpty =
      _isEmptyPtr.asFunction<int Function(ffi.Pointer<Stack>)>();

  void push(
    ffi.Pointer<Stack> stack,
    int data,
  ) {
    return _push(
      stack,
      data,
    );
  }

  late final _pushPtr = _lookup<
      ffi
      .NativeFunction<ffi.Void Function(ffi.Pointer<Stack>, ffi.Int)>>('push');
  late final _push =
      _pushPtr.asFunction<void Function(ffi.Pointer<Stack>, int)>();

  int pop(
    ffi.Pointer<Stack> stack,
  ) {
    return _pop(
      stack,
    );
  }

  late final _popPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Pointer<Stack>)>>('pop');
  late final _pop = _popPtr.asFunction<int Function(ffi.Pointer<Stack>)>();

  void deleteStack(
    ffi.Pointer<Stack> stack,
  ) {
    return _deleteStack(
      stack,
    );
  }

  late final _deleteStackPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<Stack>)>>(
          'deleteStack');
  late final _deleteStack =
      _deleteStackPtr.asFunction<void Function(ffi.Pointer<Stack>)>();
}

final class Stack extends ffi.Struct {
  external ffi.Pointer<Node> top;
}

final class Node extends ffi.Struct {
  @ffi.Int()
  external int data;

  external ffi.Pointer<Node> next;
}

