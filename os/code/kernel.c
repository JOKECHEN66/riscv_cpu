#include "os.h"

extern void sched_init(void);
extern void schedule(void);
extern void os_main(void);

void start_kernel(void)
{

    asm volatile("li s7,  1" : :);
	sched_init();
    asm volatile("li s7,  2" : :);

	os_main();

	schedule();

    // End flag
    asm volatile("li s11,  1" : :);

	while (1) {}; // stop here!
}

