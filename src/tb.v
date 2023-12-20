`default_nettype none
`timescale 1ns/1ps
`include "tt_um_digitaler_filter.v"
/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
module tb;

    // gjfu
    // wire up the inputs and outputs
    reg  clk_i = 1'b1;
    reg  rst_n_i = 1'b1;
    reg  [7:0] x_i;
    wire [7:0] y_o;
    

    tt_um_digitaler_filter tt_um_digitaler_filter(
    // include power ports for the Gate Level test
    `ifdef GL_TEST
        .VPWR( 1'b1),
        .VGND( 1'b0),
    `endif
        .x      (x_i),    // Dedicated inputs
        .y     (y_o),   // Dedicated outputs
        .clk        (clk_i),      // clock
        .rst_n      (rst_n_i)     // not reset
        );

    always #5 clk_i = ~clk_i;

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
	
	#10 rst_n_i = 0;
	#1 x_i = 8'h01;
	#1 x_i = 8'h02;
	#1 x_i = 8'h03;
	#1 x_i = 8'h04;

	#100 $finish;
    end

endmodule
