// Code your design here
`include "phase1.v"
`include "phase2.v"
`include "phase3.v"
`include "phase4.v"
`include "phase5.v"

module top_module(
    input wire clk,
    input wire reset,
    input wire code_in,
    input wire [3:0] switch_in,
    input wire [2:0] dir_in,
    input wire [7:0] plate_in,
    output wire [1:0] time_lock_out,
    output reg all_done
);

    wire phase1_done, phase1_fail;
    wire phase2_done, phase2_fail;
    wire phase3_done, phase3_fail;
    wire phase4_done, phase4_fail;
    wire phase5_done, phase5_fail;

    Phase1_FSM p1(clk, reset, code_in, phase1_done, phase1_fail);
    Phase2_FSM p2(clk, reset, switch_in, phase2_done, phase2_fail);
    Phase3_FSM p3(clk, reset, dir_in, phase3_done, phase3_fail);
    Phase4_FSM p4(clk, reset, plate_in, phase4_done, phase4_fail);
    Phase5_FSM p5(clk, reset, time_lock_out, phase5_done, phase5_fail);

    reg [2:0] phase_state, next_phase;
    localparam PHASE1=3'd1, PHASE2=3'd2, PHASE3=3'd3, PHASE4=3'd4, PHASE5=3'd5, DONE=3'd6;

    always @(posedge clk or posedge reset) begin
        if (reset)
            phase_state <= PHASE1;
        else
            phase_state <= next_phase;
    end

    always @(*) begin
        next_phase = phase_state;
        all_done = 0;

        case(phase_state)
            PHASE1: next_phase = (phase1_done) ? PHASE2 : (phase1_fail ? PHASE1 : PHASE1);
            PHASE2: next_phase = (phase2_done) ? PHASE3 : (phase2_fail ? PHASE2 : PHASE2);
            PHASE3: next_phase = (phase3_done) ? PHASE4 : (phase3_fail ? PHASE2 : PHASE3);
            PHASE4: next_phase = (phase4_done) ? PHASE5 : (phase4_fail ? PHASE2 : PHASE4);
            PHASE5: next_phase = (phase5_done) ? DONE : (phase5_fail ? PHASE2 : PHASE5);
            DONE: all_done = 1;
            default: next_phase = PHASE1;
        endcase
    end
endmodule
    
