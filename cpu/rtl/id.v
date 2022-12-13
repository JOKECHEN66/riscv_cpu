`include "defines.v"


module id (
    // from if_id
    input wire[31: 0] inst_i,
    input wire[31: 0] inst_addr_i,

    // to regs
    output reg[4: 0] rs1_addr_o,
    output reg[4: 0] rs2_addr_o,

    // from regs
    input wire[31: 0] rs1_data_i,
    input wire[31: 0] rs2_data_i,

    // to id_ex
    output reg[31: 0] inst_o,
    output reg[31: 0] inst_addr_o,
    output reg[31: 0] op1_o,
    output reg[31: 0] op2_o,
    output reg[4: 0]  rd_addr_o,
    output reg        reg_wen
);  

    ///////// 具体指令集详见rsic-v指令集官方文档 /////////
    // I型指令结构
    wire[6: 0] opcode;
    wire[4: 0] rd;
    wire[2: 0] func3;
    wire[4: 0] rs1;
    wire[11: 0] imm;

    // R型指令的额外结构，把11位立即数拆分为func7和rs2
    wire[4: 0] rs2;
    wire[6: 0] func7;


    // I型指令空间分配
    assign opcode = inst_i[6: 0];
    assign rd     = inst_i[11: 7];
    assign func3  = inst_i[14: 12];
    assign rs1    = inst_i[19: 15];
    assign imm    = inst_i[31: 20];

    // R型指令的额外空间分配
    assign func7  = inst_i[31: 25];
    assign rs2    = inst_i[24: 20];

    always @(*) begin
        inst_o = inst_i;
        inst_addr_o = inst_addr_i;
        case (opcode)
            `INST_TYPE_I: begin
                case (func3)
                    `INST_ADDI: begin
                        rs1_addr_o = rs1;
                        rs2_addr_o = 5'b0;              // 立即数加法不需要从rs2取址
                        op1_o = rs1_data_i;
                        op2_o = {{20{imm[11]}}, imm};   // 将12位的立即数补全为32位, 此处为有符号imm, 所以只需填充最高位数值即可, 若为无符号imm则高位补0
                        rd_addr_o = rd;                 // 目标寄存器地址
                        reg_wen = 1'b1;                 // 寄存器写入信号置为1, 即需要写入
                    end 
                    default: begin
                        rs1_addr_o = 5'b0;
                        rs2_addr_o = 5'b0;
                        op1_o = 32'b0;
                        op2_o = 32'b0;
                        rd_addr_o = 5'b0;
                        reg_wen = 1'b0;
                    end
                endcase
            end 
            `INST_TYPE_R_M: begin
                case (func3)
                    `INST_ADD_SUB: begin
                        rs1_addr_o = rs1;
                        rs2_addr_o = rs2;
                        op1_o = rs1_data_i;
                        op2_o = rs2_data_i;
                        rd_addr_o = rd;
                        reg_wen = 1'b1;
                    end 
                    default: begin
                        rs1_addr_o = 5'b0;
                        rs2_addr_o = 5'b0;
                        op1_o = 32'b0;
                        op2_o = 32'b0;
                        rd_addr_o = 5'b0;
                        reg_wen = 1'b0;
                    end
                endcase
            end
            `INST_TYPE_B: begin
                case (func3)
                    `INST_BNE, `INST_BEQ: begin
                        rs1_addr_o = rs1;
                        rs2_addr_o = rs2;
                        op1_o = rs1_data_i;
                        op2_o = rs2_data_i;
                        rd_addr_o = 5'b0;
                        reg_wen = 1'b0;
                    end
                    default: begin
                        rs1_addr_o = 5'b0;
                        rs2_addr_o = 5'b0;
                        op1_o = 32'b0;
                        op2_o = 32'b0;
                        rd_addr_o = 5'b0;
                        reg_wen = 1'b0;
                    end 
                endcase
            end
            `INST_JAL: begin
                // J型指令需要将当前PC + 4存入寄存器中
				rs1_addr_o = 5'b0;
				rs2_addr_o = 5'b0;
				op1_o 	   = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
				op2_o      = 32'b0;
				rd_addr_o  = rd;
				reg_wen    = 1'b1;
			end
			`INST_LUI: begin
				rs1_addr_o = 5'b0;
				rs2_addr_o = 5'b0;
				op1_o 	   = {inst_i[31:12], 12'b0};
				op2_o      = 32'b0;
				rd_addr_o  = rd;
				reg_wen    = 1'b1;				
			end			
            default: begin
                rs1_addr_o = 5'b0;
                rs2_addr_o = 5'b0;
                op1_o = 32'b0;
                op2_o = 32'b0;
                rd_addr_o = 5'b0;
                reg_wen = 1'b0;
            end
        endcase
    end
    
endmodule
