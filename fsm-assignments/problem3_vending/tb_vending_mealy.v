`timescale 1ns/1ps

module tb_vending_mealy;
    reg clk, rst;
    reg [1:0] coin;   // 01=5, 10=10, 00=idle
    wire dispense, chg5;

    // DUT 
    vending_mealy dut (
        .clk(clk),
        .rst(rst),
        .coin(coin),
        .dispense(dispense),
        .chg5(chg5)
    );

    // Clock generation: 100MHz -> 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // to insert a coin 
    task insert_coin(input [1:0] c);
    begin
        coin = c; #10;
        coin = 2'b00; #10;
    end
    endtask

    // Stimulus
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_vending_mealy);

        // Reset
        rst = 1; coin = 2'b00;
        #12 rst = 0;


        // Exact 20 scenarios
        $display("Test: 5 + 5 + 10 = 20 (dispense)");
        insert_coin(2'b01); // 5
        insert_coin(2'b01); // 5
        insert_coin(2'b10); // 10
        #20;

        $display("Test: 5 + 10 + 5 = 20 (dispense)");
        insert_coin(2'b01);
        insert_coin(2'b10);
        insert_coin(2'b01);
        #20;

        $display("Test: 10 + 5 + 5 = 20 (dispense)");
        insert_coin(2'b10);
        insert_coin(2'b01);
        insert_coin(2'b01);
        #20;

        $display("Test: 10 + 10 = 20 (dispense)");
        insert_coin(2'b10);
        insert_coin(2'b10);
        #20;

        $display("Test: 15 + 5 = 20 (dispense)");
        insert_coin(2'b10);
        insert_coin(2'b01);
        insert_coin(2'b01);
        insert_coin(2'b01);
        #20;


        // Overpay = 25
        $display("Test: 15 + 10 = 25 (dispense + chg5)");
        insert_coin(2'b10);
        insert_coin(2'b01);
        insert_coin(2'b01);
        insert_coin(2'b10);
        #20;

        $display("Test: just 5 (no vend)");
        insert_coin(2'b01);
        #20;

        $display("Test: just 10 (no vend)");
        insert_coin(2'b10);
        #20;

        $display("Test: 10 + 10 = 20 (vend)");
        insert_coin(2'b10);
        #20;

        $display("Test: 10+5 + 10 = 25 (vend with change)");
        insert_coin(2'b10); // 10
        insert_coin(2'b01); // 5
        insert_coin(2'b10); // 10
        #20;
    


        $display("Test: reset during transaction");
        insert_coin(2'b10);
        insert_coin(2'b01); // total = 15
        rst = 1; #10; rst = 0; // reset 
        insert_coin(2'b10); // new
        #20;

        $finish;
    end

endmodule