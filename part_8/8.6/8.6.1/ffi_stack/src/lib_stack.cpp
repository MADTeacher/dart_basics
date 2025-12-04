#include "lib_stack.h"
#include <iostream>

Stack *createStack()
{
    Stack *stack = new Stack();
    stack->top = nullptr;
    return stack;
}

bool isEmpty(Stack *stack)
{
    return stack->top == nullptr;
}

void push(Stack *stack, int data)
{
    Node *newNode = new Node();
    newNode->data = data;
    newNode->next = stack->top;
    stack->top = newNode;
}

int pop(Stack *stack)
{
    if (isEmpty(stack))
    {
        std::cerr << "Stack is empty!" << std::endl;
        return 0;
    }

    int poppedData = stack->top->data;
    Node *temp = stack->top;
    stack->top = stack->top->next;
    delete temp;
    return poppedData;
}

void deleteStack(Stack *stack)
{
    Node *current = stack->top;
    while (current != nullptr)
    {
        Node *temp = current;
        current = current->next;
        delete temp;
    }
    delete stack;
    std::cout << "Stack deleted successfully!" << std::endl;
}