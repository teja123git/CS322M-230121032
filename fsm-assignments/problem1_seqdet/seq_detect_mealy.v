module seq_detect_mealy(
    input  wire clk,
    input  wire rst,   // synchronous, active-high
    input  wire din,   // serial input bit per clock
    output wire y      // 1-cycle pulse when 1101 seen
);

    // State encoding
    parameter S0   = 2'b00,  // no match
              S1   = 2'b01,  // seen '1'
              S11  = 2'b10,  // seen '11'
              S110 = 2'b11;  // seen '110'

    reg [1:0] state_present, state_next;

    // State register
    always @(posedge clk) begin
        if (rst)
            state_present <= S0;
        else
            state_present <= state_next;
    end

    // Mealy output: detect when in S110 and din=1
    assign y = (state_present == S110) && (din == 1'b1);

    // Next-state logic
    always @(*) begin
        state_next = state_present; // default
        case (state_present)
            S0:   state_next = din ? S1   : S0;
            S1:   state_next = din ? S11  : S0;
            S11:  state_next = din ? S11  : S110;
            S110: state_next = din ? S11  : S0; // overlap 
            default: state_next = S0;
        endcase
    end
endmodule
