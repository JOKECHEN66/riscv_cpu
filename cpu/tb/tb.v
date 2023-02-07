module tb;

    reg clk;
    reg rst;

    wire x3 = tb.riscv_cpu_soc_inst.riscv_cpu_inst.regs_inst.regs[3];       // gp(3号寄存器)记录当前时刻在运行第几个test
    wire x26 = tb.riscv_cpu_soc_inst.riscv_cpu_inst.regs_inst.regs[26];
    wire x27 = tb.riscv_cpu_soc_inst.riscv_cpu_inst.regs_inst.regs[27];

    integer r;

    always #10 clk = ~clk;

    initial begin
        clk <= 1'b1;
        rst <= 1'b0;

        // 30ns后停止复位信号
        #30;
        rst <= 1'b1;

    end

    // 将testbench指令读入rom中
    initial begin
        // 第一个参数是文件名，第二个参数是要写到哪个寄存器里
        $readmemh("./inst_txt/rv32ui-p-sw.txt",tb.riscv_cpu_soc_inst.rom_inst.rom_32bit.dual_ram_template_inst.memory);
    end

    initial begin
        $display("catch begin");
        wait(x26 == 32'b1);     // s10(26号寄存器)置1是整个test结束的标志

        #200;
        if (x27 == 32'b1) begin
            $display("##################");
            $display("#######PASS#######");
            $display("##################");
        end else begin
            $display("##################");
            $display("#######FAIL#######");
            $display("##################");
            $display("fail testnum is %2d", x3);
            for (r = 0; r < 31; r = r + 1) begin
                $display("x%2d regisiter value is %d", r, tb.riscv_cpu_soc_inst.riscv_cpu_inst.regs_inst.regs[r]);
            end
        end
        //$finish;
    end

    riscv_cpu_soc riscv_cpu_soc_inst(
        .clk            (clk),
        .rst            (rst)
    );

endmodule
