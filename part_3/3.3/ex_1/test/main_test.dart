import 'package:async/async.dart';
import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  test("main is checked", () async {
    var answers = <(String, String)>[
      ('7 5', '12'),
      ('2 3', '5'),
      ('-2 4', '2'),
      ('3 -4', '-1'),
    ];
    var dir = Directory.current;
    print(dir.path);
    for (var (input, output) in answers) {
      var process = await Process.start(
        'dart',
        ['run', '${dir.path}\\bin\\main.dart'],
      );
      var stdoutSplitter = StreamSplitter(
        process.stdout
            .transform(
              utf8.decoder,
            )
            .transform(
              const LineSplitter(),
            ),
      );
      process.stdin.writeln(input);
      var procOutput = await stdoutSplitter.split().first;
      expect(procOutput, equals(output));

      var exitCode = await process.exitCode;
      // успешное завершение процесса?
      expect(exitCode, equals(0)); 
    }
  });
}
