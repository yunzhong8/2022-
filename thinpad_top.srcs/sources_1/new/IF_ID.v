`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/20 21:21:13
// Design Name: 
// Module Name: IF_ID
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
module IF_ID(
input wire rstL,
input wire clk,

input wire [`PCBus] pc_i,//输入暂存的pc
input wire  [`InstBus]inst_i,//输入暂存pc对应的指令
input wire [`StopBus] stop_i,
output reg [`PCBus] pc_o,//输出暂存的pc
output reg [`InstBus]inst_o//输出PC对应的指令
    );
 //*******************************************Define Inner Variable（定义内部变量）***********************************************//
	//XXXX 模块变量定义

 //*******************************************loginc Implementation（程序逻辑实现）***********************************************//  
//保存PC值
always@(posedge clk)
        if(rstL ==`RstEnable)begin
            pc_o<=`ZeroWord32B;
        end else if(stop_i[1]==`StopDisable) begin//没有暂停
            pc_o<=pc_i;
        end else if(stop_i[1] == `StopEnable&& stop_i[2]==`StopDisable)begin//暂停if阶段，exe执行0000_0000
            pc_o<=`ZeroWord32B;
        end else begin //暂停if,且id阶段也暂停
            pc_o<=pc_o;
        end         
//保存指令
    always@(posedge clk)
        if(rstL ==`RstEnable)begin
            inst_o<=`ZeroWord32B;
        end else if(stop_i[1] == `StopEnable&& stop_i[2]==`StopDisable)begin
            inst_o<=`ZeroWord32B;
        end else if(stop_i[1]==`StopDisable) begin
            inst_o<=inst_i;
        end else begin
            inst_o<=inst_o;
        end
        
endmodule
