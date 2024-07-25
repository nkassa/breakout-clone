module display_lives(
	input clk,
	input[3:0] displayNumber,
	output reg [3:0] anode,
	output reg [6:0] ssdOut	
    );
	 
	reg [20:0] refresh;
	reg [3:0] LEDNumber;
	wire [1:0] LEDCounter;
	
	
	always @ (posedge clk)
	begin
		refresh <= refresh + 21'd1;
	end
	assign LEDCounter = refresh[20:19];
	
	always @ (*)
	 begin
		begin
			anode = 4'b1110;
			LEDNumber = displayNumber;
		end	
	end
	always @ (*)
    begin
        case (LEDNumber)
        4'd0: ssdOut = 7'b0000001;     
        4'd1: ssdOut = 7'b1001111; 
        4'd2: ssdOut = 7'b0010010; 
        4'd3: ssdOut = 7'b0000110;  
        default: ssdOut = 7'b0000110; 
        endcase
    end
endmodule