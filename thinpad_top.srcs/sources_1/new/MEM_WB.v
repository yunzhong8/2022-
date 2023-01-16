`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/20 23:49:44
// Design Name: 
// Module Name: MEM_WB
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
module MEM_WB(
input wire                             rstL          ,
input wire                             clk           ,
        input  wire [`PCBus]           pc_i          ,
        input  wire [`InstBus]         inst_i        ,
        output reg [`PCBus]            pc_o          ,
        output reg [`InstBus]          inst_o        ,
        
//输入
        input wire                     mem_inst_is_L_i,
    //寄存器
        input wire                      regs_we_i,
        input wire [`RegsAddrBus]       regs_waddr_i,
        input wire [`RegsDataBus]       regs_wdata_i,
        input wire [`StopBus]           stop_i,
//输出
    //寄存器
        output  reg                      mem_inst_is_L_o,
        output reg                      regs_we_o,
        output reg [`RegsAddrBus]       regs_waddr_o,
        output reg [`RegsDataBus]       regs_wdata_o,
    //暂停流水
        output wire                     stop_o

    );//错误连续写ifelse,结果漏了一个esle
//*******************************************loginc Implementation（程序逻辑实现）***********************************************//
 
always@(posedge clk)begin
    if(rstL ==`RstEnable)begin
        pc_o<=`ZeroWord32B;
        inst_o<=`ZeroWord32B;
        
        mem_inst_is_L_o<=1'b0;
        regs_we_o<=1'b0;
        regs_waddr_o<=1'b0;
        regs_wdata_o<=`ZeroWord32B;
    end else if(stop_i[4]==`StopEnable&&stop_i[5]==`StopDisable)begin
        pc_o<=`ZeroWord32B;
        inst_o<=`ZeroWord32B;
        
        mem_inst_is_L_o<=1'b0;
        regs_we_o<=1'b0;
        regs_waddr_o<=1'b0;
        regs_wdata_o<=`ZeroWord32B;
    end else begin
        pc_o               <=    pc_i             ;
        inst_o             <=    inst_i           ;
     
        mem_inst_is_L_o    <=    mem_inst_is_L_i  ;
        regs_we_o          <=    regs_we_i        ;
        regs_waddr_o       <=    regs_waddr_i     ;
        regs_wdata_o       <=    regs_wdata_i     ;
    end
end
        
assign stop_o=1'b0;
       
        
        

            
endmodule
