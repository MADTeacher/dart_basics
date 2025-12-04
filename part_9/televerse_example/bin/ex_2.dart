import 'package:televerse/televerse.dart';

void main(List<String> arguments) async {
  final bot = Bot('YOUR_BOT_TOKEN');

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
