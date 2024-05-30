#if _WIN32
#define MYLIB_EXPORT __declspec(dllexport)
#else
#define MYLIB_EXPORT
#endif

typedef struct Node
{
    int data;
    struct Node *next;
} Node;

typedef struct Stack
{
    Node *top;
} Stack;

#ifdef __cplusplus
extern "C"
{
#endif
    MYLIB_EXPORT Stack *createStack(); // создать экземпляр стека
    MYLIB_EXPORT bool isEmpty(Stack *stack); // проверка наполненности
    MYLIB_EXPORT void push(Stack *stack, int data); // добавить элемент
    MYLIB_EXPORT int pop(Stack *stack); // изъять элемент
    MYLIB_EXPORT void deleteStack(Stack *stack); // удалить экз-р стека 
#ifdef __cplusplus
}
#endif
