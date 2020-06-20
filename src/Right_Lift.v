	module Right_Lift(
	sum_black,sum_white,hcount,
	Right_data_out,Lift_data_out,
	wren,clock,rst_n
	);
	
	input 		[ 8:0] 		sum_black;			//黑像素点个数
	input			[ 8:0] 		sum_white;			//白像素点个数
				
	input	 		[ 8:0] 		hcount;				//地址位
		
	input							clock;				//时钟信号
	input							rst_n;				//复位信号
	input							wren;					//使能信号
						
	output 		[ 8:0] 		Right_data_out;	//右边界地址
	output 		[ 8:0] 		Lift_data_out;		//左边界地址
	
	reg 			[ 8:0]		Lift_data_in;		//左边界判断的输入信号
	reg 			[ 8:0]		Right_data_in;		//右边界判断的输入信号
	reg			[ 8:0]		Right_data_in_n;
	
	reg			[ 8:0]		sum_black_n;		//黑色像素的下一个状态
	wire							flog;					//右边界标志位
	
	//当连续黑色像素的个数大于一定值得时候统计地址
	always @ (*)
	if(sum_black >= 9'd10 )
		begin
			Lift_data_in = hcount;
		end
	else
		begin
			Lift_data_in = Lift_data_out;
		end
	
	//记录像素点由黑转白的时候
	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
		sum_black_n <= 9'd0;
	else
		sum_black_n <= sum_black;
		
	assign flog = sum_black - sum_black_n;
	//记下像素由黑转白的地址	
	always @ (*)
	if(flog)
		begin
			Right_data_in = hcount;
		end
	else
		begin
			Right_data_in = Right_data_in;
		end

/*----- 求最小值为左边界 -----*/
Lift_ctr		Lift_ctr(
	.clock				(clock				),//时钟信号
	.rst_n				(rst_n				),//复位信号
	.wren					(wren					),//使能控制信号
	.data_in				(Lift_data_in		),
	.data_out			(Lift_data_out		)	
);

/*----- 求最大值为右边界 -----*/
Right_ctr		Right_ctr(
	.clock				(clock				),//时钟信号
	.rst_n				(rst_n				),//复位信号
	.wren					(wren					),//使能控制信号
	.data_in				(Right_data_in		),
	.data_out			(Right_data_out	)
);

endmodule
