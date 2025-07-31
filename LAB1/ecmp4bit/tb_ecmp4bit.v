`timescale 1ns / 1ps

module tb_ecmp4bit;
    reg [3:0] A, B;
    wire eq;

    ecmp4bit dut (
        .A(A),
        .B(B),
        .eq(eq)
    );

    initial begin
        $dumpfile("ecmp4bit.vcd");
        $dumpvars(0, tb_ecmp4bit);

        A = 4'b0000; B = 4'b0000; 
        #10; 
        $display("A=%b B=%b -> eq=%b", A, B, eq);
        A = 4'b1100; B = 4'b1001; 
        #10; 
        $display("A=%b B=%b -> eq=%b", A, B, eq);
        A = 4'b1111; B = 4'b1111; 
        #10; 
        $display("A=%b B=%b -> eq=%b", A, B, eq);
        A = 4'b0101; B = 4'b1010; 
        #10; 
        $display("A=%b B=%b -> eq=%b", A, B, eq);
        A = 4'b1010; B = 4'b1010; 
        #10; 
        $display("A=%b B=%b -> eq=%b", A, B, eq);

        $finish;
    end
endmodule
