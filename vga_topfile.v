`timescale 1ns / 1ps

module vga_top(
	input ClkPort,
	input BtnC,
	input BtnU,
	input BtnD,
	input BtnR,
	input BtnL,
	//VGA signal
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	
	//SSG signal 
	output An0, An1, An2, An3, An4, An5, An6, An7,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	
	output MemOE, MemWR, RamCS, QuadSpiFlashCS
	);
	wire Reset;
	assign Reset=BtnC;
	wire bright;
	wire[9:0] hc, vc;
	wire[3:0] lives;
	wire [6:0] ssdOut;
	wire up,left,right,down;
	wire [3:0] anode;
	wire [11:0] rgb;
	wire rst;
	
	reg [27:0]	DIV_CLK;
	always @ (posedge ClkPort, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
	  else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	wire move_clk;
	assign move_clk=DIV_CLK[19]; //slower clock to drive the movement of objects on the vga screen
	wire [11:0] background;
	display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
	game_control sc(.clk(move_clk), .bright(bright), .rst(BtnC), .up(BtnU), .down(BtnD),.left(BtnL),.right(BtnR),.hCount(hc), .vCount(vc), .rgb(rgb), .background(background), .lives(lives));
	display_lives cnt(.clk(ClkPort), .displayNumber(lives), .anode(anode), .ssdOut(ssdOut));

	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;
	assign {An7, An6, An5, An4, An3, An2, An1, An0} = {4'b1111, anode};
	// reg [7:0]  SSD_CATHODES;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg} = ssdOut[6 : 0];

endmodule
