module count_data(
	clock,
	rst_n,
	count_y1,
	count_x1,
	count_y2,
	count_y3,
	count_y4,
	result
);

input								clock;
input								rst_n;

input			[ 3:0]			count_x1;
input			[ 3:0]			count_y1;
input			[ 3:0]			count_y2;
input			[ 3:0]			count_y3;
input			[ 3:0]			count_y4;

output		[ 3:0]			result;
reg			[ 3:0]			result;

always @ (posedge clock or negedge rst_n)
if(!rst_n)
	result <= 4'hf;
else if((count_x1 == 4'd2) && (count_y1 == 4'd6) && ( count_y2 == 4'd4))
	result <= 4'd1;
else if((count_x1 == 4'd6) && (count_y1 == 4'd6) && ( count_y2 == 4'd4))
	result <= 4'd2;
else if((count_x1 == 4'd4) && (count_y1 == 4'd6) && ( count_y2 == 4'd4))
	result <= 4'd4;
else if((count_x1 == 4'd4) && (count_y1 == 4'd4) && ( count_y2 == 4'd4))
	result <= 4'd7;
else if((count_x1 == 4'd6) && (count_y1 == 4'd4) && ( count_y2 == 4'd6))
	begin
		if(count_y3 == 4'd4)
			result <= 4'd5;
		else
			result <= 4'd6;
	end
else if((count_x1 == 4'd6) && (count_y1 == 4'd6) && ( count_y2 == 4'd6))
	begin
		if(count_y3 == 4'd4)
			result <= 4'd3;
		else
		begin
			if(count_y4 == 4'd4)
				result <= 4'd9;
			else
				result <= 4'd8;
		end
	end
else
	result <= result;

endmodule
