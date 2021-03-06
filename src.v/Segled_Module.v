module Segled_Module
(	
	//输入端口 
	CLK_50M,RST_N,result,
	//输出端口
	SEG_DATA,SEG_EN
);
	
//---------------------------------------------------------------------------
//--	外部端口声明
//---------------------------------------------------------------------------
input 						CLK_50M;					//时钟端口
input							RST_N;					//复位端口
input			[ 3:0]		result;				//从A/D转换芯片输出的电压值的小数部分；
output reg 	[ 5:0] 		SEG_EN;					//数码管使能端口
output reg 	[ 7:0] 		SEG_DATA;				//数码管端口

//---------------------------------------------------------------------------
//--	内部端口声明
//---------------------------------------------------------------------------
reg			[15:0]		time_cnt;				//用来控制数码管闪烁频率的定时计数器
reg			[15:0]		time_cnt_n;				//time_cnt的下一个状态
reg			[ 2:0]		led_cnt;					//用来控制数码管亮灭及显示数据的显示计数器
reg			[ 2:0]		led_cnt_n;				//led_cnt的下一个状态
reg 			[ 3:0]		led_data;				//数据转换寄存器

//设置定时器的时间为1ms,计算方法为  (1*10^3)us / (1/50)us  50MHz为开发板晶振
parameter SEC_TIME_1MS = 16'd50_00;	

//---------------------------------------------------------------------------
//--	逻辑功能实现	
//---------------------------------------------------------------------------
//时序电路,用来给time_cnt寄存器赋值
always @ (posedge CLK_50M or negedge RST_N)  
begin
	if(!RST_N)											//判断复位
		time_cnt <= 16'h0;							//初始化time_cnt值
	else
		time_cnt <= time_cnt_n;						//用来给time_cnt赋值
end

//组合电路,实现10ms的定时计数器
always @ (*)  
begin
	if(time_cnt == SEC_TIME_1MS)					//判断1ms时间
		time_cnt_n = 16'h0;							//如果到达1ms,定时计数器将会被清零
	else
		time_cnt_n = time_cnt + 27'h1;			//如果未到1ms,定时计数器将会继续累加
end

//时序电路,用来给led_cnt寄存器赋值
always @ (posedge CLK_50M or negedge RST_N)  
begin
	if(!RST_N)											//判断复位
		led_cnt <= 3'b000;							//初始化led_cnt值
	else
		led_cnt <= led_cnt_n;						//用来给led_cnt赋值
end

//组合电路,判断时间,实现控制显示计数器累加
always @ (*)  
begin
	if(time_cnt == SEC_TIME_1MS)					//判断1ms时间		
		led_cnt_n = led_cnt + 1'b1;				//如果到达1ms,计数器进行累加
	else
		led_cnt_n = led_cnt;							//如果未到1ms,计数器保持不变
end

//组合电路,实现数码管的数字显示,将时钟中的数据转换成显示数据
always @ (*)
begin
	case(led_cnt)
		0 : led_data = 4'hF;							//给数码管赋值为F
		1 : led_data = 4'hF;							//给数码管赋值为F
		2 : led_data = 4'hF;							//给数码管赋值为F
		3 : led_data = 4'hF;							//给数码管赋值为F
		4 : led_data = 4'hF;					//显示电压值的整数部分；
		5 : led_data = result;					//显示电压值的小数部分；
		default: led_data = 4'hF;					//给数码管赋值为F
	endcase
end

//组合电路,控制数码管的亮灭
always @ (*)
begin
	case (led_cnt)  
		0 : SEG_EN = 6'b111111; 					//当计数器为0时,数码管SEG1不显示
		1 : SEG_EN = 6'b111111;  					//当计数器为1时,数码管SEG2不显示
		2 : SEG_EN = 6'b111111; 					//当计数器为2时,数码管SEG3不显示
		3 : SEG_EN = 6'b111111; 					//当计数器为3时,数码管SEG4不显示
		4 : SEG_EN = 6'b111111;						//当计数器为4时,数码管SEG5显示
		5 : SEG_EN = 6'b011111;						//当计数器为5时,数码管SEG6显示
		default : SEG_EN = 6'b111111;				//熄灭所有数码管	
	endcase 	
end


//组合电路,实现数码管的显示
always @ (*)
begin
  case(led_data)
		0  : SEG_DATA[6:0]     = 7'b1000000;   		//显示数字 "0"
		1  : SEG_DATA[6:0]     = 7'b1111001;  			//显示数字 "1"
		2  : SEG_DATA[6:0]     = 7'b0100100;   		//显示数字 "2"
		3  : SEG_DATA[6:0]     = 7'b0110000;   		//显示数字 "3"
		4  : SEG_DATA[6:0]     = 7'b0011001;  			//显示数字 "4"
		5  : SEG_DATA[6:0]     = 7'b0010010;   		//显示数字 "5"
		6  : SEG_DATA[6:0]     = 7'b0000010;   		//显示数字 "6"
		7  : SEG_DATA[6:0]     = 7'b1111000;   		//显示数字 "7"
		8  : SEG_DATA[6:0]     = 7'b0000000;   		//显示数字 "8"
		9  : SEG_DATA[6:0]     = 7'b0010000;  			//显示数字 "9"
		10 : SEG_DATA[6:0]     = 7'b0001000;   		//显示数字 "A"
		11 : SEG_DATA[6:0]     = 7'b0000011;   		//显示数字 "B"
		12 : SEG_DATA[6:0]     = 7'b0100111;   		//显示数字 "C"
		13 : SEG_DATA[6:0]     = 7'b0100001;   		//显示数字 "D"
		14 : SEG_DATA[6:0]     = 7'b0000110;   		//显示数字 "E"
		15 : SEG_DATA[6:0]     = 7'b0001110;   		//显示数字 "F"
		default :SEG_DATA[6:0] = 7'b1000000;			//显示数字 "0"
  endcase
end

endmodule

