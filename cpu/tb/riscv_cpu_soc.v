// soc文件, 例化系统级芯片, 实现处理器和rom的交互
module riscv_cpu_soc (
    input wire clk,
    input wire rst,
    input wire debug_button,  // debug 按键
    input wire uart_rxd,
    output wire led_debug,  // debug 灯
    output wire led2
);
    // riscv_cpu to rom
    wire [31: 0] riscv_cpu_inst_addr_o;     // 指令地址

    // rom to riscv_cpu
    wire [31: 0] rom_inst_o;                // 具体指令

    // riscv_cpu to ram
    wire       riscv_cpu_mem_wr_req_o;
    wire[3:0]  riscv_cpu_mem_wr_sel_o;
    wire[31:0] riscv_cpu_mem_wr_addr_o;
    wire[31:0] riscv_cpu_mem_wr_data_o;
    wire       riscv_cpu_mem_rd_req_o;
    wire[31:0] riscv_cpu_mem_rd_addr_o;

    // ram to riscv_cpu
    wire[31:0] ram_rd_data_o;

    // uart_debug to rom
    wire       uart_debug_ce;
    wire       uart_debug_wen;
    wire[31:0] uart_debug_addr_o;
    wire[31:0] uart_debug_data_o;

    wire debug;

    debug_button_debounce debug_button_debounce_inst(
        .clk (clk),
        .rst (rst),
        .debug_button (debug_button),
        .debug (debug),
        .led_debug (led_debug)
    );

    riscv_cpu riscv_cpu_inst(
        .clk           (clk),
        .rst           (rst),
        .inst_i        (rom_inst_o),
        .inst_addr_o   (riscv_cpu_inst_addr_o),
        .mem_rd_req_o  (riscv_cpu_mem_rd_req_o),
        .mem_rd_addr_o (riscv_cpu_mem_rd_addr_o),
        .mem_rd_data_i (ram_rd_data_o),
        .mem_wr_req_o  (riscv_cpu_mem_wr_req_o),
        .mem_wr_sel_o  (riscv_cpu_mem_wr_sel_o),
        .mem_wr_addr_o (riscv_cpu_mem_wr_addr_o),
        .mem_wr_data_o (riscv_cpu_mem_wr_data_o)
    );

    assign led2 = riscv_cpu_mem_wr_data_o[2];

    ram ram_inst(
        .clk      (clk),
        .rst      (rst),
        .wen      (riscv_cpu_mem_wr_sel_o),  // 写端口
        .w_addr_i (riscv_cpu_mem_wr_addr_o),
        .w_data_i (riscv_cpu_mem_wr_data_o),
        .ren      (riscv_cpu_mem_rd_req_o),  // 读端口
        .r_addr_i (riscv_cpu_mem_rd_addr_o),
        .r_data_o (ram_rd_data_o)
    );

    rom rom_inst(
        .clk      (clk),
        .rst      (debug),
        .wen      (uart_debug_wen),  // 写端口，来自串口
        .w_addr_i (uart_debug_addr_o),
        .w_data_i (uart_debug_data_o),
        .ren      (1'b1),  // 指令读端口
        .r_addr_i (riscv_cpu_inst_addr_o),
        .r_data_o (rom_inst_o)
    );

    uart_debug uart_debug_inst(
        .clk      (clk),
        .debug    (debug),
        .uart_rxd (uart_rxd),
        .ce       (uart_debug_ce),
        .wen      (uart_debug_wen),
        .addr_o   (uart_debug_addr_o),
        .data_o   (uart_debug_data_o)
    );

endmodule
