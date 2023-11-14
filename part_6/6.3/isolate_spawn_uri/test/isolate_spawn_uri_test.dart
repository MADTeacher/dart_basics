import 'package:isolate_spawn_uri/isolate_spawn_uri.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });
}
