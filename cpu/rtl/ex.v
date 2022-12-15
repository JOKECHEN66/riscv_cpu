`include "defines.v"


module ex (
    // from id_ex
    input wire[31: 0] inst_i,
    input wire[31: 0] inst_addr_i,
    input wire[31: 0] op1_i,
    input wire[31: 0] op2_i,
    input wire[4: 0]  rd_addr_i,
    input wire        rd_wen_i,

    // to regs
    output reg[4: 0]  rd_addr_o,
    output reg[31: 0] rd_data_o,
    output reg        rd_wen_o,

    // to ctrl
    output reg[31: 0] jump_addr_o,
    output reg        jump_en_o,
    output reg        hold_flag_o
);


    // I型指令结构
    wire[6: 0] opcode;
    wire[4: 0] rd;
    wire[2: 0] func3;
    wire[4: 0] rs1;
    wire[11: 0] imm;

    // R型指令的额外结构，把11位立即数拆分为func7和rs2
    wire[4: 0] rs2;
    wire[6: 0] func7;


    // I型指令分配
    assign opcode = inst_i[6: 0];
    assign rd     = inst_i[11: 7];
    assign func3  = inst_i[14: 12];
    assign rs1    = inst_i[19: 15];
    assign imm    = inst_i[31: 20];

    // R型指令的额外分配
    assign func7  = inst_i[31: 25];
    assign rs2    = inst_i[24: 20];


    // B型指令
    // B型指令中的跳转立即数扩充
    wire[31: 0] jump_imm = {{19{inst_i[31]}}, inst_i[31], inst_i[7], inst_i[30: 25], inst_i[11: 8], 1'b0};
    wire        op1_i_equal_op2_i;
    wire        op1_i_less_op2_i_signed;        // 有符号比较 小于
    wire        op1_i_less_op2_i_unsigned;      // 无符号比较 小于
    
    assign      op1_i_equal_op2_i = (op1_i == op2_i) ? 1'b1 : 1'b0;
    assign	    op1_i_less_op2_i_signed = ($signed(op1_i) < $signed(op2_i))?1'b1:1'b0;
    assign	    op1_i_less_op2_i_unsigned = (op1_i < op2_i)?1'b1:1'b0;


     // ALU
    wire[31:0] op1_i_add_op2_i;
    wire[31:0] op1_i_xor_op2_i;
    wire[31:0] op1_i_or_op2_i;
    wire[31:0] op1_i_and_op2_i;
    wire[31:0] op1_i_shift_letf_op2_i;
    wire[31:0] op1_i_shift_right_op2_i;

    assign op1_i_add_op2_i           = op1_i + op2_i;		// 加法器
    assign op1_i_xor_op2_i          = op1_i ^ op2_i;        // 异或
    assign op1_i_or_op2_i           = op1_i | op2_i;        // 或
    assign op1_i_and_op2_i          = op1_i & op2_i;        // 与
    assign op1_i_shift_letf_op2_i 	 = op1_i << op2_i;			    // 左移
    assign op1_i_shift_right_op2_i 	 = op1_i >> op2_i;			    // 右移

    // type I
    wire[31:0] SRA_mask;
    assign SRA_mask = (32'hffff_ffff) >> op2_i[4:0];            // 掩码SRA_mask与rs1移动相同位数

    always @(*) begin
        case (opcode)
            `INST_TYPE_I: begin
                // 加法指令下不发生跳转
                jump_addr_o = 32'b0;
                jump_en_o = 1'b0;
                hold_flag_o = 1'b0;
                case (func3)
                    `INST_ADDI: begin
                        rd_data_o = op1_i_add_op2_i;
                        rd_addr_o = rd_addr_i;
                        rd_wen_o = 1'b1;
                    end
                    `INST_XORI:begin
						rd_data_o = op1_i_xor_op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end					
					`INST_ORI:begin
						rd_data_o = op1_i_or_op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end					
					`INST_ANDI:begin
						rd_data_o = op1_i_and_op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end	
                    `INST_SLTI:begin            // 有符号 set less than imm
						rd_data_o = {31'b0,op1_i_less_op2_i_signed};
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end					
					`INST_SLTIU:begin          // 无符号 set less than imm
						rd_data_o = {31'b0,op1_i_less_op2_i_unsigned};
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end					
					`INST_SLLI:begin            // SLLI 逻辑左移
						rd_data_o = op1_i_shift_letf_op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;					
					end
					`INST_SRI:begin
						if(func7[5] == 1'b1) begin          //SRAI 算数右移，高位需要补符号位
							rd_data_o = ((op1_i_shift_right_op2_i) & SRA_mask) | ({32{op1_i[31]}} & (~SRA_mask));
							// (op1_i_shift_right_op2_i) & SRA_mask)取操作数， ({32{op1_i[31]}} & (~SRA_mask))取符号
                            rd_addr_o = rd_addr_i;
							rd_wen_o  = 1'b1;							
						end
						else begin                          //SRLI 逻辑右移
							rd_data_o = op1_i_shift_right_op2_i;
							rd_addr_o = rd_addr_i;
							rd_wen_o  = 1'b1;							
						end
					end			
                    default: begin
                        rd_data_o = 32'b0;
                        rd_addr_o = 5'b0;
                        rd_wen_o = 1'b0;
                    end
                endcase
            end
            `INST_TYPE_R_M: begin
                // 同上
                jump_addr_o = 32'b0;
                jump_en_o = 1'b0;
                hold_flag_o = 1'b0;
                case (func3)
                    `INST_ADD_SUB: begin
                        // 判断加减法
                        if (func7 == 7'b000_0000) begin
                            rd_data_o = op1_i_add_op2_i;
                            rd_addr_o = rd_addr_i;
                            rd_wen_o = 1'b1;
                        end else if (func7 == 7'b010_0000) begin
                            rd_data_o = op1_i - op2_i;
                            rd_addr_o = rd_addr_i;
                            rd_wen_o = 1'b1;
                        end
                    end
                    `INST_XOR:begin
						rd_data_o = op1_i_xor_op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;	
					end	
					`INST_OR:begin
						rd_data_o = op1_i_or_op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;	
					end
					`INST_AND:begin
						rd_data_o = op1_i_and_op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;	
					end
                    `INST_SLT:begin            // 有符号 set less than
						rd_data_o = {31'b0,op1_i_less_op2_i_signed};
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;	
					end
					`INST_SLTU:begin          // 无符号 set less than
						rd_data_o = {31'b0,op1_i_less_op2_i_unsigned};
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;	
					end
                    `INST_SLL:begin            // SLLI 逻辑左移
						rd_data_o = op1_i_shift_letf_op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;					
					end
                    `INST_SR:begin
						if(func7[5] == 1'b1) begin          //SRAI 算数右移，高位需要补符号位
							rd_data_o = ((op1_i_shift_right_op2_i) & SRA_mask) | ({32{op1_i[31]}} & (~SRA_mask));
							// (op1_i_shift_right_op2_i) & SRA_mask)取操作数， ({32{op1_i[31]}} & (~SRA_mask))取符号
                            rd_addr_o = rd_addr_i;
							rd_wen_o  = 1'b1;							
						end
						else begin                          //SRLI 逻辑右移
							rd_data_o = op1_i_shift_right_op2_i;
							rd_addr_o = rd_addr_i;
							rd_wen_o  = 1'b1;							
						end
					end				 
                    default: begin
                        rd_data_o = 32'b0;
                        rd_addr_o = 5'b0;
                        rd_wen_o = 1'b0;
                    end
                endcase
            end
            `INST_TYPE_B: begin
                // 条件跳转指令下不发生写回
                rd_data_o = 32'b0;
                rd_addr_o = 5'b0;
                rd_wen_o = 1'b0;
                case (func3)
                    `INST_BEQ: begin
                        jump_addr_o = (inst_addr_i + jump_imm) & {32{(op1_i_equal_op2_i)}};     // 若rs1 == rs2则发生跳转
                        jump_en_o = op1_i_equal_op2_i;
                        hold_flag_o = 1'b0;
                    end
                    `INST_BNE: begin
                        jump_addr_o = (inst_addr_i + jump_imm) & {32{(~op1_i_equal_op2_i)}};    // 若rs1 != rs2则发生跳转
                        jump_en_o = ~op1_i_equal_op2_i;
                        hold_flag_o = 1'b0;
                    end
                    default: begin
                        jump_addr_o = 32'b0;
                        jump_en_o = 1'b0;
                        hold_flag_o = 1'b0;
                    end 
                endcase
            end
            `INST_JAL:begin
				rd_data_o = inst_addr_i + 32'h4;
				rd_addr_o = rd_addr_i;
				rd_wen_o  = 1'b1;
				jump_addr_o = op1_i + inst_addr_i;
				jump_en_o	= 1'b1;
				hold_flag_o = 1'b0;				
			end
			`INST_LUI:begin
				rd_data_o = op1_i;
				rd_addr_o = rd_addr_i;
				rd_wen_o  = 1'b1;
				jump_addr_o = 32'b0;
				jump_en_o	= 1'b0;
				hold_flag_o = 1'b0;			
			end		
            default: begin
                rd_data_o = 32'b0;
                rd_addr_o = 5'b0;
                rd_wen_o = 1'b0;
                jump_addr_o = 32'b0;
                jump_en_o = 1'b0;
                hold_flag_o = 1'b0;
            end
        endcase
    end
    
endmodule
