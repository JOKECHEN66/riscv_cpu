#include "os.h"


void alg0()
{
    int t = 20;
    while (t > 0){
        t--;
    }
    // #define V 6
    // int start = 0;
    // int res = {0, 3, 4, 5, 4};

    // // 定义邻接矩阵
    
    // int graph[V][V] = {
    //     {0, 2, 0, 0, 0, 1},
    //     {2, 0, 4, 1, 0, 0},
    //     {0, 4, 0, 1, 3, 0},
    //     {0, 1, 1, 0, 2, 0},
    //     {0, 0, 3, 2, 0, 1},
    //     {1, 0, 0, 0, 1, 0}
    // };

    // // 用于存储最短路径的数组
    // int dist[V];

    // // 记录哪些顶点已经处理过
    // int processed[V];

    // // 初始化距离和处理标记数组
    // for (int i = 0; i < V; i++) {
    //     dist[i] = INT_MAX;
    //     processed[i] = 0;
    // }

    // // 将起始顶点到自身的距离初始化为0
    // dist[start] = 0;

    // // 处理剩余V-1个顶点
    // for (int i = 0; i < V - 1; i++) {
    //     // 找到距离起点最近的未处理顶点
    //     int min_dist = INT_MAX;
    //     int min_dist_index;
    //     for (int j = 0; j < V; j++) {
    //         if (processed[j] == 0 && dist[j] <= min_dist) {
    //             min_dist = dist[j];
    //             min_dist_index = j;
    //         }
    //     }

    //     // 标记该顶点已经处理过
    //     processed[min_dist_index] = 1;

    //     // 更新与该顶点相邻的顶点的距离
    //     for (int j = 0; j < V; j++) {
    //         if (graph[min_dist_index][j] != 0 &&
    //             processed[j] == 0 &&
    //             dist[min_dist_index] != INT_MAX &&
    //             dist[min_dist_index] + graph[min_dist_index][j] < dist[j]) {
    //             dist[j] = dist[min_dist_index] + graph[min_dist_index][j];
    //         }
    //     }
    // }

    // int count = 0;
    // for (int i = 0; i < V; i++) {
    //     if (dist[i] == res[i]) {
    //         count++;
    //     }
    // }

    // if (count == V) {
    //     return;
    // } 
    // else {
    //     asm volatile("li s9,  1" : :);
    // }

    // // 输出结果
    // printf("顶点\t最短距离\n");
    // for (int i = 0; i < V; i++) {
    //     printf("%d\t\t%d\n", i, dist[i]);
    // }

}

void gcd()
{
    int n = 5;
    int arr[n];
    int res = 3;
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
    if (result == res) {
        return;
    }
    else {
        asm volatile("li s8,  1" : :);
    }
    // printf("数组中的最大公约数为：%d\n", result);
    // asm volatile("li s8,  5"
    //              :
    //              :);
}

void quicksort()
{
    int arr[] = {5, 3, 8, 4, 2, 7, 1, 10};
    int res[] = { 1, 2, 3, 4, 5, 7, 8, 10};
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

    int count = 0;
    for (int i = 0; i < n; i++) {
        if (arr[i] == res[i]) {
            count++;
        }
    }

    if (count == n) {
        return;
    } 
    else {
        asm volatile("li s8,  1" : :);
        asm volatile("li s9,  1" : :);
    }

    // printf("排序后的数组：");
    // for (int i = 0; i < n; i++) {
    //     printf("%d ", arr[i]);
    // }
    // asm volatile("li s8,  6"
    //              :
    //              :);
}

/* NOTICE: DON'T LOOP INFINITELY IN main() */
void os_main(void)
{   
    asm volatile("li s7,  1"
                 :
                 :);
    alg0();

    gcd();

    quicksort();

    asm volatile("li s10,  1" 
                 : 
                 :);
}
