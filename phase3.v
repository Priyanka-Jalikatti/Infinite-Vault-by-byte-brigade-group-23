module Phase3_FSM(
    input wire clk,
    input wire reset,
    input wire [2:0] dir_in,
    output reg phase3_done,
    output reg phase3_fail
);

    reg [2:0] state, next_state;
    localparam S0=3'd0, S1=3'd1, S2=3'd2, S3=3'd3, S4=3'd4, DONE=3'd5, FAIL=3'd6;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        phase3_done = 0;
        phase3_fail = 0;
        case(state)
            S0: next_state = (dir_in == 3'b000) ? S1 : FAIL;
            S1: next_state = (dir_in == 3'b011) ? S2 : FAIL;
            S2: next_state = (dir_in == 3'b001) ? S3 : FAIL;
            S3: next_state = (dir_in == 3'b010) ? S4 : FAIL;
            S4: next_state = (dir_in == 3'b000) ? DONE : FAIL;
            DONE: begin
                phase3_done = 1;
                next_state = DONE;
            end
            FAIL: begin
                phase3_fail = 1;
                next_state = FAIL;
            end
            default: next_state = S0;
        endcase
    end
endmodule
