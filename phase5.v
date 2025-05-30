module Phase5_FSM(
    input wire clk,
    input wire reset,
    output reg [1:0] time_lock_out,
    output reg phase5_done,
    output reg phase5_fail
);

    reg [2:0] state, next_state;
    reg [3:0] timer;
    localparam S0=3'd0, S1=3'd1, S2=3'd2, S3=3'd3, DONE=3'd4, FAIL=3'd5;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            timer <= 0;
        end else begin
            state <= next_state;
            if (state != next_state) timer <= 0;
            else timer <= timer + 1;
        end
    end

    always @(*) begin
        next_state = state;
        time_lock_out = 2'b00;
        phase5_done = 0;
        phase5_fail = 0;
        case(state)
            S0: next_state = S1;
            S1: begin
                time_lock_out = 2'b01;
                if (timer == 4) next_state = S2;
            end
            S2: begin
                time_lock_out = 2'b10;
                if (timer == 4) next_state = S3;
            end
            S3: begin
                time_lock_out = 2'b11;
                if (timer == 4) next_state = DONE;
            end
            DONE: begin
                phase5_done = 1;
                next_state = DONE;
            end
            FAIL: begin
                phase5_fail = 1;
                next_state = FAIL;
            end
            default: next_state = FAIL;
        endcase
    end
endmodule
