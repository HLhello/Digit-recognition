`define SET_TIME_1S 	32'h5F5_E100	//1s @ 100Mhz
	module Lift_ctr_n(
		data,Lift_data,clock,rst_n,wren
	);

	input							clock;
	input							rst_n;
	input							wren;
			
	input	 	[ 8:0]			data;
	output 	[ 8:0]			Lift_data;
	
	reg 		[ 8:0]			Lift_data;
	reg 		[ 8:0]			Lift_data_n;
	reg 		[ 8:0]			Lift_data_reg;
	wire 		[ 8:0]			Lift_data_reg_n;
						
	reg 		[ 9:0]			Lift_data_sub;
	wire 		[ 9:0]			Lift_data_sub_n;
	
	reg		[31:0]			time_cnt;					//用来生成1s的定时计数器
	reg		[31:0]			time_cnt_n;					//time_cnt的下一个状态

	always @ (posedge clock or negedge rst_n)
	begin
		if(!rst_n)
			time_cnt	<= 32'h0;
		else
			time_cnt	<= time_cnt_n;
	end

	/* 组合电路,用来生成1s的定时计数器 */
	always @ (*)
	begin
		if(time_cnt == `SET_TIME_1S)  
			time_cnt_n = 32'h0;
		else
			time_cnt_n = time_cnt + 32'h1;
	end
	
	always @ (posedge clock or negedge rst_n)
	begin
		if(!rst_n)
			Lift_data_reg <= 9'h0;
		else
			Lift_data_reg <= Lift_data_reg_n;
	end

/* 组合电路,用于缓存AD采样值 */
assign Lift_data_reg_n = data;
	
	always @ (posedge clock or negedge rst_n)
	begin
		if(!rst_n)
			Lift_data_sub <= 1'h0;
		else
			Lift_data_sub <= Lift_data_sub_n;
	end	
	
	assign Lift_data_sub_n = {1'h0, data} - {1'h0, Lift_data_reg};
	
	always @ (posedge clock or negedge rst_n)
	begin
		if(!rst_n)
			Lift_data	<= 9'h1ff;
		else
			Lift_data	<= Lift_data_n;
	end

	/* 组合电路,找出一个周期中的最小值 */
	always @ (*)
	begin
//		if(time_cnt == `SET_TIME_1S) 
//			Lift_data_n = 9'h1ff;
//		else 
		if(Lift_data_sub[9] && wren)
			Lift_data_n = Lift_data_reg;
		else
			Lift_data_n = Lift_data;
	end

		
endmodule
