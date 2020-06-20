/***************************************************
*	Module Name		:	uart2sdram2tft		   
*	Engineer		   :	小梅哥
*	Target Device	:	EP4CE10F17C8
*	Tool versions	:	Quartus II 13.0
*	Create Date		:	2017-3-31
*	Revision		   :	v1.0
*	Description		:  串口传图顶层文件
**************************************************/
module Uart2Sdram(
	Clk50M,
	Rst_n,

	Uart_rx,

	Sd_Sa,
	Sd_Ba,
	Sd_Cs_n,
	Sd_Cke,
	Sd_Clk,
	Sd_Ras_n,
	Sd_Cas_n,
	Sd_We_n,
	Sd_Dq,
	Sd_Dqm,

	SEG_EN,
	SEG_DATA,
	
	lcd_out_clk,
	lcd_out_hs,
	lcd_out_vs,
	lcd_out_de,
	lcd_out_rgb_b,
	lcd_out_rgb_g,
	lcd_out_rgb_r

);

`include        "Sdram_Params.h"  

parameter   Baud_set = 3'd5;       //波特率设置，1562500bps
parameter   img_h    = 480;        //图片宽度
parameter   img_v    = 272;        //图片高度
parameter   img_data_byte = img_h*img_v;

	input               Clk50M;     //系统时钟
	input               Rst_n;      //系统复位信号

	input               Uart_rx;    //串口接收信号

	output[`ASIZE-1:0]  Sd_Sa;      //SDRAM地址总线  
	output[`BSIZE-1:0]  Sd_Ba;      //SDRAMBank地址   
	output              Sd_Cs_n;    //SDRAM片选信号        
	output              Sd_Cke;     //SDRAM时钟使能
	output              Sd_Clk;     //SDRAM时钟信号 
	output              Sd_Ras_n;   //SDRAM行地址选
	output              Sd_Cas_n;   //SDRAM列地址选
	output              Sd_We_n;    //SDRAM写使能  
	inout [`DSIZE-1:0]  Sd_Dq;      //SDRAM数据总线
	output[`DSIZE/8-1:0]Sd_Dqm;     //SDRAM数据掩码
	
	output	[5:0]		SEG_EN;				//数码管使能端口
	output	[7:0]		SEG_DATA;			//数码管数据端口

	//LCD port			
	output         		lcd_out_clk;//lcd输出时钟
	output         		lcd_out_hs;	//lcd横坐标使能
	output         		lcd_out_vs;	//lcd纵坐标使能
	output         		lcd_out_de;	//lcd使能
	output [7:0]   		lcd_out_rgb_b;//蓝色输出
	output [7:0]   		lcd_out_rgb_g;//绿色输出
	output [7:0]   		lcd_out_rgb_r;//红色输出
				
	wire              	Clk;        		//SDRAM控制器时钟
	wire              	Wr_en;      		//写SDRAM使能信号    
	wire [7:0]        	Wr_data;    		//写SDRAM数据
	wire              	Rd_en;      		//读SDRAM使能信号
	wire [`DSIZE-1:0] 	Rd_data;    		//读SDRAM数据
				
	wire              	clk9M;      		//TFT屏控制器时钟
	reg 	[31:0]        	byte_cnt;   		//图片数据计数器
	reg               	disp_state; 		//图片可显示状态 
	wire              	tft_begin;  		//TFT屏帧起始标志位
	wire              	sdram_clk;  		//SDRAM时钟信号
		
	wire	[ 8:0]			Upper_data;			//上边界地址
	wire	[ 8:0]			Lower_data;			//下边界地址
	wire	[ 8:0]			Right_data;			//右边界地址
	wire	[ 8:0]			Lift_data ;			//左边界地址	
	wire	[ 8:0]			hcount;				//行像素地址
	wire	[ 8:0]			lcount;				//列像素地址
	wire	[ 8:0]			result;
	
	//串口传图图片数据计数器
	always@(posedge Clk50M or negedge Rst_n)
	begin
		if(!Rst_n)
			byte_cnt <= 32'd0;
		else if(Wr_en)begin
			if(byte_cnt <(img_data_byte-1))
				byte_cnt <= byte_cnt + 32'd1;
			else
				byte_cnt <= (img_data_byte-1);
		end
		else
			byte_cnt <= byte_cnt;
	end
	
	//串口传图图片数据传输完，进入图片可显示状态
	always@(posedge Clk or negedge Rst_n)
	begin
		if(!Rst_n)
			disp_state <= 1'b0;
		else if(byte_cnt == (img_data_byte-1))
			disp_state <= 1'b1;
		else
			disp_state <= 1'b0;
	end
	
	//SDRAM控制器读FIFO的读使能
	assign Rd_en = (disp_state && lcd_out_de)?1'b1:1'b0;
	//SDRAM时钟信号
	assign Sd_Clk = sdram_clk;
	
	//时钟模块PLL例化
	pll pll(
	   .areset(!Rst_n),
		.inclk0(Clk50M),
		.c0(Clk),
		.c1(sdram_clk),
		.c2(clk9M)
	);
	
	//串口接收模块例化
	uart_byte_rx uart_byte_rx(
		.Clk(Clk50M),
		.Rst_n(Rst_n),
		.Rs232_rx(Uart_rx),
		.Baud_set(Baud_set),

		.Data_byte(Wr_data),
		.Rx_done(Wr_en)
	);
	
	//SDRAM控制器模块例化
	sdram_control_top sdram(		
		.Clk(Clk),
		.Rst_n(Rst_n),
		.Sd_clk(sdram_clk),
		
		.Wr_data(Wr_data),    
		.Wr_en(Wr_en),      	
		.Wr_addr(0),    	
		.Wr_max_addr(img_data_byte),	
		.Wr_load(!Rst_n),	
		.Wr_clk(Clk50M),	
		.Wr_full(),	
		.Wr_use(),	
		
		.Rd_data(Rd_data),    	
		.Rd_en(Rd_en),				
		.Rd_addr(0),			
		.Rd_max_addr(img_data_byte),
		.Rd_load(tft_begin),	
		.Rd_clk(clk9M),	
		.Rd_empty(),	
		.Rd_use(),	
		
		.Sa(Sd_Sa),
		.Ba(Sd_Ba),
		.Cs_n(Sd_Cs_n),
		.Cke(Sd_Cke),
		.Ras_n(Sd_Ras_n),
		.Cas_n(Sd_Cas_n),
		.We_n(Sd_We_n),
		.Dq(Sd_Dq),
		.Dqm(Sd_Dqm)
	);	

	/*lcd 显示控制*/
	wire [7:0] data_in;
	wire [7:0] dataout;
	wire [4:0] lcd_red;
	wire [5:0] lcd_green;
	wire [4:0] lcd_blue;

