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


    wire reset = ! rst_n;
    wire [7:0] y;
    wire [7:0] x = ui_in;
    assign uo_out[7:0] = y;


    reg [7:0] h [3:0];// = {8'h06, 8'h1C, 8'h1C, 8'h06};
    reg [7:0] x_reg [3:0];
    reg [15:0] product;
    reg [23:0] sum;
    integer i;
    //assign y = (rst_n) ? 8'h00 : sum[15:8];
    always @(posedge clk or posedge reset) begin
	//h <= {8'h06, 8'h1C, 8'h1C, 8'h06};
	//for (i=0;i<1;i=i+1) begin
            h[0] <= 8'h06;
	    h[1] <= 8'h1C;
	    h[2] <= 8'h1C;
	    h[3] <= 8'h06;
	//end
    	if (reset) begin
            sum <= 24'h000000;
	    product <= 16'h0000;
	    for (i=0;i<4;i=i+1) begin
            	x_reg[i] <= 8'h00;
	    end
        end else begin
            x_reg[0] <= x;
	    x_reg[1] <= x_reg[0];
	    x_reg[2] <= x_reg[1];
	    x_reg[3] <= x_reg[2];

	    product <= h[0] * x_reg[0] + h[1] * x_reg[1] + h[2] * x_reg[2] + h[3] * x_reg[3];
	    //product <= 16'h0000;
	    sum <= sum + {8'b00000000,product};
	    //sum <= sum + {{8{1'b0}},product};
	    //sum <= $signed(sum) + $signed({8'b00000000, product});
	    //sum <= {x_reg[2]*h[2],x_reg[1]*h[1],x_reg[0]*h[1]};
	    
	end
   end
   assign y = (rst_n) ? 8'h00 : sum[15:8];
endmodule
