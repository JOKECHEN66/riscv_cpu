//双端口 ram，解决读写冲突
module dual_ram #(
    parameter DW = 32,   // 位宽
    parameter AW = 12,
	parameter MEM_NUM = 4096
)
(
	input wire 			clk,
	input wire 			rst,
	input wire 			wen,
	input wire[AW-1:0]	w_addr_i,
	input wire[DW-1:0]  w_data_i,
	input wire 			ren,
	input wire[AW-1:0]	r_addr_i,
	output wire[DW-1:0]  r_data_o	
);	

    reg rd_equ_wr_flag;  // 读写同时发生，且地址相等信号
    //assign rd_equ_wr_flag = (rst && wen && ren && r_addr_i == w_addr_i) ? 1'b1 : 1'b0

    reg[DW-1:0]	w_data_reg;
    wire[DW-1:0] r_data_wire;
    assign r_data_o = (rd_equ_wr_flag) ? w_data_reg : r_data_wire;

    always @(posedge clk)begin
		if(!rst)
			w_data_reg <= 'b0;
		else
			w_data_reg <= w_data_i;
	end

    // 切换
    always @(posedge clk)begin
		if(rst && wen && ren && w_addr_i == r_addr_i )
			rd_equ_wr_flag <= 1'b1;
		else if(rst && ren)
			rd_equ_wr_flag <= 1'b0;
	end
		

	dual_ram_template #(
		.DW (DW),
		.AW (AW),
		.MEM_NUM (MEM_NUM)
	)dual_ram_template_inst
	(
		.clk			(clk),
		.rst			(rst),
		.wen			(wen),
		.w_addr_i		(w_addr_i),
		.w_data_i		(w_data_i),
		.ren			(ren),
		.r_addr_i		(r_addr_i),
		.r_data_o       (r_data_wire)
	);

endmodule



module dual_ram_template #(
	parameter DW = 32,
	parameter AW = 12,
	parameter MEM_NUM = 4096
)
(
	input wire 			clk,
	input wire 			rst,
	input wire 			wen,
	input wire[AW-1:0]	w_addr_i,
	input wire[DW-1:0]  w_data_i,
	input wire 			ren,
	input wire[AW-1:0]	r_addr_i,
	output reg[DW-1:0]  r_data_o
);
    reg[DW-1:0] memory[0:MEM_NUM-1];

    // 会产生读写冲突，双口 rom 可以同时进行读写，但若读写地址相同则会发生冲突
    always @(posedge clk)begin
		if(rst && ren)
			r_data_o <= memory[r_addr_i];
	end
	
	always @(posedge clk)begin
		if(rst && wen)
			memory[w_addr_i] <= w_data_i;
	end

endmodule