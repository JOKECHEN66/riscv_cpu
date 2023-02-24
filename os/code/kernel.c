#include "os.h"

extern void os_main(void);


void start_kernel(void)
{

    asm volatile("li s7,  1"
                 :
                 :);
    for (int i = 5000; i > 0; i--);
    os_main();

    while (1)
    {
    }; // stop here!
}
