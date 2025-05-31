module Phase4_FSM(
    input wire clk,
    input wire reset,
    input wire [7:0] plate_in,
    output reg phase4_done,
    output reg phase4_fail,
    output reg alarm   // NEW: alarm output
);

    reg [2:0] state, next_state;
    localparam S0=3'd0, S1=3'd1, S2=3'd2, DONE=3'd3, FAIL=3'd4;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        phase4_done = 0;
        phase4_fail = 0;
        alarm = 0;   // Keep alarm inactive
        case(state)
            S0: next_state = (plate_in == 8'b10101010) ? S1 : FAIL;
            S1: next_state = (plate_in == 8'b11001100) ? S2 : FAIL;
            S2: next_state = (plate_in == 8'b11110000) ? DONE : FAIL;
            DONE: begin
                phase4_done = 1;
                next_state = DONE;
            end
            FAIL: begin
                phase4_fail = 1;
                alarm = 0;  // Even in fail, keep alarm inactive for now
                next_state = FAIL;
            end
            default: next_state = S0;
        endcase
    end
endmodule
