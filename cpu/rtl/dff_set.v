module dff_set # (
    parameter DW = 32
)
(
    input wire clk,
    input wire rst,
    input wire hold_flag_i,
    input wire[DW - 1: 0] set_data,
    input wire[DW - 1: 0] data_i,
    output reg[DW - 1: 0] data_o
);

    always @(posedge clk) begin
        if(rst == 1'b0 || hold_flag_i == 1'b1) begin
            // 如果收到复位信号或是跳转信号则输出所需要的指令
            data_o <= set_data;
        end else begin
            // 将指令打一拍, 在下个高电平时钟信号来临时输出
            data_o <= data_i;
        end
    end

endmodule
