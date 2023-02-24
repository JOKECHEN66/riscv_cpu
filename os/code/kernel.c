#include "os.h"

extern void os_main(void);


void start_kernel(void)
{

    os_main();

    while (1)
    {
    }; // stop here!
}
