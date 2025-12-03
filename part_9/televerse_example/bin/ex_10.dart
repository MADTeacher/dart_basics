import 'package:televerse/televerse.dart';

// Функция для создания главного меню
Future<void> createMainMenu(Context ctx) async {
  final keyboard = InlineKeyboard()
      .text('Кнопка 1', 'button_1')
      .text('Кнопка 2', 'button_2');

  await ctx.reply('Выберите опцию:', replyMarkup: keyboard);
}

void main(List<String> arguments) async {
  final bot = Bot('8504586081:AAFvOlFhmYR4eIhJXKTEics2uvs89JxmeY8');

  // Устанавливаем обработчик команды /start
  bot.command('start', (ctx) async {
    // Создаем главное меню
    await createMainMenu(ctx);
  });

  // Обработчик нажатия на первую кнопку
  bot.callbackQuery('button_1', (ctx) async {
    // Указываем тг, что мы обработали callback query
    await ctx.answerCallbackQuery();

    // Создаем новую клавиатуру с 7 кнопками
    final newKeyboard = InlineKeyboard()
        .text('Кнопка 1.1', 'btn_1_1')
        .text('Кнопка 1.2', 'btn_1_2') // Верхний ряд: 2 кнопки
        .row() // Переход на новый ряд
        .text('Кнопка 1.3', 'btn_1_3') // Средний ряд: 1 кнопка
        .row() // Переход на новый ряд
        .text('Кнопка 1.4', 'btn_1_4')
        .text('Кнопка 1.5', 'btn_1_5')
        .text('Кнопка 1.6', 'btn_1_6') // Нижний ряд: 3 кнопки
        .row() // Переход на новый ряд
        .text('Назад', 'back'); // Кнопка назад

    // Обновляем текст и клавиатуру в том же сообщении
    await ctx.editMessageText(
      'Нажмите на любую кнопку:',
      replyMarkup: newKeyboard,
    );
  });

  // Обработчик для всех кнопок 1.1 - 1.6, использующий
  // регулярное выражение
  bot.callbackQuery(RegExp(r'^btn_1_[1-6]$'), (ctx) async {
    // извлекаем данные из callback query
    final callbackData = ctx.callbackQuery?.data;
    if (callbackData != null) {
      // Извлекаем номер кнопки из callback data (btn_1_1 -> 1.1)
      final buttonNumber = callbackData.replaceFirst('btn_1_', '1.');
      // Указываем тг, что мы обработали callback query
      // и отправляем уведомление пользователю
      await ctx.answerCallbackQuery(
        text: 'Нажата кнопка: Кнопка $buttonNumber',
        showAlert: true,
      );
    }
  });

  // Обработчик нажатия на вторую кнопку
  bot.callbackQuery('button_2', (ctx) async {
    // Указываем тг, что мы обработали callback query
    await ctx.answerCallbackQuery();

    // Создаем клавиатуру с кнопкой "назад"
    final backKeyboard = InlineKeyboard().text('Назад', 'back');

    // Редактируем исходное сообщение, меняя текст и клавиатуру
    await ctx.editMessageText(
      'Функционал находится на стадии разработки 🚧',
      replyMarkup: backKeyboard,
    );
  });

  // Обработчик кнопки "назад"
  bot.callbackQuery('back', (ctx) async {
    // Указываем тг, что мы обработали callback query
    await ctx.answerCallbackQuery();

    // Переходим на главное меню
    await createMainMenu(ctx);
  });

  await bot.start();
}
