#include "os.h"

/* 调用了在entry.S中定义的switch_to函数 */
extern void switch_to(struct context *next);

#define MAX_TASKS 10
#define STACK_SIZE 1024
uint8_t task_stack[MAX_TASKS][STACK_SIZE];

// task列表
struct context ctx_tasks[MAX_TASKS];

/*
 * _top指向task stack的top
 * _current指向current task
 */
static int _top = 0;
static int _current = -1;

static void w_mscratch(reg_t x)
{
	asm volatile("csrw mscratch, %0" : : "r" (x));
}

void sched_init()
{
	w_mscratch(0); //初始化的时候，不存在前一个任务，所以置0
}

/*
 * 先进先出的循环队列，每次调用 都会切换到下一个任务
 */
void schedule()
{
	if (_top <= 0) {
		return;
	}

	_current = (_current + 1) % _top;
	struct context *next = &(ctx_tasks[_current]);
	switch_to(next);
}

/*
如果task list未满，就新建任务放进去(存储了上一个任务到sp中，当前任务到ra)
*/
int task_create(void (*start_routin)(void))
{
	if (_top < MAX_TASKS) {
		ctx_tasks[_top].sp = (reg_t) &task_stack[_top][STACK_SIZE - 1];
		ctx_tasks[_top].ra = (reg_t) start_routin;
		_top++;
		return 0;
	} else {
		return -1;
	}
}

/*
主动调用来进行调度
 */
void task_yield()
{
	schedule();
}

/*
 * CPU空转/数数 
 */
void task_delay(volatile int count)
{
	count *= 50000;
	while (count--);
}

