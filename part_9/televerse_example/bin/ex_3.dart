import 'package:televerse/televerse.dart';

void main(List<String> arguments) async {
  final bot = Bot('YOUR_BOT_TOKEN');

  // Устанавливаем обработчик команды /start
  bot.command('start', (ctx) async {
    await ctx.reply('Йо-хо-хо!');
  });

  // Устанавливаем обработчик, который обрабатывает
  // только текстовые сообщения
  bot.onText((ctx) async {
    // Гарантированно получаем текст сообщения
    final originalText = ctx.message!.text!;

    // Преобразуем текст в верхний регистр
    final modifiedText = originalText.toUpperCase();

    // Отправляем модифицированный текст обратно пользователю
    await ctx.reply(modifiedText);
  });

  await bot.start();
}
