`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 11:47:31
// Design Name: 
// Module Name: IF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include"MIPSdefines.v"
module IF(
input wire rstL,
input wire clk,
//跳转输入
//input wire [`PCBus]pc_i                           ,
input wire [`StopBus]      stop_i                 ,
input wire                 banch_flag_i           ,
input wire [`PCBus]        banch_address_i        ,
//pc输出
output reg [`PCBus]          pc_o

    );

//*******************************************Define Inner Variable（定义内部变量）***********************************************//
    reg [31:0]next_pc;
	always @(posedge clk)begin
	   if(rstL ==`RstEnable)begin
	       pc_o<=32'h8000_0000;
	       next_pc<=32'h8000_0000;
	   end else if(stop_i[0] == `StopDisable)begin
	       if(banch_flag_i)begin
	           next_pc<=banch_address_i+4'b0100;
	           pc_o<=banch_address_i;
	       end else begin
	           next_pc<=next_pc+32'h4;
	           pc_o<=next_pc;
	       end
	   end else begin
	       next_pc<=next_pc;
	       pc_o<=pc_o;
	   end
   end
 
endmodule
