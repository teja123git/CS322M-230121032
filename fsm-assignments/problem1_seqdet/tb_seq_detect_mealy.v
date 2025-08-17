`timescale 1ns/1ps

module tb_seq_detect_mealy;
    reg clk, rst, din;
    wire y;

    // DUT 
    seq_detect_mealy dut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .y(y)
    );

    // Clock generation: 100 MHz -> 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // toggle 5ns
    end

    // bitstream with overlaps: 11011011101
    reg [10:0] bitstream = 11'b11011011101;
    integer i;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_seq_detect_mealy);

        // Initialize
        rst = 1;
        din = 0;

        // Apply reset for a couple of cycles
        repeat(2) @(posedge clk);
        rst = 0;

        // Send bits MSB -> LSB, one per clock
        for (i = 10; i >= 0; i = i - 1) begin
            @(posedge clk);
            din = bitstream[i];
        end

        // extra idle clocks
        repeat(3) @(posedge clk);
        $finish;
    end

    // Log time, din, y
    initial begin
        $display("Time\tclk\trst\tdin\ty");
        $monitor("%0dns\t%b\t%b\t%b\t%b", $time, clk, rst, din, y);
    end

endmodule
