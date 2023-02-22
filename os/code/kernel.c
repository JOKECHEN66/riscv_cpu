#include "os.h"

extern void os_main(void);

void start_kernel(void)
{

    asm volatile("li s7,  1" : :);
	os_main();
    asm volatile("li s10,  1" : :);
    
	while (1) {}; // stop here!
}

