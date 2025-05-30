module Phase2_FSM(
    input wire clk,
    input wire reset,
    input wire [3:0] switch_in,
    output reg phase2_done,
    output reg phase2_fail
);

    reg [1:0] state, next_state;
    localparam IDLE=2'd0, DONE=2'd1, FAIL=2'd2;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        phase2_done = 0;
        phase2_fail = 0;
        case(state)
            IDLE: begin
                if (switch_in == 4'b1101)
                    next_state = DONE;
                else
                    next_state = FAIL;
            end
            DONE: begin
                phase2_done = 1;
                next_state = DONE;
            end
            FAIL: begin
                phase2_fail = 1;
                next_state = FAIL;
            end
        endcase
    end
endmodule
