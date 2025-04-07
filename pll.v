module pll #(
    parameter PHASE_BITS = 32,
    parameter [0:0] OPT_TRACK_FREQUENCY = 1'b1,
    parameter [PHASE_BITS-1:0] INITIAL_PHASE_STEP = 0,
    parameter [0:0] OPT_GLITCHLESS = 1'b1
) (
    input wire i_clk,
    input wire i_ld,
    input wire [PHASE_BITS-1:0] i_step,
    input wire i_ce,
    input wire i_input,
    input wire [4:0] i_lgcoeff,
    output wire [PHASE_BITS-1:0] o_phase,
    output reg [1:0] o_err
);

    // Local parameter (must be declared after the module header)
    localparam MSB = PHASE_BITS - 1;

    // Signal declarations
    reg agreed_output, lead;
    wire phase_err;
    reg [MSB:0] ctr, phase_correction, freq_correction, r_step;

    // agreed_output logic
    initial agreed_output = 0;
    always @(posedge i_clk)
    if (i_ce) begin
        if ((i_input) && (ctr[MSB]))
            agreed_output <= 1'b1;
        else if ((!i_input) && (!ctr[MSB]))
            agreed_output <= 1'b0;
    end

    // lead detection
    always @(*) begin
        if (agreed_output)
            lead = (!ctr[MSB]) && (i_input);
        else
            lead = (ctr[MSB]) && (!i_input);
    end

    // phase error detection
    assign phase_err = (ctr[MSB] != i_input);

    // phase correction calculation
    initial phase_correction = 0;
    always @(posedge i_clk)
        phase_correction <= {1'b1, {(MSB){1'b0}}} >> i_lgcoeff;

    // main phase counter
    initial ctr = 0;
    always @(posedge i_clk)
    if (i_ce) begin
        if (!phase_err)
            ctr <= ctr + r_step;
        else if (lead) begin
            if (!OPT_GLITCHLESS || r_step > phase_correction)
                ctr <= ctr + r_step - phase_correction;
        end else begin
            ctr <= ctr + r_step + phase_correction;
        end
    end

    // output current phase
    assign o_phase = ctr;

    // frequency correction calculation
    initial freq_correction = 0;
    always @(posedge i_clk)
        freq_correction <= {3'b001, {(MSB-2){1'b0}}} >> (2 * i_lgcoeff);

    // frequency step adjustment
    initial r_step = INITIAL_PHASE_STEP;
    always @(posedge i_clk)
    if (i_ld)
        r_step <= {1'b0, i_step[MSB-1:0]};
    else if ((i_ce) && (OPT_TRACK_FREQUENCY) && (phase_err)) begin
        if (lead)
            r_step <= r_step - freq_correction;
        else
            r_step <= r_step + freq_correction;
    end

    // error output encoding
    initial o_err = 2'h0;
    always @(posedge i_clk)
    if (i_ce)
        o_err <= (!phase_err) ? 2'b00 : (lead ? 2'b11 : 2'b01);

endmodule
