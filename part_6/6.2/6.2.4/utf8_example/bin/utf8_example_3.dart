import 'dart:io';

class Utf8 {
  const Utf8();

  int requiredBytes(int firstByte) {
    if (firstByte <= 0x7F) return 1;
    if ((firstByte & 0xE0) == 0xC0) return 2;
    if ((firstByte & 0xF0) == 0xE0) return 3;
    if ((firstByte & 0xF8) == 0xF0) return 4;
    return -1;
  }

  List<int> encode(String input) {
    List<int> bytes = [];
    for (int codeUnit in input.runes) {
      if (codeUnit <= 0x7F) {
        // 1 байт
        bytes.add(codeUnit);
      } else if (codeUnit <= 0x7FF) {
        // 2 байта
        bytes.add(0xC0 | (codeUnit >> 6));
        bytes.add(0x80 | (codeUnit & 0x3F));
      } else if (codeUnit <= 0xFFFF) {
        // 3 байта
        bytes.add(0xE0 | (codeUnit >> 12));
        bytes.add(0x80 | ((codeUnit >> 6) & 0x3F));
        bytes.add(0x80 | (codeUnit & 0x3F));
      } else if (codeUnit <= 0x10FFFF) {
        // 4 байта
        bytes.add(0xF0 | (codeUnit >> 18));
        bytes.add(0x80 | ((codeUnit >> 12) & 0x3F));
        bytes.add(0x80 | ((codeUnit >> 6) & 0x3F));
        bytes.add(0x80 | (codeUnit & 0x3F));
      }
    }
    return bytes;
  }

  String decode(List<int> bytes) {
    List<int> codeUnits = [];
    for (int i = 0; i < bytes.length;) {
      int byte1 = bytes[i];
      if (byte1 <= 0x7F) {
        codeUnits.add(byte1);
        i++;
      } else if ((byte1 & 0xE0) == 0xC0) {
        int byte2 = bytes[i + 1];
        codeUnits.add(((byte1 & 0x1F) << 6) | (byte2 & 0x3F));
        i += 2;
      } else if ((byte1 & 0xF0) == 0xE0) {
        int byte2 = bytes[i + 1];
        int byte3 = bytes[i + 2];
        codeUnits.add(
          ((byte1 & 0x0F) << 12) | ((byte2 & 0x3F) << 6) | (byte3 & 0x3F),
        );
        i += 3;
      } else if ((byte1 & 0xF8) == 0xF0) {
        int byte2 = bytes[i + 1];
        int byte3 = bytes[i + 2];
        int byte4 = bytes[i + 3];
        codeUnits.add(
          ((byte1 & 0x07) << 18) |
              ((byte2 & 0x3F) << 12) |
              ((byte3 & 0x3F) << 6) |
              (byte4 & 0x3F),
        );
        i += 4;
      }
    }
    return String.fromCharCodes(codeUnits);
  }
}

const utf8 = Utf8();

void main() async {
  var input = await File('example.txt').open();
  var output = await File('out.txt').open(mode: FileMode.write);
  final fileLength = await input.length();
  var currentPosition = 0;

  while (currentPosition < fileLength) {
    var byte = await input.readByte();
    var requiredBytes = utf8.requiredBytes(byte);
    if (requiredBytes < 0 || requiredBytes == 1) {
      currentPosition = await input.position();
      continue; // переходим к чтению следующего байта
    }
    if (requiredBytes == 4) {
      var codeUnit = [byte, ...await input.read(3)];
      await output.writeFrom(codeUnit);
    } else {
      await input.setPosition(input.positionSync() + requiredBytes - 1);
    }
    currentPosition = await input.position();
  }

  input.closeSync();
  // очищаем буфер, записывая оставшиеся данные в файл
  // (если таковые имеются)
  output.flushSync();
  output.closeSync();
}
