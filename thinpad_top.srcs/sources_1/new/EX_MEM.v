`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/20 23:29:11
// Design Name: 
// Module Name: EX_MEM
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
module EX_MEM(
input wire rstL,
input wire clk,
input  wire [`PCBus]           pc_i          , 
input  wire [`InstBus]         inst_i        , 
output reg [`PCBus]            pc_o          , 
output reg [`InstBus]          inst_o        , 
//ÊäÈë
    //ÔËËã½á¹û
        input wire [`AluOperBus]     alu_result_i,
    //´æ´¢Æ÷
        input wire                   mem_req_i,
        input wire                   mem_we_i,
        input wire                   mem_rwbyte_i,
        input wire[31:0]             mem_rwaddr_i,
        input wire[31:0]             mem_wdata_i,
    //¼Ä´æÆ÷×é
        input wire                   regs_we_i,
        input wire[`RegsAddrBus]     regs_waddr_i,
        input wire                   memtoreg_i,
        input wire[`StopBus]         stop_i,
   
        
//Êä³ö
    //ÔËËã½á¹û
        output reg[`AluOperBus]      alu_result_o,
    //´æ´¢Æ÷
        output reg                   mem_req_o,
        output reg                   mem_we_o,
        output reg                   mem_rwbyte_o,
        output reg [31:0]            mem_rwaddr_o,
        output reg [31:0]            mem_wdata_o,
    //¼Ä´æÆ÷×é
        output reg                   regs_we_o,
        output reg[`RegsAddrBus]     regs_waddr_o,
        output reg                   memtoreg_o  ,
         input wire                   sw_relate_i ,
         output reg                   sw_relate_o ,
         
         input                           id_sw_relate_i ,
         output reg                      id_sw_relate_o ,
         
         input wire                      sw_relate_data_we,
         input  wire  [31:0]             sw_relate_data_i,
         output reg   [31:0]             sw_relate_data_o
   
        
        

    );
    
 always@(posedge clk)
        if(rstL ==`RstEnable)begin
                sw_relate_data_o<=`ZeroWord32B;
        end else begin
            if(sw_relate_data_we)
                 sw_relate_data_o<=sw_relate_data_i;
            else
                sw_relate_data_o<=sw_relate_data_o;
        end
     always@(posedge clk)
        if(rstL ==`RstEnable) begin
                inst_o<=`ZeroWord32B;
        end else begin
                 inst_o<=inst_i;
        end   
//ÔËËã½á¹û    
    always@(posedge clk)begin
        if(rstL==`RstEnable)begin
            pc_o<=`ZeroWord32B;
            inst_o<=`ZeroWord32B;
            alu_result_o<=`ZeroWord32B;
            //´æ´¢Æ÷
            mem_req_o<=1'b0;
            mem_we_o<=1'b0;
            mem_rwbyte_o<=1'b0;
            mem_rwaddr_o<=`ZeroWord32B;
            mem_wdata_o<=`ZeroWord32B;
            //¼Ä´æÆ÷
            regs_we_o<=`ZeroWord32B;
            regs_waddr_o<=`ZeroWord32B;
            memtoreg_o<=1'b0;
            sw_relate_o <=1'b0;
            id_sw_relate_o<=1'b0;
        end else if(stop_i[3]==`StopEnable&&stop_i[4]==`StopDisable) begin
            pc_o<=`ZeroWord32B;
            inst_o<=`ZeroWord32B;
            alu_result_o<=`ZeroWord32B;
            //´æ´¢Æ÷
            mem_req_o<=1'b0;
            mem_we_o<=1'b0;
            mem_rwbyte_o<=1'b0;
            mem_rwaddr_o<=`ZeroWord32B;
            mem_wdata_o<=`ZeroWord32B;
            //¼Ä´æÆ÷
            regs_we_o<=`ZeroWord32B;
            regs_waddr_o<=`ZeroWord32B;
            memtoreg_o<=1'b0;
            sw_relate_o <=1'b0;
            id_sw_relate_o<=1'b0;
        end else if(stop_i[3]==`StopDisable) begin
            pc_o          <=        pc_i           ;
            inst_o        <=        inst_i         ;
            alu_result_o  <=        alu_result_i   ;
            //´æ´¢Æ÷
            mem_req_o     <=        mem_req_i      ;    
            mem_we_o      <=        mem_we_i       ;
            mem_rwbyte_o  <=        mem_rwbyte_i   ; 
            mem_rwaddr_o  <=        mem_rwaddr_i   ;
            mem_wdata_o   <=        mem_wdata_i    ;
            //¼Ä´æÆ÷
            regs_we_o     <=        regs_we_i      ;
            regs_waddr_o  <=        regs_waddr_i   ;
            memtoreg_o    <=        memtoreg_i     ;
            sw_relate_o <=sw_relate_i;
            id_sw_relate_o<=id_sw_relate_i;
        end else begin
            pc_o          <=        pc_o           ;
            inst_o        <=        inst_o         ;
            alu_result_o  <=        alu_result_o   ;
            //´æ´¢Æ÷
            mem_req_o     <=        mem_req_o      ;    
            mem_we_o      <=        mem_we_o       ;
            mem_rwbyte_o  <=        mem_rwbyte_o   ; 
            mem_rwaddr_o  <=        mem_rwaddr_o   ;
            mem_wdata_o   <=        mem_wdata_o    ;
            //¼Ä´æÆ÷
            regs_we_o     <=        regs_we_o      ;
            regs_waddr_o  <=        regs_waddr_o   ;
            memtoreg_o    <=        memtoreg_o     ;
            sw_relate_o <=sw_relate_o;
            id_sw_relate_o<=id_sw_relate_o;
        end
end
        
 
     
endmodule
