module ctrl (
    // from ex
    input reg[31: 0]  jump_addr_i,
    input reg         jump_en_i,
    input reg         hold_flag_ex_i,

    output reg[31: 0] jump_addr_o,
    output reg        jump_en_o,
    output reg        hold_flag_o
);

    always @(*) begin
        jump_addr_o = jump_addr_i;
        jump_en_o = jump_en_i;
        if (jump_en_i || hold_flag_ex_i) begin
            // 如果发生跳转或需要冲刷, 则冲刷信号置为1
            hold_flag_o = 1'b1; 
        end else begin
            hold_flag_o = 1'b0;
        end
    end
    
endmodule
