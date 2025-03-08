import 'dart:convert';
import 'dart:io';
import 'dart:async';

class _Utf8Decoder {
  const _Utf8Decoder();

  int requiredBytes(int firstByte) {
    if (firstByte <= 0x7F) return 1;
    if ((firstByte & 0xE0) == 0xC0) return 2;
    if ((firstByte & 0xF0) == 0xE0) return 3;
    if ((firstByte & 0xF8) == 0xF0) return 4;
    return -1;
  }

  String decode(List<int> buffer, [bool isFinal = false]) {
    List<int> codeUnits = [];
    int i = 0;

    while (i < buffer.length) {
      int byte1 = buffer[i];
      int symbolSize = requiredBytes(byte1);

      if (symbolSize == -1 || (!isFinal && i + symbolSize > buffer.length)) {
        break;
      }

      if (symbolSize == 1) {
        codeUnits.add(byte1);
        i++;
      } else if (symbolSize == 2 && i + 1 < buffer.length) {
        int byte2 = buffer[i + 1];
        codeUnits.add(((byte1 & 0x1F) << 6) | (byte2 & 0x3F));
        i += 2;
      } else if (symbolSize == 3 && i + 2 < buffer.length) {
        int byte2 = buffer[i + 1];
        int byte3 = buffer[i + 2];
        codeUnits.add(
          ((byte1 & 0x0F) << 12) | ((byte2 & 0x3F) << 6) | (byte3 & 0x3F),
        );
        i += 3;
      } else if (symbolSize == 4 && i + 3 < buffer.length) {
        int byte2 = buffer[i + 1];
        int byte3 = buffer[i + 2];
        int byte4 = buffer[i + 3];
        codeUnits.add(
          ((byte1 & 0x07) << 18) |
              ((byte2 & 0x3F) << 12) |
              ((byte3 & 0x3F) << 6) |
              (byte4 & 0x3F),
        );
        i += 4;
      }
    }

    buffer.removeRange(0, i);
    return String.fromCharCodes(codeUnits);
  }
}

class _Utf8Encoder {
  const _Utf8Encoder();

  List<int> encode(String input) {
    List<int> bytes = [];
    for (int codeUnit in input.runes) {
      if (codeUnit <= 0x7F) {
        bytes.add(codeUnit);
      } else if (codeUnit <= 0x7FF) {
        bytes.add(0xC0 | (codeUnit >> 6));
        bytes.add(0x80 | (codeUnit & 0x3F));
      } else if (codeUnit <= 0xFFFF) {
        bytes.add(0xE0 | (codeUnit >> 12));
        bytes.add(0x80 | ((codeUnit >> 6) & 0x3F));
        bytes.add(0x80 | (codeUnit & 0x3F));
      } else if (codeUnit <= 0x10FFFF) {
        bytes.add(0xF0 | (codeUnit >> 18));
        bytes.add(0x80 | ((codeUnit >> 12) & 0x3F));
        bytes.add(0x80 | ((codeUnit >> 6) & 0x3F));
        bytes.add(0x80 | (codeUnit & 0x3F));
      }
    }
    return bytes;
  }
}

const utf8Encoder = _Utf8Encoder();
const utf8Decoder = _Utf8Decoder();

class Utf8Transformer extends StreamTransformerBase<List<int>, String> {
  const Utf8Transformer();

  @override
  Stream<String> bind(Stream<List<int>> stream) {
    var buffer = <int>[];
    var controller = StreamController<String>();

    stream.listen(
      (chunk) {
        buffer.addAll(chunk);
        var result = utf8Decoder.decode(buffer);
        if (result.isNotEmpty) {
          controller.add(result);
        }
      },
      onError: controller.addError,
      onDone: () {
        if (buffer.isNotEmpty) {
          var result = utf8Decoder.decode(buffer, true);
          if (result.isNotEmpty) {
            controller.add(result);
          }
        }
        controller.close();
      },
    );

    return controller.stream;
  }
}

void main() async {
  // Example of using Utf8 transformer for decoding
  final file = File('example.txt');
  final stream = file.openRead();

  // Декодируем поток данных с использованием Utf8 и LineSplitter
  await for (final string in stream
      .transform(Utf8Transformer())
      .transform(LineSplitter())) {
    print('Line decode: $string');
  }

  // Пример использования Utf8 для кодирования строки
  final text = '🤘 Hello 🖖, test 😂!';
  final bytes = utf8Encoder.encode(text);
  print('\nEncoded bytes: $bytes');

  // Запись байтов в файл
  await File('output.txt').writeAsBytes(bytes);
}
