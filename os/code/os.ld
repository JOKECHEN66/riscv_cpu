/* 指定目标处理器的体系结构为 RISC-V */
OUTPUT_ARCH( "riscv" )

/* 指定程序的入口点为 _start 函数 */
ENTRY( _start )

/* 定义内存区域，包括 RAM 的起始地址和大小这里的1000代表实际物理地址 */
MEMORY
{
	ram   (wxa!ri) : ORIGIN = 0x00001000, LENGTH = 128M
}

/*
定义代码和数据段的起始位置和大小，并将它们分别放入 RAM 中的不同段
程序的代码段、只读数据段、数据段和 BSS 段分别被分配到 RAM 中不同的地址段，
而且在不同的段中分配的内存区域也不同。
此外，还定义了一些与内存相关的符号，包括程序的内存起始地址、内存结束地址、堆的起始地址以及堆的大小。
在编译时，链接器将根据这个脚本定义的内存布局将程序的代码和数据段分配到正确的内存地址，
并为程序的运行提供正确的内存空间
*/
SECTIONS
{
	.text : {
		PROVIDE(_text_start = .);
		*(.text .text.*)
		PROVIDE(_text_end = .);
	} >ram

	.rodata : {
		PROVIDE(_rodata_start = .);
		*(.rodata .rodata.*)
		PROVIDE(_rodata_end = .);
	} >ram

	.data : {
		. = ALIGN(4096);
		PROVIDE(_data_start = .);
		*(.sdata .sdata.*)
		*(.data .data.*)
		PROVIDE(_data_end = .);
	} >ram

	.bss :{
		PROVIDE(_bss_start = .);
		*(.sbss .sbss.*)
		*(.bss .bss.*)
		*(COMMON)
		PROVIDE(_bss_end = .);
	} >ram

	PROVIDE(_memory_start = ORIGIN(ram));
	PROVIDE(_memory_end = ORIGIN(ram) + LENGTH(ram));

	PROVIDE(_heap_start = _bss_end);
	PROVIDE(_heap_size = _memory_end - _heap_start);
}
