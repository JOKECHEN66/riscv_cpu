module pc_reg(
    input wire          clk,
    input wire          rst,
    input wire [31: 0]  jump_addr_i,
    input wire          jump_en,
    output reg [31: 0]  pc_o
);

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            // 复位信号为低电平时传输32位0
            pc_o <= 32'b0;
        end else if (jump_en) begin
            // 收到跳转指令则PC指向需要跳转的地址
            pc_o <= jump_addr_i;
        end else begin
            // pc = pc + 4
            pc_o <= pc_o + 3'd4;
        end
    end

endmodule
