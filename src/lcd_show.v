	module lcd_show(
		clk,
		rst_n,
		hcount,
		lcount,
		Right_data,	
		Lift_data,	
		Upper_data,	
		Lower_data,
		datain,
		lcd_out_rgb_r,
	   lcd_out_rgb_g,
      lcd_out_rgb_b
	);
	
	//输出信号申明
	input					rst_n;
	input					clk;
	
	input	[ 8:0]		hcount;				//横坐标地址
	input	[ 8:0]		lcount;				//纵坐标地址
	input	[ 8:0]		Upper_data;			//上边界地址
	input	[ 8:0]		Lower_data;			//下边界地址
	input	[ 8:0]		Right_data;			//右边界地址
	input	[ 8:0]		Lift_data ;			//左边界地址
	input	[ 7:0]		datain;				//输入信号
	
	//输出信号
	output [7:0]		lcd_out_rgb_r;
	output [7:0]		lcd_out_rgb_g;
	output [7:0]		lcd_out_rgb_b;
	
	reg [7:0]		lcd_out_rgb_r;
	reg [7:0]		lcd_out_rgb_g;
	reg [7:0]		lcd_out_rgb_b;
	
	reg [2:0]		a;

	always @ (*)
	begin
		if( ((Upper_data-9'd1) <= lcount) && (lcount <= Upper_data))
			begin                                                                            
				lcd_out_rgb_r = 8'h00;                                                        
			   lcd_out_rgb_g = 8'h00;                                                        
			   lcd_out_rgb_b = 8'hff;   
			end  
		else if( ((Lower_data-9'd1) <= lcount) && (lcount <= Lower_data))
			begin                                                                            
				lcd_out_rgb_r = 8'h00;                                                        
			   lcd_out_rgb_g = 8'h00;                                                        
			   lcd_out_rgb_b = 8'hff;   
			end 
		else if( ((Right_data-9'd1) <= hcount) && (hcount <= Right_data))
			begin                                                                            
				lcd_out_rgb_r = 8'h00;                                                        
			   lcd_out_rgb_g = 8'h00;                                                        
			   lcd_out_rgb_b = 8'hff;   
			end  
		else if( ((Lift_data-9'd5) <= hcount) && (hcount <= (Lift_data-9'd4)))
			begin                                                                            
				lcd_out_rgb_r = 8'h00;                                                        
			   lcd_out_rgb_g = 8'h00;                                                        
			   lcd_out_rgb_b = 8'hff;   
			end 			
		else
			begin
				lcd_out_rgb_r = datain;
			   lcd_out_rgb_g = datain;
			   lcd_out_rgb_b = datain;
			end			
	end
	
//	always @ (posedge clk or negedge rst_n)
//	begin
//		if(!rst_n)
//			begin
//				lcd_out_rgb_r = 8'h00;                                                        
//			   lcd_out_rgb_g = 8'h00;                                                        
//			   lcd_out_rgb_b = 8'h00;
//			end	
//	
//		else if( ( (Upper_data-9'd1) <= lcount <= (Upper_data+9'd1) ) && ( (Right_data-9'd1) <= hcount <= (Right_data+9'd1) ) )
//			begin                                                                            
//				lcd_out_rgb_r = 8'hff;                                                        
//			   lcd_out_rgb_g = 8'h00;                                                        
//			   lcd_out_rgb_b = 8'h00;   
//				a=3'd0;
//			end                                                                              
//		else if( ( (Upper_data-9'd1) <= lcount <= (Upper_data+9'd1) )&& ( (Lift_data-9'd1)  <=  hcount<= (Lift_data+9'd1) ) )
//			begin                                                                            
//				lcd_out_rgb_r = 8'hff;                                                        
//			   lcd_out_rgb_g = 8'h00;                                                        
//			   lcd_out_rgb_b = 8'h00;     
//				a=3'd1;
//			end                                                                              
//		else if( ( (Lower_data-9'd1) <= lcount <= (Lower_data+9'd1) )&& ( (Right_data-9'd1)  <= hcount <= (Right_data+9'd1) ) )
//			begin                                                                            
//				lcd_out_rgb_r = 8'hff;                                                        
//			   lcd_out_rgb_g = 8'h00;                                                        
//			   lcd_out_rgb_b = 8'h00;     
//					a=3'd2;
//			end                                                                              
//		else if( ( (Lower_data-9'd1) <= lcount <= (Lower_data+9'd1) )&& ( (Lift_data-9'd1)  <=  hcount<= (Lift_data+9'd1) ) )
//			begin
//				lcd_out_rgb_r = 8'hff;
//			   lcd_out_rgb_g = 8'h00;
//			   lcd_out_rgb_b = 8'h00;
//				a=3'd3;
//			end
//		else
//			begin
//				lcd_out_rgb_r = datain;
//			   lcd_out_rgb_g = datain;
//			   lcd_out_rgb_b = datain;
//			end
//		
//	end
	
	endmodule
	