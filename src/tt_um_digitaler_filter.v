`default_nettype none
`timescale 1ns/1ps


module tt_um_digitaler_filter(
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


    /* verilator lint_off UNUSEDSIGNAL */
    wire z2 = ena;
    /* verilator lint_on UNUSEDSIGNAL */
    assign uio_out[7:0] = 8'b0;
    assign uio_oe[7:0] = 8'b0;


    
    wire [7:0] const_h = uio_in;
    wire reset = rst_n;
    wire [7:0] y;
    wire [7:0] x = ui_in;
    assign uo_out[7:0] = y;

    reg [1:0] counter;
    reg [7:0] h [1:0];
    reg [7:0] x_reg [1:0];
    reg [15:0] product;
    reg [23:0] sum;
    reg h_start;
 
    always @(posedge clk or posedge reset) begin
	
    	if (reset) begin
	    counter <= 2'b00;
	    h[0] <= 8'h00;
	    h[1] <= 8'h00;
	    //h[2] <= 8'h00;
	    //h[3] <= 8'h00;
            sum <= 24'h000000;
	    product <= 16'h0000;
	    x_reg[0] <= 8'h00;
	    x_reg[1] <= 8'h00;
	    //x_reg[2] <= 8'h00;
	    //x_reg[3] <= 8'h00;
	    h_start <= 1'b1;
        end else begin
	    
	    if (h_start) begin
	    case (counter)
		2'b00:
		    h[0] <= const_h;
		2'b01:
		    h[1] <= const_h;
		2'b10:
		    h[1] <= const_h;
		2'b11:
		    h[1] <= const_h;
	    endcase

	    if (counter < 2'b01)
		counter <= counter + 1;
	    else begin
		counter <= 2'b00;
		h_start <= 1'b0;
	    end
	    end
            x_reg[0] <= x;
	    x_reg[1] <= x_reg[0];
	    //x_reg[2] <= x_reg[1];
	    //x_reg[3] <= x_reg[2];

	    product <= h[0] * x_reg[0] + h[1] * x_reg[1]; //+ h[2] * x_reg[2]; //+ h[3] * x_reg[3];
	    sum <= sum + {8'b00000000,product};

	end
    end
   assign y = (reset) ? 8'h00 : sum[15:8];
endmodule
