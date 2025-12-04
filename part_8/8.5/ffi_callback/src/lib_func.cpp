#include <thread>
#include "lib_func.h"

void startTimer(int milliseconds, void (*timerCallback)())
{
    std::this_thread::sleep_for(std::chrono::milliseconds(milliseconds));
    timerCallback();
}

void addValue(int a, int b, void (*addDart)(int a, int b))
{
    int sum = a + b;
    int diff = a - b;
    addDart(sum, diff);
}

void addWithResult(int a, int b, int (*addDart)(int a, int b), void (*callback)(int result))
{
    int sum = addDart(a + 1, b+ 1);
    callback(sum+1);
}