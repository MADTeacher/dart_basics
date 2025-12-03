import 'package:televerse/televerse.dart';

void main(List<String> arguments) async {
  final bot = Bot('8504586081:AAFvOlFhmYR4eIhJXKTEics2uvs89JxmeY8');

  // Устанавливаем обработчик команды /start
  bot.command('start', (ctx) async {
    await ctx.reply('Йо-хо-хо!');
  });
  // Устанавливаем обработчик команды /help
  bot.command('help', (ctx) async {
    await ctx.reply('Команды: /start, /help');
  });

  // Устанавливаем обработчик, который реагирует на все
  // типы сообщений от пользователя
  bot.onMessage((ctx) async {
    // от пользователя пришло текстовое сообщение
    if (ctx.message?.text != null) {
      final originalText = ctx.message!.text!;
      // если текст сообщения равен 'O_o', то отправляем 'Йо-хо-хо!'
      if (originalText == 'O_o') {
        await ctx.reply('Йо-хо-хо!');
      } else {
        // В остальных случаях преобразуем текст в верхний регистр
        final replyText = ctx.message!.text!.toUpperCase();
        await ctx.reply(replyText);
      }
    }

    // Когда от пользователя пришло фото
    if (ctx.message?.photo != null) {
      await ctx.reply('Классная фотка!');
    }

    // Когда от пользователя пришло видео
    if (ctx.message?.video != null) {
      await ctx.reply(
        'Эй, поосторожнее! Это '
        'тебе не хранилище для хоум-видео!',
      );
    }

    // Когда от пользователя пришел аудио
    if (ctx.message?.audio != null) {
      await ctx.reply('Классный голосок!');
    }

    // Когда от пользователя пришел документ
    if (ctx.message?.document != null) {
      await ctx.reply('Ну началось...');
    }
  });

  await bot.start();
}
