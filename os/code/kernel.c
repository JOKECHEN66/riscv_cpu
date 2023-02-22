#include "os.h"

extern void sched_init(void);
extern void schedule(void);
extern void os_main(void);

void start_kernel(void)
{

	sched_init();

	os_main();

    // 再次进行任务调度
	schedule();

	while (1) {}; // stop here!
}

