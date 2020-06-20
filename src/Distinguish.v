	module Distinguish(
		clock,
		data_in,
		rst_n,
		wren,
		tft_begin,
		Upper_data,
		Lower_data,
		Right_data,
		Lift_data,
		lcount,
		hcount,
		result
	);
	
	input						wren;					//输入使能控制
	input						clock;				//时钟信号
	input						rst_n;            //复位信号
	input		[ 7:0]		data_in;          //输入信号
	input						tft_begin;			//一屏数据开始标志位

	input		[ 8:0]		hcount;				//横坐标地址		
	input		[ 8:0]		lcount;				//纵坐标地址
	
	input		[ 8:0]		Upper_data;			//上边界地址
	input		[ 8:0]		Lower_data;			//下边界地址
	input		[ 8:0]		Right_data;			//右边界地址
	input		[ 8:0]		Lift_data ;			//左边界地址
	
	output	[ 3:0]		result;				//输出识别的数字
	
	/*纵向标志 1 相关数值定义*/
	wire		[ 8:0]		x1;
	reg		[ 7:0]		data_in_x1;
	reg		[ 3:0]		sum_in_x1;
	reg		[ 3:0]		sum_in_x1_n;
	wire		[ 3:0]		sum_out_x1;

	/*横向标志 1 相关数值定义*/
	wire		[ 8:0]		y1;
	reg		[ 7:0]		data_in_y1;
	reg		[ 3:0]		sum_in_y1;
	reg		[ 3:0]		sum_in_y1_n;
	wire		[ 3:0]		sum_out_y1;

	/*横向标志 2 相关数值定义*/
	wire		[ 8:0]		y2;
	reg		[ 7:0]		data_in_y2;
	reg		[ 3:0]		sum_in_y2;
	reg		[ 3:0]		sum_in_y2_n;
	wire		[ 3:0]		sum_out_y2;
	
	/*横向标志 3 相关数值定义*/
	wire		[ 8:0]		y3;
	reg		[ 7:0]		data_in_y3;
	reg		[ 3:0]		sum_in_y3;
	reg		[ 3:0]		sum_in_y3_n;
	wire		[ 3:0]		sum_out_y3;
	
	/*横向标志 4 相关数值定义*/
	wire		[ 8:0]		y4;
	reg		[ 7:0]		data_in_y4;
	reg		[ 3:0]		sum_in_y4;
	reg		[ 3:0]		sum_in_y4_n;
	wire		[ 3:0]		sum_out_y4;
	
	/*计算个标志位所在的位置*/
	assign	x1 = {1'h0,Right_data[8:1]} - {1'h0,Lift_data[8:1]} + Lift_data; 

	assign	y1 = {2'h0,Lower_data[8:2]} - {2'h0,Upper_data[8:2]} + Upper_data;
	
	assign	y2 = {2'h0,Lower_data[8:2]} - {2'h0,Upper_data[8:2]} + {1'h0,Lower_data[8:1]} - {1'h0,Upper_data[8:1]} + Upper_data;
	
	assign	y3 = {2'h0,Lower_data[8:3]} - {2'h0,Upper_data[8:3]} + {1'h0,Lower_data[8:1]} - {1'h0,Upper_data[8:1]} + Upper_data;

	assign	y4 = {3'h0,Lower_data[8:4]} - {2'h0,Upper_data[8:4]} + {2'h0,Lower_data[8:3]} - {2'h0,Upper_data[8:3]} + {1'h0,Lower_data[8:1]} - {1'h0,Upper_data[8:1]} + Upper_data; 

	/*纵向标志 1 黑白零界点个数统计*/
	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
		data_in_x1 <= 8'd0;
	else if(hcount == x1)
		data_in_x1 <= data_in;
	else
		data_in_x1 <= data_in_x1;

	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
		sum_in_x1 <= 4'd0;
	else	
		sum_in_x1 <= sum_in_x1_n;

	always @ (*)
	if(!tft_begin)
		if(hcount == x1)
			if(data_in_x1 != data_in)
				sum_in_x1_n = sum_in_x1 + 1'd1;
			else
				sum_in_x1_n = sum_in_x1;
		else
			sum_in_x1_n = sum_in_x1;
	else
		sum_in_x1_n = 0;


	/*横向标志 1 黑白零界点个数统计*/
	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
		data_in_y1 <= 8'd0;
	else if(lcount == y1)
		data_in_y1 <= data_in;
	else
		data_in_y1 <= data_in;

	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
		sum_in_y1 <= 4'd0;
	else	
		sum_in_y1 <= sum_in_y1_n;
		
	always @ (*)
	if(!tft_begin)
		if(lcount == y1)
			if(data_in_y1 != data_in)
				sum_in_y1_n = sum_in_y1 + 1'd1;
			else
				sum_in_y1_n = sum_in_y1;
		else
			sum_in_y1_n = sum_in_y1;
	else
		sum_in_y1_n = 0;
		
	/*横向标志 2 黑白零界点个数统计*/
	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
		data_in_y2 <= 8'd0;
	else if(lcount == y2)
		data_in_y2 <= data_in;
	else
		data_in_y2 <= data_in;	

	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
		sum_in_y2 <= 4'd0;
	else	
		sum_in_y2 <= sum_in_y2_n;

	always @ (*)
	if(!tft_begin)
		if(lcount == y2)
			if(data_in_y2 != data_in)
				sum_in_y2_n = sum_in_y2 + 1'd1;
			else
				sum_in_y2_n = sum_in_y2;
		else
			sum_in_y2_n = sum_in_y2;
	else
		sum_in_y2_n = 0;


	/*横向标志 3 黑白零界点个数统计*/
	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
		data_in_y3 <= 8'd0;
	else if(lcount == y3)
		data_in_y3 <= data_in;
	else
		data_in_y3 <= data_in;	

	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
		sum_in_y3 <= 4'd0;
	else	
		sum_in_y3 <= sum_in_y3_n;

	always @ (*)
	if(!tft_begin)
		if(lcount == y3)
			if(data_in_y3 != data_in)
				sum_in_y3_n = sum_in_y3 + 1'd1;
			else
				sum_in_y3_n = sum_in_y3;
		else
			sum_in_y3_n = sum_in_y3;
	else
		sum_in_y3_n = 0;


	/*横向标志 4 黑白零界点个数统计*/
	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
		data_in_y4 <= 8'd0;
	else if(lcount == y4)
		data_in_y4 <= data_in;
	else
		data_in_y4 <= data_in;	

	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
		sum_in_y4 <= 4'd0;
	else	
		sum_in_y4 <= sum_in_y4_n;

	always @ (*)
	if(!tft_begin)
		if(lcount == y4)
			if(data_in_y4 != data_in)
				sum_in_y4_n = sum_in_y4 + 1'd1;
			else
				sum_in_y4_n = sum_in_y4;
		else
			sum_in_y4_n = sum_in_y4;
	else
		sum_in_y4_n = 0;


	/*每个标志位 黑白零界点的最值*/
	Max_ctr		max_ctr_x1(
		.clock				(clock				),
		.rst_n				(rst_n				),
		.data_in				(sum_in_x1			),
		.data_out			(sum_out_x1			)
	);

	Max_ctr		max_ctr_y1(
		.clock				(clock				),
		.rst_n				(rst_n				),
		.data_in				(sum_in_y1			),
		.data_out			(sum_out_y1			)
	);

	Max_ctr		max_ctr_y2(
		.clock				(clock				),
		.rst_n				(rst_n				),
		.data_in				(sum_in_y2			),
		.data_out			(sum_out_y2			)
	);

	Max_ctr		max_ctr_y3(
		.clock				(clock				),
		.rst_n				(rst_n				),
		.data_in				(sum_in_y3			),
		.data_out			(sum_out_y3			)
	);

	Max_ctr		max_ctr_y4(
		.clock				(clock				),
		.rst_n				(rst_n				),
		.data_in				(sum_in_y4			),
		.data_out			(sum_out_y4			)
	);

	/*根据个标志 临界点的进行图像识别*/
	count_data		count_data_init(
	.clock					(clock				),
	.rst_n					(rst_n				),
	.count_x1				(sum_out_x1			),
	.count_y1				(sum_out_y1			),
	.count_y2				(sum_out_y2			),
	.count_y3				(sum_out_y3			),
	.count_y4				(sum_out_y4			),
	.result					(result				)
	);


endmodule
