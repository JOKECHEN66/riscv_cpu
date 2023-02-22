#include "os.h"

#define DELAY 1000

void alg0()
{
    asm volatile("li s8,  4"
                 :
                 :);
}

void gcd()
{
    int n = 5;
    int arr[n];
    arr[0] = 6;
    arr[1] = 15;
    arr[2] = 9;
    arr[3] = 6;
    arr[4] = 12;

    int result = arr[0];
    for (int i = 1; i < n; i++)
    {
        int a = result, b = arr[i], temp;
        while (b != 0)
        {
            temp = b;
            b = a % b;
            a = temp;
        }
        result = a;
    }
    // printf("数组中的最大公约数为：%d\n", result);
    asm volatile("li s8,  5"
                 :
                 :);
}

void quicksort()
{
    int arr[] = {5, 3, 8, 4, 2, 7, 1, 10};
    int n = sizeof(arr) / sizeof(arr[0]);

    int left = 0;
    int right = n - 1;
    int stack[right - left + 1];
    int top = -1;
    stack[++top] = left;
    stack[++top] = right;

    while (top >= 0)
    {
        right = stack[top--];
        left = stack[top--];
        int i = left;
        int j = right;
        int pivot = arr[left];
        while (i < j)
        {
            while (i < j && arr[j] >= pivot)
            {
                j--;
            }
            arr[i] = arr[j];
            while (i < j && arr[i] <= pivot)
            {
                i++;
            }
            arr[j] = arr[i];
        }
        arr[i] = pivot;
        if (i - 1 > left)
        {
            stack[++top] = left;
            stack[++top] = i - 1;
        }
        if (i + 1 < right)
        {
            stack[++top] = i + 1;
            stack[++top] = right;
        }
    }

    // printf("排序后的数组：");
    // for (int i = 0; i < n; i++) {
    //     printf("%d ", arr[i]);
    // }
    asm volatile("li s8,  6"
                 :
                 :);
}

/* NOTICE: DON'T LOOP INFINITELY IN main() */
void os_main(void)
{
    alg0();
    asm volatile("li s8,  1" : :);
    asm volatile("li s9,  1" : :);
    asm volatile("li s8,  0" : :);
    asm volatile("li s9,  0" : :);
    for (uint64_t i = 9999999; i > 0; i--);

    gcd();
    asm volatile("li s8,  1" : :);
    asm volatile("li s9,  1" : :);
    asm volatile("li s8,  0" : :);
    asm volatile("li s9,  0" : :);
    for (uint64_t i = 9999999; i > 0; i--);

    quicksort();
    asm volatile("li s8,  1" : :);
    asm volatile("li s9,  1" : :);
    asm volatile("li s8,  0" : :);
    asm volatile("li s9,  0" : :);
    for (uint64_t i = 9999999; i > 0; i--);

    asm volatile("li s10,  1" : :);
}
