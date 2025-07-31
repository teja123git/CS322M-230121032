`timescale 1ns / 1ps

module tb_cmp1bit;
    reg A, B;
    wire o1, o2, o3;

    cmp1bit dut (
        .A(A),
        .B(B),
        .o1(o1),
        .o2(o2),
        .o3(o3)
    );

    initial begin
        $dumpfile("cmp1bit.vcd");
        $dumpvars(0, tb_cmp1bit);

        A = 0; B = 0;
        #10; 
        $display("A=%b B=%b -> o1=%b o2=%b o3=%b", A, B, o1, o2, o3);
        A = 0; B = 1;
        #10; 
        $display("A=%b B=%b -> o1=%b o2=%b o3=%b", A, B, o1, o2, o3);
        A = 1; B = 0;
        #10; 
        $display("A=%b B=%b -> o1=%b o2=%b o3=%b", A, B, o1, o2, o3);
        A = 1; B = 1;
        #10; 
        $display("A=%b B=%b -> o1=%b o2=%b o3=%b", A, B, o1, o2, o3);

        $finish;
    end
endmodule
