import 'package:televerse/televerse.dart';

void main(List<String> arguments) async {
  final bot = Bot('YOUR_BOT_TOKEN');

  // Устанавливаем обработчик команды /start
  bot.command('start', (ctx) async {
    // Отправляем сообщение при вызове команды /start
    await ctx.reply('Bot started!');
  });
  await bot.start();
}
