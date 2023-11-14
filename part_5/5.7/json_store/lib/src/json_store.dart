import 'package:collection/collection.dart';

import 'json_file.dart';

class JSONStore {
  final JSONFile _file;
  JSONStore(String path) : _file = JSONFile(path);

  Map<String, Object>? _values;
  String get path => _file.path;

  bool contains(String key) {
    return _getValues().containsKey(key);
  }

  List<String> get keys {
    return List.unmodifiable(_getValues().keys);
  }

  List<Object> get values {
    return List.unmodifiable(
      (_values ??= _file.read() ?? {}).values,
    );
  }

  Map<String, Object> _getValues() {
    return _values ??= _file.read() ?? {};
  }

  Object? getValue(String key) => _getValues()[key];

  bool valueEquals(Object? a, Object? b) {
    return const DeepCollectionEquality().equals(a, b);
  }

  bool? getBool(String key) => getValue(key) as bool?;
  int? getInt(String key) => getValue(key) as int?;
  double? getDouble(String key) => getValue(key) as double?;
  String? getString(String key) => getValue(key) as String?;
  List<Object?>? getList(String key) {
    return getValue(key) as List<Object?>?;
  }
  Map<Object, Object?>? getMap(String key) {
    return getValue(key) as Map<Object, Object?>?;
  }

  void setValue(String key, Object? value) async {
    if (value == null) {
      resetValue(key);
    }

    final values = Map.of(_getValues());
    final oldValue = values[key];
    values[key] = value!;
    if (oldValue == null) {
      _values = values;
      _file.write(values);
    } else if (!valueEquals(oldValue, value)) {
      _values = values;
      _file.write(values);
    }
  }

  void resetValue(String key) async {
    final values = Map.of(_getValues());
    if (values.remove(key) != null) {
      _values = values;
      _file.write(values);
    }
  }
}
