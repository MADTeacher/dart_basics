import 'package:televerse/televerse.dart';

void main(List<String> arguments) async {
  final bot = Bot('8504586081:AAFvOlFhmYR4eIhJXKTEics2uvs89JxmeY8');

  // Устанавливаем обработчик команды /start
  bot.command('start', (ctx) async {
    // Отправляем сообщение при вызове команды /start
    await ctx.reply('Bot started!');
  });
  await bot.start();
}
