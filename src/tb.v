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
    reg  reset_i = 1'b1;
    reg  [7:0] x_i;
    wire [7:0] y_o;
    

    tt_um_digitaler_filter 
filter(
    // include power ports for the Gate Level test
    //`ifdef GL_TEST
     //   .VPWR( 1'b1),
       // .VGND( 1'b0),
    //`endif
        .ui_in      (x_i),    // Dedicated inputs
        .uo_out     (y_o),   // Dedicated outputs
        .clk        (clk_i),      // clock
        .rst_n      (reset_i)     // not reset
        );

    always #1 clk_i = ~clk_i;

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
	
	#1 x_i = 8'h00;
	#20 reset_i = 0;
	#30 x_i = 8'hFF;
	#1 x_i = 8'h00;

	#70 $finish;
    end

endmodule
