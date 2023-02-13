//`define INST_SIM  1
`define OS_SIM  1

module tb;

    reg clk;
    reg rst;

    wire x3 = tb.riscv_cpu_soc_inst_top.u_riscv_cpu.u_regs.regs[3];         // gp(3号寄存器)记录当前时刻在运行第几个test
    wire x26 = tb.riscv_cpu_soc_inst_top.u_riscv_cpu.u_regs.regs[26];       // s10(26号寄存器)置1是整个test结束的标志
    wire x27 = tb.riscv_cpu_soc_inst_top.u_riscv_cpu.u_regs.regs[27];       // s11(27号寄存器)置1表示仿真成功

    integer r;

    riscv_cpu_soc_top riscv_cpu_soc_inst_top(
        .clk            (clk),
        .rst            (rst),
        .uart_debug_pin (1'b0)
    );

    always #10 clk = ~clk;

    initial begin
        clk <= 1'b1;
        rst <= 1'b0;

        // 30ns后停止复位信号
        #30;
        rst <= 1'b1;

    end
    
    integer     file_r;
    integer     char_num;
    string      path;
    string      line;
    integer     count = 0;
    integer     succ_count = 0;
    integer     fail_count = 0;

`ifdef INST_SIM
    initial begin
        file_r = $fopen("filenames_for_M_inst_with_type_txt.txt", "r");
        if (file_r == 0) begin
            $display("Open file errored...");
            $finish;
        end

        char_num = $fscanf(file_r, "%s", line);
        count = count + 1;

        while ($signed(char_num) != -1) begin
            path = $sformatf(".\\RISCV_M\\%s", line);
            $readmemh(path, tb.riscv_cpu_soc_inst_top.u_rom._rom);
            wait(x26 == 32'b1);

            #200;
            if (x27 == 32'b1) begin
                succ_count = succ_count + 1;
                $display("---------PASS in %2dth TEST---------", count);
            end else begin
                fail_count = fail_count + 1;
                $display("---------FAIL in %2dth TEST---------", count);
                for (r = 0; r < 31; r = r + 1) begin
                    $display("x%2d regisiter value is %d", r, tb.riscv_cpu_soc_inst_top.u_riscv_cpu.u_regs.regs[r]);
                end
            end

            #10;
            char_num = $fscanf(file_r, "%s", line);
            count = count + 1;
        end
    
        #10;
        $fclose(file_r);

        if (succ_count == count - 1) begin
            $display("total %2d tests", count - 1);
            $display("###################");
            $display("#####PASS ALL######");
            $display("###################");
        end else begin
            $display("total %2d tests, failed %2d tests", count - 1, fail_count);
            $display("###################");
            $display("#####FIND ERR######");
            $display("###################");
        end

    end
`endif

`ifdef OS_SIM
    initial begin
        $readmemh(".\\os.elf", tb.riscv_cpu_soc_inst_top.u_rom._rom);
        $display("Loading is done...");
    end
`endif

    // sim timeout
    initial begin
        // 限制5ms的最大仿真时间
        #5000000
        $display("Time Out.");
        $finish;
    end

endmodule
