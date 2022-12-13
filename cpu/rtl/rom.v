module rom (
    input wire[31: 0] inst_addr_i,
    output reg[31: 0] inst_o
);

    // 分配一个4096 * 32b的rom内存, 即16KB的内存
    reg[31: 0] rom_mem[0: 4095];

    always @(*) begin
        // 右移2位即除4, 由于risc是大端模式, 所以pc + 4即地址右移2位取址
        inst_o = rom_mem[inst_addr_i >> 2];
    end

endmodule
