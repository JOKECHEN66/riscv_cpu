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
    output reg        reg_wen,
    output reg[31:0]  base_addr_o,
	output reg[31:0]  addr_offset_o,

    // to mem read 
    output reg       mem_rd_req_o,
    output reg[31:0] mem_rd_addr_o	
);  

    ///////// 具体指令集详见rsic-v指令集官方文档 /////////
    // I型指令结构
    wire[6: 0] opcode;
    wire[4: 0] rd;
    wire[2: 0] func3;
    wire[4: 0] rs1;
    wire[11: 0] imm;
    wire[4:0]  shamt;   //移位数，32位数最多左移5位

    // R型指令的额外结构，把11位立即数拆分为func7和rs2
    wire[4: 0] rs2;
    wire[6: 0] func7;


    // I型指令空间分配
    assign opcode = inst_i[6: 0];
    assign rd     = inst_i[11: 7];
    assign func3  = inst_i[14: 12];
    assign rs1    = inst_i[19: 15];
    assign imm    = inst_i[31: 20];
    assign shamt  = inst_i[24:20];

    // R型指令的额外空间分配
    assign func7  = inst_i[31: 25];
    assign rs2    = inst_i[24: 20];

    always @(*) begin
        inst_o = inst_i;
        inst_addr_o = inst_addr_i;
        case (opcode)
            `INST_TYPE_I: begin
                // I型无需计算PC跳转地址
                base_addr_o		= 32'b0;
				addr_offset_o	= 32'b0;
                mem_rd_req_o    = 1'b0 ;
				mem_rd_addr_o   = 32'b0;
                case (func3)
                    `INST_ADDI,`INST_SLTI,`INST_SLTIU,`INST_XORI,`INST_ORI,`INST_ANDI:begin
						rs1_addr_o = rs1;
						rs2_addr_o = 5'b0;
						op1_o 	   = rs1_data_i;
						op2_o      = {{20{imm[11]}},imm};
						rd_addr_o  = rd;
						reg_wen    = 1'b1;
					end
					`INST_SLLI,`INST_SRI:begin
						rs1_addr_o = rs1;
						rs2_addr_o = 5'b0;
						op1_o 	   = rs1_data_i;
						op2_o      = {27'b0,shamt};
						rd_addr_o  = rd;
						reg_wen    = 1'b1;					
					end
                    default: begin
                        rs1_addr_o = 5'b0;
                        rs2_addr_o = 5'b0;
                        op1_o      = 32'b0;
                        op2_o      = 32'b0;
                        rd_addr_o  = 5'b0;
                        reg_wen    = 1'b0;
                    end
                endcase
            end 
            `INST_TYPE_R_M: begin
                // R型无需计算PC跳转地址
                base_addr_o		= 32'b0;
				addr_offset_o	= 32'b0;
                mem_rd_req_o    = 1'b0 ;
				mem_rd_addr_o   = 32'b0;
                case (func3)
                    `INST_ADD_SUB,`INST_XOR,`INST_OR,`INST_AND,`INST_SLT,`INST_SLTU: begin
                        rs1_addr_o = rs1;
                        rs2_addr_o = rs2;
                        op1_o      = rs1_data_i;
                        op2_o      = rs2_data_i;
                        rd_addr_o  = rd;
                        reg_wen    = 1'b1;
                    end
                    `INST_SLL,`INST_SR:begin
						rs1_addr_o = rs1;
						rs2_addr_o = rs2;
						op1_o 	   = rs1_data_i;
						op2_o      = {27'b0,rs2_data_i[4:0]};   // 32位数移位操作不超过5位
						rd_addr_o  = rd;
						reg_wen    = 1'b1;					
					end 
                    default: begin
                        rs1_addr_o = 5'b0;
                        rs2_addr_o = 5'b0;
                        op1_o      = 32'b0;
                        op2_o      = 32'b0;
                        rd_addr_o  = 5'b0;
                        reg_wen    = 1'b0;
                    end
                endcase
            end
            `INST_TYPE_B: begin
                mem_rd_req_o    = 1'b0 ;
				mem_rd_addr_o   = 32'b0;
                case (func3)
                    `INST_BNE, `INST_BEQ,`INST_BLT,`INST_BLTU,`INST_BGE,`INST_BGEU: begin
                        rs1_addr_o = rs1;
                        rs2_addr_o = rs2;
                        op1_o      = rs1_data_i;
                        op2_o      = rs2_data_i;
                        rd_addr_o  = 5'b0;
                        reg_wen    = 1'b0;
                        // 计算PC跳转地址
                        base_addr_o	  = inst_addr_i;
				        addr_offset_o = {{19{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
                        // 最低位默认补0，高位做立即数拓展
                    end
                    default: begin
                        rs1_addr_o    = 5'b0;
                        rs2_addr_o    = 5'b0;
                        op1_o         = 32'b0;
                        op2_o         = 32'b0;
                        rd_addr_o     = 5'b0;
                        reg_wen       = 1'b0;
                        base_addr_o	  = 32'b0;
						addr_offset_o = 32'b0;
                    end 
                endcase
            end
            `INST_TYPE_L:begin
                case(func3)
                    `INST_LW,`INST_LH,`INST_LB,`INST_LHU,`INST_LBU:begin
                        mem_rd_req_o  = 1'b1;
                        mem_rd_addr_o = rs1_data_i + {{20{imm[11]}},imm};
                        rs1_addr_o    = rs1;
                        rs2_addr_o    = 5'b0;
                        op1_o         = 32'b0;
                        op2_o         = 32'b0;
                        rd_addr_o     = rd;
                        reg_wen       = 1'b1;
                        base_addr_o   = rs1_data_i;
						addr_offset_o = {{20{imm[11]}},imm};
                    end
                    default:begin
                        mem_rd_req_o  = 1'b0;
                        mem_rd_addr_o = 32'b0;
                        rs1_addr_o    = 5'b0;
                        rs2_addr_o    = 5'b0;
                        op1_o         = 32'b0;
                        op2_o         = 32'b0;
                        rd_addr_o     = 5'b0;
                        reg_wen       = 1'b1;
                    end
                endcase
            end
            `INST_TYPE_S:begin
				case(func3)
					`INST_SW,`INST_SH,`INST_SB:begin
						mem_rd_req_o  = 1'b0;
						mem_rd_addr_o = 32'b0;
						rs1_addr_o    = rs1;
						rs2_addr_o    = rs2;
						op1_o 	      = 32'b0;
						op2_o         = rs2_data_i;
						rd_addr_o     = 5'b0;
						reg_wen       = 1'b0;
						base_addr_o   = rs1_data_i;
						addr_offset_o = {{20{inst_i[31]}},inst_i[31:25],inst_i[11:7]};						
					end
					default:begin
						mem_rd_req_o  = 1'b0;
						mem_rd_addr_o = 32'b0;
						rs1_addr_o    = 5'b0;
						rs2_addr_o    = 5'b0;
						op1_o 	      = 32'b0;
						op2_o         = 32'b0;
						rd_addr_o     = 5'b0;
						reg_wen       = 1'b0;
						base_addr_o   = 32'b0;
						addr_offset_o = 32'b0;						
					end
				endcase
			end
            `INST_JAL: begin
                mem_rd_req_o  = 1'b0 ;
				mem_rd_addr_o = 32'b0;
				rs1_addr_o    = 5'b0;
				rs2_addr_o    = 5'b0;
                // J型指令需要将当前PC + 4存入寄存器中
				op1_o 	      = inst_addr_i;
				op2_o         = 32'h4;
				rd_addr_o     = rd;
				reg_wen       = 1'b1;
                // JAL 跳转地址为PC+imm
				base_addr_o	  = inst_addr_i;
				addr_offset_o = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
			end
            `INST_JALR: begin
                mem_rd_req_o  = 1'b0 ;
				mem_rd_addr_o = 32'b0;
				rs1_addr_o    = rs1;
				rs2_addr_o    = 5'b0;
                // J型指令需要将当前PC + 4存入寄存器中
				op1_o 	      = inst_addr_i;
				op2_o         = 32'h4;
				rd_addr_o     = rd;
				reg_wen       = 1'b1;
                // JAL 跳转地址为rs1+imm
				base_addr_o	  = rs1_data_i;
				addr_offset_o = {{20{imm[11]}},imm};
			end
			`INST_LUI: begin
                mem_rd_req_o  = 1'b0 ;
				mem_rd_addr_o = 32'b0;
				rs1_addr_o    = 5'b0;
				rs2_addr_o    = 5'b0;
				op1_o 	      = {inst_i[31:12], 12'b0};        // rd = imm << 12
				op2_o         = 32'b0;
				rd_addr_o     = rd;
				reg_wen       = 1'b1;
                base_addr_o	  = 32'b0;
				addr_offset_o = 32'b0;							
			end
            `INST_AUIPC:begin
                mem_rd_req_o  = 1'b0 ;
				mem_rd_addr_o = 32'b0;
				rs1_addr_o    = 5'b0;
				rs2_addr_o    = 5'b0;
				op1_o 	      = {inst_i[31:12],12'b0};         // rd = (imm << 12) + PC
				op2_o         = inst_addr_i;
				rd_addr_o     = rd;
				reg_wen       = 1'b1;	
				base_addr_o	  = 32'b0;
				addr_offset_o = 32'b0;				
			end			
            default: begin
                mem_rd_req_o  = 1'b0 ;
				mem_rd_addr_o = 32'b0;
                rs1_addr_o    = 5'b0;
                rs2_addr_o    = 5'b0;
                op1_o         = 32'b0;
                op2_o         = 32'b0;
                rd_addr_o     = 5'b0;
                reg_wen       = 1'b0;
                base_addr_o	  = 32'b0;
				addr_offset_o = 32'b0;		
            end
        endcase
    end

    
endmodule
