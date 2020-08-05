	module Division_l(
		data_in,
		clock,
		rst_n,
		wren,
		Upper_data,
		Lower_data,
		Right_data,
		Lift_data,
		lcount,
		hcount
	);

	//输入信号声明
	input						wren;					//输入使能控制
	input		[ 7:0]		data_in;				//输入信号
	input						clock;				//时钟信号
	input						rst_n;				//复位信号

	//输出信号申明
	output	[ 8:0]		Upper_data;			//上边界地址
	output	[ 8:0]		Lower_data;			//下边界地址
	output	[ 8:0]		Right_data;			//右边界地址
	output	[ 8:0]		Lift_data ;			//左边界地址
	
	output	[ 8:0]		hcount;				//横坐标地址
	output	[ 8:0]		lcount;				//纵坐标地址

	//字符分割标志位声明	
	reg						flagUpper_data;	//上边界标志位
	reg						flagLower_data;	//下边界标志位
					
	//字符分割数据位声明
	reg		[ 7:0]		xs;					//输入数据中间值
	reg		[ 8:0]		hcount;				//行像素地址
	reg		[ 8:0]		lcount;				//列像素地址
	reg		[ 8:0]		Upper_data;			//左边界地址
	reg		[ 8:0]		Lower_data;			//右边界地址
	reg		[ 8:0]		sum_black;			//非零像素点统计值
	reg		[ 8:0]		sum_white;			//零像素点统计值
	
	parameter T = 8'd30;
	
	always @ (posedge clock )
	if(wren)										//模块工作使能信号
	begin
		xs<=data_in;
		if(xs!=8'hff)							//判断是否非零像素
			begin
				sum_white<=sum_white;
				sum_black<=sum_black+1'b1;	//统计黑点的个数
			end
		else if(xs != 8'h00)
			begin
				sum_white<=sum_white+1'b1;	//统计白点的个数
				sum_black<=sum_black;
			end
		else
			begin
				sum_white<=sum_white;		//输入值为其他数据时保持不变
				sum_black<=sum_black;
			end
	end
	else 
		begin
			sum_black<=9'd0;					//每一行统计完之后清零
			sum_white<=9'd0;
		end
	
	always @ (posedge clock or negedge rst_n)
	if(!rst_n)
	begin
		flagUpper_data<= 1'b1;					//上边界标志位
		flagLower_data<= 1'b0;					//下边界标志位
	end
		
	else if(wren) 
	begin		
	if(flagUpper_data)							//字符上边界地址标志位
		begin
			if(hcount>=9'd479)					//判断是否扫完一行
			begin
				if(sum_black>T)						//统计特征与阈值进行比较
				begin
					Upper_data<=lcount;				//字符上边界地址
					flagUpper_data<=1'b0;			//字符上边界标志位清零
					flagLower_data<=1'b1;			//字符下边界地址标志位置位
				end
				else
				Upper_data<=Upper_data;			//上边界数值保持不变

				hcount<=9'd0;						//横坐标清零
				
				if(lcount>=9'd271)
				begin
					lcount<=9'd0;
					flagUpper_data<=1'b1;		//上下标志位使能
					flagLower_data<=1'b0;
				end
				else
					lcount<=lcount+9'b1;
					
			end
			else 
				hcount<=hcount+9'b1;					//行像素地址+1
				
		end
		else
			Upper_data <= Upper_data;
			
		if(flagLower_data)						//字符下边界地址标志位判断
		begin
			if(hcount>=9'd479)
			begin
				if(sum_black<=T)						//统计特征与阈值T进行比较
				begin
					Lower_data<=lcount+9'b1;		//字符下边界地址
					flagUpper_data<=1'b1;			//上下标志位使能
					flagLower_data<=1'b0;
				end
				else
					Lower_data<=Lower_data;

				hcount<=9'd0;							//横坐标清零
		
				if(lcount>=9'd271)
				begin
					lcount<=9'd0;
					flagLower_data<=1'b1;			//上下标志位使能
					flagUpper_data<=1'b0;
				end	
				else
					lcount<=lcount+9'b1;				//纵坐标+1
					
			end
			else
				hcount<=hcount+9'b1;					//行像素地址+1
				
		end
		else
			Lower_data<=Lower_data;		
	end
	else
	begin
		Upper_data<=Upper_data;						//非使能状态保持不变
		Lower_data<=Lower_data;	
	end
	/*左右地址位确认*/		
	Right_Lift		c1(
	.clock					(clock			),		//时钟信号
	.rst_n					(rst_n			),		//复位信号
	.wren						(wren				),		//使能控制信号
	.sum_black				(sum_black		),		//黑色像素统计值
	.sum_white				(sum_white		),		//白色像素统计值
	.hcount					(hcount			),		//横坐标
	.Right_data_out		(Right_data		),		//右边界的地址
	.Lift_data_out			(Lift_data		)		//左边界地址
	);

			
	endmodule
