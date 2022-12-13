// soc文件, 例化系统级芯片, 实现处理器和rom的交互
module riscv_cpu_soc (
    input wire clk,
    input wire rst
);
    // risc_cpu_soc to rom
    wire [31: 0] riscv_cpu_inst_addr_o;     // 指令地址

    // rom to risc_cpu_soc
    wire [31: 0] rom_inst_o;                // 具体指令

    riscv_cpu riscv_cpu_inst (
        .clk                (clk),
        .rst                (rst),
        .inst_i             (rom_inst_o),
        .inst_addr_o        (riscv_cpu_inst_addr_o)
    );

    rom rom_inst (
        .inst_addr_i        (riscv_cpu_inst_addr_o),
        .inst_o             (rom_inst_o)
    );

endmodule
