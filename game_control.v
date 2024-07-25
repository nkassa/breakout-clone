`timescale 1ns / 1ps

module game_control(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input left, input right, input down,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background,
	output reg [3:0] lives 
   );
   
	wire block_fill;
	wire block_white_fill_2;
	wire block_white_fill_3;
	wire block_white_fill_4;
	wire block_white_fill_5;
	wire block_white_fill_6;
	wire block_white_fill_7;
	wire block_white_fill_8;
	wire block_white_fill_9;
	wire block_white_fill_10;
	wire block_white_fill_11;
	
	wire block_red_fill_2;
	wire block_red_fill_3;
	wire block_red_fill_4;
	wire block_red_fill_5;
	wire block_red_fill_6;
	wire block_red_fill_7;
	wire block_red_fill_8;
	wire block_red_fill_9;
	wire block_red_fill_10;
	wire block_red_fill_11;
	
	wire block_blue_fill_2;
	wire block_blue_fill_3;
	wire block_blue_fill_4;
	wire block_blue_fill_5;
	wire block_blue_fill_6;
	wire block_blue_fill_7;
	wire block_blue_fill_8;
	wire block_blue_fill_9;
	wire block_blue_fill_10;
	wire block_blue_fill_11;
	wire ball_fill;
	
	wire start_screen;
	wire win_screen;
	wire lost_screen;
	
	reg [1:0] enablewhite2;
	reg [1:0] enablewhite3;
	reg [1:0] enablewhite4;
	reg [1:0] enablewhite5;
	reg [1:0] enablewhite6;
	reg [1:0] enablewhite7;
	reg [1:0] enablewhite8;
	reg [1:0] enablewhite9;
	reg [1:0] enablewhite10;
	reg [1:0] enablewhite11;

	reg [1:0] enablered2;
	reg [1:0] enablered3;
	reg [1:0] enablered4;
	reg [1:0] enablered5;
	reg [1:0] enablered6;
	reg [1:0] enablered7;
	reg [1:0] enablered8;
	reg [1:0] enablered9;
	reg [1:0] enablered10;
	reg [1:0] enablered11;

	reg [1:0] enableblue2;
	reg [1:0] enableblue3;
	reg [1:0] enableblue4;
	reg [1:0] enableblue5;
	reg [1:0] enableblue6;
	reg [1:0] enableblue7;
	reg [1:0] enableblue8;
	reg [1:0] enableblue9;
	reg [1:0] enableblue10;
	reg [1:0] enableblue11;
	reg reg_down = 0;
	
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;
	reg [9:0] xpos2, ypos2;
	reg [1:0] move;
	reg [1:0] ydirection = 1;
	reg [1:0] xdirection = 2;
	reg [1:0] xspeed = 0;
	
	parameter BLACK  = 12'b0000_0000_0000;
	parameter WHITE  = 12'b1111_1111_1111;
	parameter RED    = 12'b1111_0000_0000;
	parameter GREEN  = 12'b0000_1111_0000;
	parameter GREY   = 12'b0101_0101_0101;
	parameter YELLOW = 12'b1111_1111_0000;
	parameter CYAN   = 12'b0000_1111_1111;
	parameter BLUE   = 12'b0000_0000_1111;

	initial begin
		lives = 3'd3;
	end

	
		
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
		if(reg_down == 1)
			if(~bright )	//force black if not inside the display area
				rgb = 12'b0000_0000_0000;
			else if (lives < 1 && lost_screen && !(enableblue2 == 0 && enableblue3 == 0 && enableblue4 == 0 && enableblue5 == 0 && enableblue6 == 0 && enableblue7 == 0 
			&& enableblue8 == 0 && enableblue9 == 0 && enableblue10 == 0 && enableblue11 == 0 && enablered2 == 0 && enablered3 == 0 && enablered4 == 0 
			&& enablered5 == 0 && enablered6 == 0 && enablered7 == 0 && enablered8 == 0 && enablered9 == 0 && enablered10 == 0 && enablered11 == 0 &&
			enablewhite2 == 0 && enablewhite3 == 0 && enablewhite4 == 0 && enablewhite5 == 0 && enablewhite6 == 0 && enablewhite7 == 0 && enablewhite8 == 0 && 
			enablewhite9 == 0 && enablewhite10 == 0 && enablewhite11 == 0))
				rgb = RED;
			else if (lives >= 1 && block_fill && !(enableblue2 == 0 && enableblue3 == 0 && enableblue4 == 0 && enableblue5 == 0 && enableblue6 == 0 && enableblue7 == 0 
			&& enableblue8 == 0 && enableblue9 == 0 && enableblue10 == 0 && enableblue11 == 0 && enablered2 == 0 && enablered3 == 0 && enablered4 == 0 
			&& enablered5 == 0 && enablered6 == 0 && enablered7 == 0 && enablered8 == 0 && enablered9 == 0 && enablered10 == 0 && enablered11 == 0 &&
			enablewhite2 == 0 && enablewhite3 == 0 && enablewhite4 == 0 && enablewhite5 == 0 && enablewhite6 == 0 && enablewhite7 == 0 && enablewhite8 == 0 && 
			enablewhite9 == 0 && enablewhite10 == 0 && enablewhite11 == 0)) 
				rgb = GREY; 
			else if (lives >= 1 && block_white_fill_2 || block_white_fill_3 || block_white_fill_4 || block_white_fill_5 || block_white_fill_6 || block_white_fill_7|| 
			block_white_fill_8 || block_white_fill_9 || block_white_fill_10 || block_white_fill_11) 
				rgb = WHITE; 
			else if (lives >= 1 && block_red_fill_2 || block_red_fill_3 || block_red_fill_4 || block_red_fill_5 || block_red_fill_6 || block_red_fill_7|| 
			block_red_fill_8 || block_red_fill_9 || block_red_fill_10 || block_red_fill_11)
				rgb = RED; 
			else if (lives >= 1 && block_blue_fill_2 || block_blue_fill_3 || block_blue_fill_4 || block_blue_fill_5 || block_blue_fill_6 || block_blue_fill_7|| 
			block_blue_fill_8 || block_blue_fill_9 || block_blue_fill_10 || block_blue_fill_11)
				rgb = BLUE;
			else if (lives >= 1 && ball_fill && !(enableblue2 == 0 && enableblue3 == 0 && enableblue4 == 0 && enableblue5 == 0 && enableblue6 == 0 && enableblue7 == 0 
			&& enableblue8 == 0 && enableblue9 == 0 && enableblue10 == 0 && enableblue11 == 0 && enablered2 == 0 && enablered3 == 0 && enablered4 == 0 
			&& enablered5 == 0 && enablered6 == 0 && enablered7 == 0 && enablered8 == 0 && enablered9 == 0 && enablered10 == 0 && enablered11 == 0 &&
			enablewhite2 == 0 && enablewhite3 == 0 && enablewhite4 == 0 && enablewhite5 == 0 && enablewhite6 == 0 && enablewhite7 == 0 && enablewhite8 == 0 && 
			enablewhite9 == 0 && enablewhite10 == 0 && enablewhite11 == 0))
				rgb = CYAN;
			else if(lives >= 1 && enableblue2 == 0 && enableblue3 == 0 && enableblue4 == 0 && enableblue5 == 0 && enableblue6 == 0 && enableblue7 == 0 
			&& enableblue8 == 0 && enableblue9 == 0 && enableblue10 == 0 && enableblue11 == 0 && enablered2 == 0 && enablered3 == 0 && enablered4 == 0 
			&& enablered5 == 0 && enablered6 == 0 && enablered7 == 0 && enablered8 == 0 && enablered9 == 0 && enablered10 == 0 && enablered11 == 0 &&
			enablewhite2 == 0 && enablewhite3 == 0 && enablewhite4 == 0 && enablewhite5 == 0 && enablewhite6 == 0 && enablewhite7 == 0 && enablewhite8 == 0 && 
			enablewhite9 == 0 && enablewhite10 == 0 && enablewhite11 == 0 && win_screen)
				rgb = GREEN;
			else	
				rgb= BLACK;	
		else if (reg_down == 0)
		  if(~bright )	//force black if not inside the display area
		      rgb = 12'b0000_0000_0000;
		  else if (start_screen)
		      rgb = YELLOW;
	end
		//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	assign block_fill= vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-50) && hCount<=(xpos+50);
	assign start_screen = ((hCount>= 10'd148) && (hCount <= 10'd776)) && ((vCount >= 10'd40) && (vCount <= 10'd600));
	assign win_screen = ((hCount>= 10'd148) && (hCount <= 10'd776)) && ((vCount >= 10'd40) && (vCount <= 10'd600));
	assign lost_screen = ((hCount>= 10'd148) && (hCount <= 10'd776)) && ((vCount >= 10'd40) && (vCount <= 10'd600));
	
	assign block_white_fill_2= ((hCount>= 10'd148) && (hCount <= 10'd209)) && ((vCount >= 10'd40) && (vCount <= 10'd90) && (enablewhite2)) ? 1 : 0;
	assign block_white_fill_3= ((hCount>= 10'd211) && (hCount <= 10'd272)) && ((vCount >= 10'd40) && (vCount <= 10'd90) && (enablewhite3)) ? 1 : 0;
	assign block_white_fill_4= ((hCount>= 10'd274) && (hCount <= 10'd335)) && ((vCount >= 10'd40) && (vCount <= 10'd90) && (enablewhite4)) ? 1 : 0;
	assign block_white_fill_5= ((hCount>= 10'd337) && (hCount <= 10'd398)) && ((vCount >= 10'd40) && (vCount <= 10'd90) && (enablewhite5)) ? 1 : 0;
	assign block_white_fill_6= ((hCount>= 10'd400) && (hCount <= 10'd461)) && ((vCount >= 10'd40) && (vCount <= 10'd90) && (enablewhite6)) ? 1 : 0;
	assign block_white_fill_7= ((hCount>= 10'd463) && (hCount <= 10'd524)) && ((vCount >= 10'd40) && (vCount <= 10'd90) && (enablewhite7)) ? 1 : 0;
	assign block_white_fill_8= ((hCount>= 10'd526) && (hCount <= 10'd587)) && ((vCount >= 10'd40) && (vCount <= 10'd90) && (enablewhite8)) ? 1 : 0;
	assign block_white_fill_9= ((hCount>= 10'd589) && (hCount <= 10'd650)) && ((vCount >= 10'd40) && (vCount <= 10'd90) && (enablewhite9)) ? 1 : 0;
	assign block_white_fill_10= ((hCount>= 10'd652) && (hCount <= 10'd713)) && ((vCount >= 10'd40) && (vCount <= 10'd90) && (enablewhite10)) ? 1 : 0;
	assign block_white_fill_11= ((hCount>= 10'd715) && (hCount <= 10'd776)) && ((vCount >= 10'd40) && (vCount <= 10'd90) && (enablewhite11)) ? 1 : 0;
	
	
	assign block_red_fill_2= ((hCount>= 10'd148) && (hCount <= 10'd209)) && ((vCount >= 10'd91) && (vCount <= 10'd141) && (enablered2)) ? 1 : 0;
	assign block_red_fill_3= ((hCount>= 10'd211) && (hCount <= 10'd272)) && ((vCount >= 10'd91) && (vCount <= 10'd141) && (enablered3)) ? 1 : 0;
	assign block_red_fill_4= ((hCount>= 10'd274) && (hCount <= 10'd335)) && ((vCount >= 10'd91) && (vCount <= 10'd141) && (enablered4)) ? 1 : 0;
	assign block_red_fill_5= ((hCount>= 10'd337) && (hCount <= 10'd398)) && ((vCount >= 10'd91) && (vCount <= 10'd141) && (enablered5)) ? 1 : 0;
	assign block_red_fill_6= ((hCount>= 10'd400) && (hCount <= 10'd461)) && ((vCount >= 10'd91) && (vCount <= 10'd141) && (enablered6)) ? 1 : 0;
	assign block_red_fill_7= ((hCount>= 10'd463) && (hCount <= 10'd524)) && ((vCount >= 10'd91) && (vCount <= 10'd141) && (enablered7)) ? 1 : 0;
	assign block_red_fill_8= ((hCount>= 10'd526) && (hCount <= 10'd587)) && ((vCount >= 10'd91) && (vCount <= 10'd141) && (enablered8)) ? 1 : 0;
	assign block_red_fill_9= ((hCount>= 10'd589) && (hCount <= 10'd650)) && ((vCount >= 10'd91) && (vCount <= 10'd141) && (enablered9)) ? 1 : 0;
	assign block_red_fill_10= ((hCount>= 10'd652) && (hCount <= 10'd713)) && ((vCount >= 10'd91) && (vCount <= 10'd141) && (enablered10)) ? 1 : 0;
	assign block_red_fill_11= ((hCount>= 10'd715) && (hCount <= 10'd776)) && ((vCount >= 10'd91) && (vCount <= 10'd141) && (enablered11)) ? 1 : 0;
	
	
	
	assign block_blue_fill_2= ((hCount>= 10'd148) && (hCount <= 10'd209)) && ((vCount >= 10'd142) && (vCount <= 10'd192) && (enableblue2)) ? 1 : 0;
	assign block_blue_fill_3= ((hCount>= 10'd211) && (hCount <= 10'd272)) && ((vCount >= 10'd142) && (vCount <= 10'd192) && (enableblue3)) ? 1 : 0;
	assign block_blue_fill_4= ((hCount>= 10'd274) && (hCount <= 10'd335)) && ((vCount >= 10'd142) && (vCount <= 10'd192) && (enableblue4)) ? 1 : 0;
	assign block_blue_fill_5= ((hCount>= 10'd337) && (hCount <= 10'd398)) && ((vCount >= 10'd142) && (vCount <= 10'd192) && (enableblue5)) ? 1 : 0;
	assign block_blue_fill_6= ((hCount>= 10'd400) && (hCount <= 10'd461)) && ((vCount >= 10'd142) && (vCount <= 10'd192) && (enableblue6)) ? 1 : 0;
	assign block_blue_fill_7= ((hCount>= 10'd463) && (hCount <= 10'd524)) && ((vCount >= 10'd142) && (vCount <= 10'd192) && (enableblue7)) ? 1 : 0;
	assign block_blue_fill_8= ((hCount>= 10'd526) && (hCount <= 10'd587)) && ((vCount >= 10'd142) && (vCount <= 10'd192) && (enableblue8)) ? 1 : 0;
	assign block_blue_fill_9= ((hCount>= 10'd589) && (hCount <= 10'd650)) && ((vCount >= 10'd142) && (vCount <= 10'd192) && (enableblue9)) ? 1 : 0;
	assign block_blue_fill_10= ((hCount>= 10'd652) && (hCount <= 10'd713)) && ((vCount >= 10'd142) && (vCount <= 10'd192) && (enableblue10)) ? 1 : 0;
	assign block_blue_fill_11= ((hCount>= 10'd715) && (hCount <= 10'd776)) && ((vCount >= 10'd142) && (vCount <= 10'd192) && (enableblue11)) ? 1 : 0;
	
	assign ball_fill =  (vCount>=(ypos2) && vCount<=(ypos2) && hCount>=(xpos2-10) && hCount<=(xpos2+10) || 
	                     vCount>=(ypos2-1) && vCount<=(ypos2+1) && hCount>=(xpos2-10) && hCount<=(xpos2+10)||
						 vCount>=(ypos2-2) && vCount<=(ypos2+2) && hCount>=(xpos2-10) && hCount<=(xpos2+10)|| 
	                     vCount>=(ypos2-3) && vCount<=(ypos2+3) && hCount>=(xpos2-8) && hCount<=(xpos2+8)||
						 vCount>=(ypos2-4) && vCount<=(ypos2+4) && hCount>=(xpos2-8) && hCount<=(xpos2+8) ||
	                     vCount>=(ypos2-5) && vCount<=(ypos2+5) && hCount>=(xpos2-6) && hCount<=(xpos2+6) ||
						 vCount>=(ypos2-6) && vCount<=(ypos2+6) && hCount>=(xpos2-6) && hCount<=(xpos2+6) ||
	                     vCount>=(ypos2-7) && vCount<=(ypos2+7) && hCount>=(xpos2-4) && hCount<=(xpos2+4)||
						 vCount>=(ypos2-7) && vCount<=(ypos2+7) && hCount>=(xpos2-4) && hCount<=(xpos2+4)||
	                     vCount>=(ypos2-8) && vCount<=(ypos2+8) && hCount>=(xpos2-2) && hCount<=(xpos2+2) ||
	                     vCount>=(ypos2-9) && vCount<=(ypos2+9) && hCount>=(xpos2-1) && hCount<=(xpos2+1));
	
	always@ (posedge clk, posedge rst)
		begin
			if(rst)
			begin
				reg_down <= 0;
				move <= 0;
			end	
		    else if (down) 
				reg_down <= 1;
			else if(up && reg_down == 1)
				move <=1;
		end
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
			begin 
				lives <= 3'd3;
				enablewhite2 <= 1;
				enablewhite3 <= 1;
				enablewhite4 <= 1;
				enablewhite5 <= 1;
				enablewhite6 <= 1;
				enablewhite7 <= 1;
				enablewhite8 <= 1;
				enablewhite9 <= 1;
				enablewhite10 <= 1;
				enablewhite11 <= 1;
				enablered2 <= 1;
				enablered3 <= 1;
				enablered4 <= 1;
				enablered5 <= 1;
				enablered6 <= 1;
				enablered7 <= 1;
				enablered8 <= 1;
				enablered9 <= 1;
				enablered10 <= 1;
				enablered11 <= 1;
				enableblue2 <= 1;
				enableblue3 <= 1;
				enableblue4 <= 1;
				enableblue5 <= 1;
				enableblue6 <= 1;
				enableblue7 <= 1;
				enableblue8 <= 1;
				enableblue9 <= 1;
				enableblue10 <= 1;
				enableblue11 <= 1;
				//rough values for center of screen
				xpos <= 450;
				ypos <= 470;
				xpos2 <= 450;
				ypos2 <= 456;
				ydirection <= 1;
				xdirection <= 2;
				xspeed <= 0;
			end
		else if (reg_down == 1)
			begin
			// bar collision
			if ((ypos2 + 4 > 465) && (ypos2 + 4 < 467) && ydirection == 0) 
				begin
					if ((xpos2 >= xpos - 50) && (xpos2 <= xpos + 50))
						ydirection <= 1;
					if ((xpos2 >= xpos - 1) && (xpos2 <= xpos + 1))
						begin
							xdirection <= 2;
							xspeed <= 0;
						end
					if ((xpos2 >= xpos - 50) && (xpos2 <= xpos -27))
						begin
							xdirection <= 0;
							xspeed <= 2;
						end
					if ((xpos2 >= xpos - 26) && (xpos2 <= xpos - 2))
						begin
							xdirection <= 0;
							xspeed <= 1;
						end
					if ((xpos2 >= xpos + 2) && (xpos2 <= xpos + 26))
						begin
							xdirection <= 1;
							xspeed <= 1;
						end
					if ((xpos2 >= xpos + 27) && (xpos2 <= xpos +50))
					begin
						xdirection <= 1;
						xspeed <= 2;
					end
			end
			begin
				// blue square bottom collision
				if ((ypos2 - 4 <= 192))
					begin
						if ((xpos2 - 10 >= 148) && (xpos2 + 10 <= 210) && (enableblue2))
						begin
							enableblue2 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 211) && (xpos2 + 10 <= 273) && (enableblue3))
						begin
							enableblue3 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 274) && (xpos2 + 10 <= 336) && (enableblue4))
						begin
							enableblue4 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 337) && (xpos2 + 10 <= 399) && (enableblue5))
						begin
							enableblue5 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 400) && (xpos2 + 10 <= 462) && (enableblue6))
						begin
							enableblue6 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 461) && (xpos2 + 10 <= 525) && (enableblue7))
						begin
							enableblue7 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 526) && (xpos2 + 10 <= 588) && (enableblue8))
						begin
							enableblue8 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 589) && (xpos2 + 10 <= 651) && (enableblue9))
						begin
							enableblue9 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 652) && (xpos2 + 10 <= 714) && (enableblue10))
						begin
							enableblue10 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 715) && (xpos2 + 10 <= 778) && (enableblue11))
						begin
							enableblue11 <= 0;
							ydirection = 0;
						end
					end
			end
			begin
				// blue square top collision
				if ((ypos2 + 4 <= 146) && (ypos2 + 4 >= 142) && (ydirection == 0))
					begin
						if ((xpos2 - 10 >= 148) && (xpos2 + 10 <= 210) && (enableblue2))
						begin
							enableblue2 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 211) && (xpos2 + 10 <= 273) && (enableblue3))
						begin
							enableblue3 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 274) && (xpos2 + 10 <= 336) && (enableblue4))
						begin
							enableblue4 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 337) && (xpos2 + 10 <= 399) && (enableblue5))
						begin
							enableblue5 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 400) && (xpos2 + 10 <= 462) && (enableblue6))
						begin
							enableblue6 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 463) && (xpos2 + 10 <= 525) && (enableblue7))
						begin
							enableblue7 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 526) && (xpos2 + 10 <= 588) && (enableblue8))
						begin
							enableblue8 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 589) && (xpos2 + 10 <= 651) && (enableblue9))
						begin
							enableblue9 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 652) && (xpos2 + 10 <= 714) && (enableblue10))
						begin
							enableblue10 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 715) && (xpos2 + 10 <= 776) && (enableblue11))
						begin
							enableblue11 <= 0;
							ydirection = 1;
						end
					end
			end
			begin
				// blue square side collision 
				if ((ypos2 - 4 <= 192) && (ypos2 - 4 >= 142))
					begin
						if ((xpos2 - 10 >= 205) && (xpos2 - 10 <= 209) && (enableblue2))
						begin
							enableblue2 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 148) && (xpos2 + 10 <= 152) && (enableblue2))
						begin
							enableblue2 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 268) && (xpos2 - 10 <= 272) && (enableblue3))
						begin
							enableblue3 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 211) && (xpos2 + 10 <= 215) && (enableblue3))
						begin
							enableblue3 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 331) && (xpos2 - 10 <= 335) && (enableblue4))
						begin
							enableblue4 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 274) && (xpos2 + 10 <= 278) && (enableblue4))
						begin
							enableblue4 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 394) && (xpos2 - 10 <= 398) && (enableblue5))
						begin
							enableblue5 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 337) && (xpos2 + 10 <= 341) && (enableblue5))
						begin
							enableblue5 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 457) && (xpos2 - 10 <= 461) && (enableblue6))
						begin
							enableblue6 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 400) && (xpos2 + 10 <= 404) && (enableblue6))
						begin
							enableblue6 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 520) && (xpos2 - 10 <= 524) && (enableblue7))
						begin
							enableblue7 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 463) && (xpos2 + 10 <= 467) && (enableblue7))
						begin
							enableblue7 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 583) && (xpos2 - 10 <= 587) && (enableblue8))
						begin
							enableblue8 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 526) && (xpos2 + 10 <= 530) && (enableblue8))
						begin
							enableblue8 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 646) && (xpos2 - 10 <= 650) && (enableblue9))
						begin
							enableblue9 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 589) && (xpos2 + 10 <= 593) && (enableblue9))
						begin
							enableblue9 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 709) && (xpos2 - 10 <= 713) && (enableblue10))
						begin
							enableblue10 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 652) && (xpos2 + 10 <= 656) && (enableblue10))
						begin
							enableblue10 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 772) && (xpos2 - 10 <= 776) && (enableblue11))
						begin
							enableblue11 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 715) && (xpos2 + 10 <= 719) && (enableblue11))
						begin
							enableblue11 <= 0;
							xdirection <= 0;
						end
					end
			end
			begin
				// red square bottom collision
				if ((ypos2 - 4 <= 141))
					begin
						if ((xpos2 - 10 >= 148) && (xpos2 + 10 <= 210) && (enablered2))
						begin
							enablered2 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 211) && (xpos2 + 10 <= 273) && (enablered3))
						begin
							enablered3 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 274) && (xpos2 + 10 <= 336) && (enablered4))
						begin
							enablered4 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 337) && (xpos2 + 10 <= 399) && (enablered5))
						begin
							enablered5 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 400) && (xpos2 + 10 <= 462) && (enablered6))
						begin
							enablered6 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 463) && (xpos2 + 10 <= 525) && (enablered7))
						begin
							enablered7 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 526) && (xpos2 + 10 <= 588) && (enablered8))
						begin
							enablered8 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 589) && (xpos2 + 10 <= 651) && (enablered9))
						begin
							enablered9 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 652) && (xpos2 + 10 <= 714) && (enablered10))
						begin
							enablered10 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 715) && (xpos2 + 10 <= 778) && (enablered11))
						begin
							enablered11 <= 0;
							ydirection = 0;
						end
					end
			end	
			begin
				// red square top collision
				if ((ypos2 + 4 <= 92) && ydirection == 0)
					begin
						if ((xpos2 - 10 >= 148) && (xpos2 + 10 <= 210) && (enablered2))
						begin
							enablered2 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 211) && (xpos2 + 10 <= 273) && (enablered3))
						begin
							enablered3 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 274) && (xpos2 + 10 <= 336) && (enablered4))
						begin
							enablered4 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 337) && (xpos2 + 10 <= 399) && (enablered5))
						begin
							enablered5 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 400) && (xpos2 + 10 <= 462) && (enablered6))
						begin
							enablered6 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 463) && (xpos2 + 10 <= 525) && (enablered7))
						begin
							enablered7 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 526) && (xpos2 + 10 <= 588) && (enablered8))
						begin
							enablered8 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 589) && (xpos2 + 10 <= 651) && (enablered9))
						begin
							enablered9 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 652) && (xpos2 + 10 <= 714) && (enablered10))
						begin
							enablered10 <= 0;
							ydirection = 1;
						end
						if ((xpos2 - 10 >= 715) && (xpos2 + 10 <= 778) && (enablered11))
						begin
							enablered11 <= 0;
							ydirection = 1;
						end
					end
			end	
			begin
				// red square side collision
				if ((ypos2 - 4 <= 141) && (ypos2 - 4 >= 91))
					begin
						if ((xpos2 - 10 >= 205) && (xpos2 - 10 <= 209) && (enablered2))
						begin
							enablered2 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 148) && (xpos2 + 10 <= 152) && (enablered2))
						begin
							enablered2 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 268) && (xpos2 - 10 <= 272) && (enablered3))
						begin
							enablered3 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 211) && (xpos2 + 10 <= 215) && (enablered3))
						begin
							enablered3 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 331) && (xpos2 - 10 <= 335) && (enablered4))
						begin
							enablered4 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 274) && (xpos2 + 10 <= 278) && (enablered4))
						begin
							enablered4 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 394) && (xpos2 - 10 <= 398) && (enablered5))
						begin
							enablered5 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 337) && (xpos2 + 10 <= 341) && (enablered5))
						begin
							enablered5 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 457) && (xpos2 - 10 <= 461) && (enablered6))
						begin
							enablered6 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 400) && (xpos2 + 10 <= 404) && (enablered6))
						begin
							enablered6 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 520) && (xpos2 - 10 <= 524) && (enablered7))
						begin
							enablered7 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 463) && (xpos2 + 10 <= 467) && (enablered7))
						begin
							enablered7 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 583) && (xpos2 - 10 <= 587) && (enablered8))
						begin
							enablered8 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 526) && (xpos2 + 10 <= 530) && (enablered8))
						begin
							enablered8 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 646) && (xpos2 - 10 <= 650) && (enablered9))
						begin
							enablered9 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 589) && (xpos2 + 10 <= 593) && (enablered9))
						begin
							enablered9 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 709) && (xpos2 - 10 <= 713) && (enablered10))
						begin
							enablered10 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 652) && (xpos2 + 10 <= 656) && (enablered10))
						begin
							enablered10 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 772) && (xpos2 - 10 <= 776) && (enablered11))
						begin
							enablered11 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 715) && (xpos2 + 10 <= 719) && (enablered11))
						begin
							enablered11 <= 0;
							xdirection <= 0;
						end
					end
			end
			begin
				// white square bottom collision
				if ((ypos2 - 4 <= 90))
					begin
						if ((xpos2 - 10 >= 148) && (xpos2 + 10 <= 210) && (enablewhite2))
						begin
							enablewhite2 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 211) && (xpos2 + 10 <= 273) && (enablewhite3))
						begin
							enablewhite3 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 274) && (xpos2 + 10 <= 336) && (enablewhite4))
						begin
							enablewhite4 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 337) && (xpos2 + 10 <= 399) && (enablewhite5))
						begin
							enablewhite5 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 400) && (xpos2 + 10 <= 462) && (enablewhite6))
						begin
							enablewhite6 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 463) && (xpos2 + 10 <= 525) && (enablewhite7))
						begin
							enablewhite7 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 526) && (xpos2 + 10 <= 588) && (enablewhite8))
						begin
							enablewhite8 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 589) && (xpos2 + 10 <= 651) && (enablewhite9))
						begin
							enablewhite9 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 652) && (xpos2 + 10 <= 714) && (enablewhite10))
						begin
							enablewhite10 <= 0;
							ydirection = 0;
						end
						if ((xpos2 - 10 >= 715) && (xpos2 + 10 <= 778) && (enablewhite11))
						begin
							enablewhite11 <= 0;
							ydirection = 0;
						end
					end
			end
			begin
				// white square side collision
				if ((ypos2 - 4 <= 90) && (ypos2 - 4 >= 40))
					begin
						if ((xpos2 - 10 >= 205) && (xpos2 - 10 <= 209) && (enablewhite2))
						begin
							enablewhite2 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 148) && (xpos2 + 10 <= 152) && (enablewhite2))
						begin
							enablewhite2 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 268) && (xpos2 - 10 <= 272) && (enablewhite3))
						begin
							enablewhite3 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 211) && (xpos2 + 10 <= 215) && (enablewhite3))
						begin
							enablewhite3 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 331) && (xpos2 - 10 <= 335) && (enablewhite4))
						begin
							enablewhite4 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 274) && (xpos2 + 10 <= 278) && (enablewhite4))
						begin
							enablewhite4 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 394) && (xpos2 - 10 <= 398) && (enablewhite5))
						begin
							enablewhite5 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 337) && (xpos2 + 10 <= 341) && (enablewhite5))
						begin
							enablewhite5 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 457) && (xpos2 - 10 <= 461) && (enablewhite6))
						begin
							enablewhite6 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 400) && (xpos2 + 10 <= 404) && (enablewhite6))
						begin
							enablewhite6 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 520) && (xpos2 - 10 <= 524) && (enablewhite7))
						begin
							enablewhite7 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 463) && (xpos2 + 10 <= 467) && (enablewhite7))
						begin
							enablewhite7 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 583) && (xpos2 - 10 <= 587) && (enablewhite8))
						begin
							enablewhite8 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 526) && (xpos2 + 10 <= 530) && (enablewhite8))
						begin
							enablewhite8 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 646) && (xpos2 - 10 <= 650) && (enablewhite9))
						begin
							enablewhite9 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 589) && (xpos2 + 10 <= 593) && (enablewhite9))
						begin
							enablewhite9 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 709) && (xpos2 - 10 <= 713) && (enablewhite10))
						begin
							enablewhite10 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 652) && (xpos2 + 10 <= 656) && (enablewhite10))
						begin
							enablewhite10 <= 0;
							xdirection <= 0;
						end
						if ((xpos2 - 10 >= 772) && (xpos2 - 10 <= 776) && (enablewhite11))
						begin
							enablewhite11 <= 0;
							xdirection <= 1;
						end
						if ((xpos2 + 10 >= 715) && (xpos2 + 10 <= 719) && (enablewhite11))
						begin
							enablewhite11 <= 0;
							xdirection <= 0;
						end
					end
			end
		/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
			synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
			the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
			the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
			corresponds to ~(783,515). */

		// outside boundaries
		if ((ypos2 - 4 <= 41) && (ydirection)) 
			ydirection <= 0;
		if ((xpos2 - 5 <= 147) && (xdirection == 0)) 
			xdirection <= 1;
		if ((xpos2 + 5 >= 777) && (xdirection == 1)) 
			xdirection <= 0;
		if(move && ypos2 <= 475)
			begin
				if (ydirection == 1)
					ypos2 <= ypos2 - 2;
				else if (ydirection == 0)
					ypos2 <= ypos2 + 2;
				else if (ydirection == 2)
					ypos2 <= ypos2 - 1;

					
				if (xdirection == 0)
				begin
					if (xspeed == 2)
					begin
						if( xpos2 - 4 >= 148)
							xpos2 <= xpos2 - 4;
					end
					else if (xspeed == 1)
					begin
						if( xpos2 - 2 >= 148)
							xpos2 <= xpos2 - 2;
					end
				end
				else if (xdirection == 1)
				begin
					if (xspeed == 2)
					begin
						if( xpos2 + 4 <= 776)
							xpos2 <= xpos2 + 4;
					end
					else if (xspeed == 1)
					begin
						if( xpos2 + 2 <= 776)
							xpos2 <= xpos2 + 2;
					end
				end
				else if (xdirection == 2)
				begin
					xpos2 <= xpos2;
				end
			end
		else if (ypos2 >= 471)
			begin 
				lives <= lives - 3'd1;
				if (ypos2 >= 472)
					begin
						xpos <= 450;
						ypos <= 470;
						xpos2 <= 450;
						ypos2 <= 456;
						ydirection <= 1;
						xdirection <= 2;
					end
			end
		if(right) 
			begin
				xpos<=xpos+4; //change the amount you increment to make the speed faster 
				if(xpos>=730) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
					xpos<=730;
			end
		else if(left) 
			begin
				xpos<=xpos-4;
				if(xpos<=200)
					xpos<=200;
			end
		end
	end
	
	
endmodule

