#include "libmyfunc.h"
#include <string.h>

//  Функция сложения двух чисел
int add(int a, int b)
{
    return a + b;
}

// Функция подсчета суммы элементов целочисленного списка
int sumList(const int *list, int length)
{
    int sum = 0;
    for (int i = 0; i < length; i++)
    {
        sum += list[i];
    }
    return sum;
}

// Функция увеличения значений целочисленного 
// списка на заданную величину
void increaseListValues(int *list, int length,
                        int amount)
{
    for (int i = 0; i < length; i++)
    {
        list[i] += amount;
    }
}

// Функция инвертирования строки
void reverseString(const char *str, char *result)
{
    int left = 0;
    int right = strlen(str) - 1;
    strcpy_s(result, strlen(str) + 1, str);
    while (left < right)
    {
        char temp = result[left];
        result[left] = result[right];
        result[right] = temp;
        left++;
        right--;
    }
}
