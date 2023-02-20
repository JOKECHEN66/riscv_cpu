#include "os.h"

/*
 * Following functions SHOULD be called ONLY ONE time here,
 * so just declared here ONCE and NOT included in file os.h.
 */
extern void uart_init(void);
extern void sched_init(void);
extern void schedule(void);
extern void os_main(void);

void start_kernel(void)
{
    asm volatile("li gp,  0" : :);
	uart_init();
	uart_puts("Hello, OS!\n");

	sched_init();

	os_main();

	schedule();

    // End flag
    asm volatile("li s11,  1" : :);

    uart_puts("Error, should`t go here.");
	while (1) {}; // stop here!
}

