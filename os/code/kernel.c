#include "os.h"

extern void os_main(void);

void start_kernel(void)
{

    asm volatile("li s7,  1" : :);
    for (uint64_t i = 9999999; i > 0; i--);
	os_main();
    
	while (1) {}; // stop here!
}

