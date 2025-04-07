`timescale 1ns/1ps

module plltb;

  reg clk = 0;
  reg ce = 1;
  reg input_clk = 0;
  reg ld = 0;
  reg [4:0] lgcoeff = 5'd4;
  reg [31:0] step = 32'd10000; // Changed to 32 bits

  wire [31:0] phase;
  wire [1:0] err;

  // Instantiate the module
  pll #(
    .PHASE_BITS(32),
    .OPT_TRACK_FREQUENCY(1'b1),
    .INITIAL_PHASE_STEP(32'd10000),
    .OPT_GLITCHLESS(1'b1)
  ) uut (
    .i_clk(clk),
    .i_ce(ce),
    .i_input(input_clk),
    .i_ld(ld),
    .i_step(step),
    .i_lgcoeff(lgcoeff),
    .o_phase(phase),
    .o_err(err)
  );

  // Clock generation
  always #5 clk = ~clk;
  always #20 input_clk = ~input_clk;

  // Stimulus
  initial begin
    $dumpfile("plltb.vcd");    // Output VCD file name
    $dumpvars(0, plltb);      // Dump all variables in the testbench

    #1000;  // Run for 1000 time units
    $finish;  // End simulation
  end

endmodule
