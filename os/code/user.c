#include "os.h"

#define DELAY 1000

int count = 0;

void print_task(void)
{
    printf("this is task[1]!\n");
    task_delay(DELAY);
    task_yield();
}

void count_task(void)
{
    printf("this is task[2] schedule %d times\n",count);
    count = count + 1;
    task_delay(DELAY);
    task_yield();
}

void draw_task(void)
{
    printf("this is task[3]\n");
    printf("-------\n-     -\n-     -\n-     -\n-------\n");
    task_delay(DELAY);
    task_yield();
}

/* NOTICE: DON'T LOOP INFINITELY IN main() */
void os_main(void)
{
	task_create(print_task);
    task_create(count_task);
    task_create(draw_task);
}