//	assign lcd_out_rgb_r=data_in;
//	assign lcd_out_rgb_g=data_in;
//	assign lcd_out_rgb_b=data_in;
	
	lcd_show		u_lcd_show
	(
		.clk						(clk9M				),	
		.rst_n					(Rst_n				),	
		.Right_data				(Right_data			),
		.Lift_data				(Lift_data			),
		.Upper_data				(Upper_data			),
		.Lower_data				(Lower_data			),
		.lcount					(lcount				),
		.hcount					(hcount				),
		.datain					(data_in				),
		.lcd_out_rgb_r			(lcd_out_rgb_r		),
		.lcd_out_rgb_g			(lcd_out_rgb_g		),
		.lcd_out_rgb_b			(lcd_out_rgb_b		)
);

	lcd_driver	u_lcd_driver
	(
		//global clock
		.clk						(clk9M		),	
		.rst_n					(Rst_n		),	
		
		//lcd interface		
		.lcd_blank				(lcd_out_de	),
		.lcd_sync				(),
		.lcd_dclk				(lcd_out_clk),
		.lcd_hs					(lcd_out_hs	),		
		.lcd_vs					(lcd_out_vs	),	
		.lcd_rgb					({lcd_red, lcd_green ,lcd_blue}),
		
		//user interface
		
		.lcd_data				({Rd_data[7:0],Rd_data[15:8]}),
		.TFT_begin				(tft_begin)
	);
	//二值化
	rgb_to_ycbcr  rgb_to_ycbcr_inst(
		.clk						(clk9M				),
		.i_r_8b					({lcd_red,3'b0}	),
		.i_g_8b					({lcd_green,2'b0}	),
		.i_b_8b					({lcd_blue,3'b0}	), 
		.o_y_8b					(),
		.data_in					(data_in				),                                                                        
	);
	//字符分割				
	Division_l		Division_l_init(
		.clock					(clk9M				),
		.data_in					(data_in				),
		.rst_n					(Rst_n				),
		.wren						(lcd_out_de			),
		.Right_data				(Right_data			),
		.Lift_data				(Lift_data			),
		.Upper_data				(Upper_data			),
		.Lower_data				(Lower_data			),
		.lcount					(lcount				),
		.hcount					(hcount				)
	);
	//字符识别
	Distinguish		Distinguish_init(
		.clock					(clk9M				),
		.data_in					(data_in				),
		.rst_n					(Rst_n				),	
		.wren						(lcd_out_de			),
		.lcount					(lcount				),
		.hcount					(hcount				),
		.Right_data				(Right_data			),
		.Lift_data				(Lift_data			),
		.Upper_data				(Upper_data			),
		.Lower_data				(Lower_data			),
		.tft_begin				(tft_begin			),
		.result					(result				)
	);
	
	//例化数码管
Segled_Module		Segled_Init
(
	.CLK_50M			(clk9M			),	//复位端口
	.RST_N			(Rst_n			),	//时钟端口
	.SEG_EN			(SEG_EN			),	//数码管使能端口
	.SEG_DATA		(SEG_DATA		),	//数码管数据端口
	.result			(result			)	//从A/D转换芯片输出的电压值的小数部分；
);


endmodule 