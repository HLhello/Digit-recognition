/*每过一段时间刷新输入进来的最大值*/
`define SET_TIME 	32'h5FA_000	//
	module Right_ctr(
		data_in,data_out,clock,rst_n,wren
	);

	input							clock;						//时钟信号
	input							rst_n;            		//复位信号
	input							wren;             		//使能信号
																	
	input	 	[ 8:0]			data_in;          		//输入信号
	output 	[ 8:0]			data_out;         		//输出最小值
																	
	reg 		[ 8:0]			data_out;         		
	reg 		[ 8:0]			data_out_n;       		//输出信号的下一个状态
	reg 		[ 8:0]			data_out_reg;     		//缓存信号
	wire 		[ 8:0]			data_out_reg_n;   		//缓存信号的下一个状态
																	
	reg 		[ 9:0]			data_out_sub;     		//最值比较中间变量
	wire 		[ 9:0]			data_out_sub_n;   		//最值比较中间变量的下一个状态

	reg		[31:0]			time_cnt;					//用来生成1s的定时计数器
	reg		[31:0]			time_cnt_n;					//time_cnt的下一个状态

	/*时钟控制*/
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
		if(time_cnt == `SET_TIME)  
			time_cnt_n = 32'h0;
		else if(wren)
			time_cnt_n = time_cnt + 32'h1;
		else
			time_cnt_n = time_cnt;
	end
	
	/*数值缓存*/
	always @ (posedge clock or negedge rst_n)
	begin
		if(!rst_n)
			data_out_reg <= 9'h0;
		else
			data_out_reg <= data_out_reg_n;
	end

	/* 组合电路,用于缓存AD采样值 */
	assign data_out_reg_n = data_in;

	/*输入信号如当前最值比较*/
	always @ (posedge clock or negedge rst_n)
	begin
		if(!rst_n)
			data_out_sub <= 1'h0;
		else
			data_out_sub <= data_out_sub_n;
	end	

	assign data_out_sub_n = {1'h0, data_in} - {1'h0, data_out};
	
	/*给输出信号幅值*/
	always @ (posedge clock or negedge rst_n)
	begin
		if(!rst_n)
			data_out	<= 9'h000;
		else
			data_out	<= data_out_n;
	end

	/* 组合电路,找出一个周期中的最小值 */
	always @ (*)
	begin
		if(time_cnt == `SET_TIME) 
			data_out_n = 9'h000;
		else if(!data_out_sub[9] && wren)
			data_out_n = data_out_reg;
		else
			data_out_n = data_out;
	end

	
endmodule
