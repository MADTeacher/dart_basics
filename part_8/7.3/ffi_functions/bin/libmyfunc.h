#if _WIN32
#define MYLIB_EXPORT __declspec(dllexport)
#else
#define MYLIB_EXPORT
#endif

extern "C"
{
    // Функция сложения двух чисел
    MYLIB_EXPORT int add(int a, int b);

    // Функция подсчета суммы элементов целочисленного списка
    MYLIB_EXPORT int sumList(const int *list, int length);

    // Функция увеличения значений целочисленного списка на заданную величину
    MYLIB_EXPORT void increaseListValues(int *list, int length, int amount);

    // Функция инвертирования строки
    MYLIB_EXPORT void reverseString(const char *str, char *result);
}