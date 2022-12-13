`include "defines.v"

module if_id(
	input wire clk,
	input wire rst,
	input wire hold_flag_i,
	input wire [31:0]  inst_i, 
	input wire [31:0]  inst_addr_i, 	// 此处的inst_addr_i只在涉及跳转时才会被使用
	output wire[31:0]  inst_addr_o, 
	output wire[31:0]  inst_o
);

	// 如果遇到复位或者是复写信号, 则将地址置0且指令置为宏INST_NOP
	dff_set #(32) dff1(clk, rst, hold_flag_i, `INST_NOP, inst_i, inst_o);
	
	dff_set #(32) dff2(clk, rst, hold_flag_i, 32'b0, inst_addr_i, inst_addr_o);

endmodule
