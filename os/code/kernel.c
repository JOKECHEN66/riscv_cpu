#include "os.h"

extern void os_main(void);

void task_delay(volatile int count)
{
	count *= 50000;
	while (count--);
}

void start_kernel(void)
{

    asm volatile("li s7,  1" : :);
    task_delay(5000);
	os_main();
    
	while (1) {}; // stop here!
}

