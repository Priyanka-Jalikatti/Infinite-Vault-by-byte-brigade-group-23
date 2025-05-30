module Phase1_FSM(
    input wire clk,
    input wire reset,
    input wire code_in,
    output reg phase1_done,
    output reg phase1_fail
);

    reg [2:0] state, next_state;
    localparam S0=3'd0, S1=3'd1, S2=3'd2, S3=3'd3, DONE=3'd4, FAIL=3'd5;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        phase1_done = 0;
        phase1_fail = 0;
        case(state)
            S0: next_state = code_in ? S1 : S0;
            S1: next_state = code_in ? S1 : S2;
            S2: next_state = code_in ? S3 : S0;
            S3: next_state = code_in ? DONE : S0;
            DONE: begin
                phase1_done = 1;
                next_state = DONE;
            end
            FAIL: begin
                phase1_fail = 1;
                next_state = FAIL;
            end
            default: next_state = S0;
        endcase
    end
endmodule
