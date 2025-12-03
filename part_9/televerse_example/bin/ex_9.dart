import 'package:televerse/televerse.dart';

void main(List<String> arguments) async {
  final bot = Bot('8504586081:AAFvOlFhmYR4eIhJXKTEics2uvs89JxmeY8');

  // Устанавливаем обработчик команды /start
  bot.command('start', (ctx) async {
    // Создаем inline-клавиатуру с двумя кнопками
    final keyboard = InlineKeyboard()
        .text('Кнопка 1', 'button_1')
        .text('Кнопка 2', 'button_2');

    await ctx.reply(
      'Выберите опцию:',
      replyMarkup: keyboard, // добавляем клавиатуру к сообщению
    );
  });

  // Обработчик нажатия на первую кнопку
  bot.callbackQuery('button_1', (ctx) async {
    // Указываем тг, что мы обработали callback query
    await ctx.answerCallbackQuery();
    // Отправляем сообщение пользователю
    await ctx.reply('Вы нажали на первую кнопку! 🎯');
  });

  // Обработчик нажатия на вторую кнопку
  bot.callbackQuery('button_2', (ctx) async {
    // Указываем тг, что мы обработали callback query
    // и отправляем уведомление пользователю
    await ctx.answerCallbackQuery(text: 'Ты сделал это!', showAlert: true);
    await ctx.reply('Вы нажали на вторую кнопку! 🚀');
  });

  await bot.start();
}
