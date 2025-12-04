#if _WIN32
#define MYLIB_EXPORT __declspec(dllexport)
#else
#define MYLIB_EXPORT
#endif

#ifdef __cplusplus
extern "C"
{
#endif
    MYLIB_EXPORT void startTimer(int milliseconds, void (*timerCallback)());
    MYLIB_EXPORT void addValue(int a, int b, void (*addDart)(int a, int b));
    MYLIB_EXPORT void addWithResult(int a, int b, int (*addDart)(int a, int b), void (*callback)(int result));
#ifdef __cplusplus
}
#endif