module regs (
    input wire clk,
    input wire rst,
    // from id
    input wire[4: 0] reg1_raddr_i,
    input wire[4: 0] reg2_raddr_i,

    // to id
    output reg[31: 0] reg1_rdata_o,
    output reg[31: 0] reg2_rdata_o,

    // from ex
    input wire [4: 0]  reg_waddr_i,
    input wire [31: 0] reg_wdata_i,
    input wire         reg_wen
);  
    // 32个32位的寄存器, 共128B的存储空间
    reg[31: 0] regs[0: 31];
    integer i;

    always @(*) begin
        if (rst == 1'b0) begin
            reg1_rdata_o <= 32'b0;
        end else if (reg1_raddr_i == 5'b0) begin 
            // 五位寄存器因为寄存器一共32个，需要五位二进制索引
            // 找x0寄存器
            reg1_rdata_o <= 32'b0;
        end else if (reg_wen && reg1_raddr_i == reg_waddr_i) begin
            // 解决RAW冲突问题, 若读到需要写回的数据, 则直接将写回的数据读出
            reg1_rdata_o <= reg_wdata_i; 
        end else begin
            reg1_rdata_o <= regs[reg1_raddr_i];
        end
    end

    always @(*) begin
        if (rst == 1'b0) begin
            reg2_rdata_o <= 32'b0;
        end else if (reg2_raddr_i == 5'b0) begin 
            // 五位寄存器因为寄存器一共32个，需要五位二进制索引
            // 找x0寄存器
            reg2_rdata_o <= 32'b0;
        end else if (reg_wen && reg2_raddr_i == reg_waddr_i) begin
            // 解决RAW冲突问题, 若读到需要写回的数据, 则直接将写回的数据读出
            reg2_rdata_o <= reg_wdata_i;
        end else begin
            reg2_rdata_o <= regs[reg2_raddr_i];
        end
    end

    always @(posedge clk) begin
        if(rst == 1'b0) begin
            // 所有寄存器复位
            for(i = 0; i < 31; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end else if (reg_wen && reg_waddr_i != 5'b0) begin
            // 写回寄存器, 且不能写回x0
            regs[reg_waddr_i] <= reg_wdata_i;
        end        
    end 

endmodule
