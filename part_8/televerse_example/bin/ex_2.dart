import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart';

void main(List<String> arguments) async {
  final bot = Bot('8504586081:AAFvOlFhmYR4eIhJXKTEics2uvs89JxmeY8');

  // Устанавливаем обработчик команды /start
  bot.command('start', (ctx) async {
    // Устанавливаем команды, которые будут доступны в боте
    await ctx.api.setMyCommands([
      BotCommand(command: 'help', description: 'Помощь по командам'),
    ]);
    await ctx.reply('Команды установлены!');
  });

  // Устанавливаем обработчик команды /help
  bot.command('help', (ctx) async {
    await ctx.reply('Команды: /start, /help');
  });

  await bot.start();
}
