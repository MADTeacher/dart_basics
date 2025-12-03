import 'dart:io';
import 'package:televerse/televerse.dart';

void main(List<String> arguments) async {
  final bot = Bot('8504586081:AAFvOlFhmYR4eIhJXKTEics2uvs89JxmeY8');

  // Устанавливаем обработчик команды /start
  bot.command('start', (ctx) async {
    await ctx.reply('Йо-хо-хо!');
  });

  bot.onPhoto((ctx) async {
    try {
      // Получаем последнее фото из массива фото
      final photo = ctx.message!.photo!.last;

      // Получаем информацию о файле через API telegram
      final fileInfo = await ctx.api.getFile(photo.fileId);

      // Создаем директорию для сохранения фото, если её нет
      final photosDir = Directory('photos');
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      // Формируем имя файла с timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'photo_$timestamp.jpg';
      final filePathLocal = '${photosDir.path}/$fileName';

      // Скачиваем файл используя встроенный метод Televerse
      final downloadedFile = await fileInfo.download(
        path: filePathLocal,
        token: bot.token,
      );

      if (downloadedFile == null) {
        await ctx.reply('Не удалось скачать файл');
        return;
      }

      await ctx.reply('Фото сохранено: $fileName');
    } catch (e) {
      await ctx.reply('Ошибка при сохранении фото: $e');
    }
  });

  await bot.start();
}
