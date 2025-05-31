// Code your testbench here
// or browse Examples

module tb_top_module;
    reg clk, reset;
    reg code_in;
    reg [3:0] switch_in;
    reg [2:0] dir_in;
    reg [7:0] plate_in;
    wire [1:0] time_lock_out;
    wire all_done;
    wire alarm; // NEW: alarm signal

    top_module uut (
        .clk(clk),
        .reset(reset),
        .code_in(code_in),
        .switch_in(switch_in),
        .dir_in(dir_in),
        .plate_in(plate_in),
        .time_lock_out(time_lock_out),
        .all_done(all_done),
        .alarm(alarm)  // NEW: connected alarm
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 time units clock period
    end

    initial begin
        // Waveform dump
        $dumpfile("vault_all_phases.vcd");
        $dumpvars(0, tb_top_module);

        // Reset system
        reset = 1; code_in=0; switch_in=0; dir_in=0; plate_in=0;
        #15 reset = 0;

        // --- Phase 1: Code Lock (1 0 1 1) ---
        #10 code_in = 1; #10 code_in = 0; #10 code_in = 1; #10 code_in = 1;

        // --- Phase 2: Switch Room (1101) ---
        #20 switch_in = 4'b1101;

        // --- Phase 3: Maze Tracker (000 011 001 010 000) ---
        #10 dir_in = 3'b000; #10 dir_in = 3'b011; #10 dir_in = 3'b001; #10 dir_in = 3'b010; #10 dir_in = 3'b000;

        // --- Phase 4: Pressure Plates (10101010 11001100 11110000) ---
        #10 plate_in = 8'b10101010; #10 plate_in = 8'b11001100; #10 plate_in = 8'b11110000;

        // --- Let Phase 5 auto-run (Time-Lock Output) ---
        #200;

        // Optional reset
        #10 reset = 1; #10 reset = 0;

        #500 $finish;
    end
endmodule
