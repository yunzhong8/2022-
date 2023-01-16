`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/20 22:09:22
// Design Name: 
// Module Name: ID_EX
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
module ID_EX(
input wire                             rstL         ,
input wire                             clk          ,
        input  wire [`PCBus]           pc_i          ,
        input  wire [`InstBus]         inst_i        ,
        output reg [`PCBus]            pc_o          ,
        output reg [`InstBus]          inst_o        ,
//ÊäÈë
    //ÔËËãÆ÷
        input wire[`AluOpBus]          alu_op_i      ,
        input wire[`AluOperBus]        alu_oper1_i   ,
        input wire[`AluOperBus]        alu_oper2_i   ,
     //´æ´¢Æ÷
        input wire                     mem_req_i     ,
        input wire                     mem_we_i      ,
        input wire                     mem_rwbyte_i  ,
        input wire[31:0]               mem_wdata_i   ,
    //¼Ä´æÆ÷×é
        input wire                     regs_we_i     ,
        input wire[`RegsAddrBus]       regs_waddr_i  ,
        input wire                     memtoreg_i    ,
    //Ìø×ªÐ´»Ø
        input wire                     return_address_we_i   ,
        input wire [`RegsDataBus]      return_address_i      ,
    //ÑÓ³Ù²Û
        input wire                     next_delaysolt_i      ,
    //
        input wire [`StopBus] stop_i,
    
////////////////////////////////////////Êä³ö
    //ÔËËãÆ÷
        output reg[`AluOpBus]           alu_op_o          ,
        output reg[`AluOperBus]         alu_oper1_o       ,
        output reg[`AluOperBus]         alu_oper2_o       ,
     //´æ´¢Æ÷
        output reg                      mem_req_o         ,        
        output reg                      mem_we_o          ,
        output reg                      mem_rwbyte_o      ,
        output reg[31:0]                mem_wdata_o       ,    
    //¼Ä´æÆ÷×é
        output reg                      regs_we_o         ,
        output reg[`RegsAddrBus]        regs_waddr_o      ,      
        output reg                      memtoreg_o        ,
    //Ìø×ªÐ´»Ø
        output reg                      return_address_we_o     ,
        output reg[`RegsDataBus]        return_address_o        ,
    //ÑÓ³Ù²Û
        output reg                      next_delaysolt_o ,
     //swÐ´Êý¾ÝÏà¹Ø
        input wire                    sw_relate_i,
         //swÐ´Ïà¹Ø
        output  reg                    sw_relate_o
    );
always@(posedge clk)begin
        if(rstL==`RstEnable)begin
            pc_o<=`ZeroWord32B;
            inst_o<=`ZeroWord32B;
            //ÔËËãÆ÷
            alu_op_o<=`ZeroWord32B;
            alu_oper1_o<=`ZeroWord32B;
            alu_oper2_o<=`ZeroWord32B;
            //´æ´¢Æ÷
            mem_req_o<=1'b0;
            mem_we_o<=1'b0;
            mem_rwbyte_o<=1'b0;
            mem_wdata_o<=32'h0;
            //¼Ä´æÆ÷×éÊý¾Ý  
            regs_we_o<=`ZeroWord32B;
            regs_waddr_o<=`ZeroWord32B;
            memtoreg_o<=1'b0;
            //Ìø×ªÐ´»Ø
            return_address_we_o<=1'b0;
            return_address_o<=`RegsAddrLen'd0;
            //ÑÓ³Ù²Û
            next_delaysolt_o<=1'b0;
             sw_relate_o<=1'b0;
           
            
         end else if(stop_i[2] ==`StopEnable && stop_i[3] == `StopDisable)begin//ÔÝÍ£id£¬exeÖ´ÐÐ0000_0000
//            $display("0,stop_i[2]:%b\t,stop_i[3]:%b\t,pc_o%h\t£¬inst_o%h\t",stop_i[2],stop_i[3],pc_o,inst_o)    ;
            pc_o                     <=      `ZeroWord32B        ;
            inst_o                   <=      `ZeroWord32B        ;
            //ÔËËãÆ÷
            alu_op_o                 <=       `ZeroWord32B     ;
            alu_oper1_o              <=       `ZeroWord32B     ;
            alu_oper2_o              <=       `ZeroWord32B     ;
            //´æ´¢Æ÷
            mem_req_o                <=       1'b0             ;
            mem_we_o                 <=       1'b0             ;
            mem_rwbyte_o             <=       1'b0             ;
            mem_wdata_o              <=       32'h0            ;
            //¼Ä´æÆ÷×éÊý¾Ý  
            regs_we_o                <=       `ZeroWord32B     ;
            regs_waddr_o             <=       `ZeroWord32B     ;
            memtoreg_o               <=       1'b0             ;
            //Ìø×ªÐ´»Ø
            return_address_we_o      <=       1'b0             ;
            return_address_o         <=       `RegsAddrLen'd0  ;
            //ÑÓ³Ù²Û
               next_delaysolt_o      <=       1'b0             ;
              sw_relate_o<=1'b0;
          end else if(stop_i[2] ==`StopDisable) begin
//                $display("1,stop_i[2]:%b\t,stop_i[3]:%b\t,pc_o%h\t£¬inst_o%h\t",stop_i[2],stop_i[3],pc_o,inst_o); 
                pc_o                 <=   pc_i                 ;
                inst_o               <=   inst_i               ;
                alu_op_o             <=   alu_op_i             ;
                alu_oper1_o          <=   alu_oper1_i          ;
                alu_oper2_o          <=   alu_oper2_i          ;
                mem_req_o            <=   mem_req_i            ;
                mem_we_o             <=   mem_we_i             ;
                mem_rwbyte_o         <=   mem_rwbyte_i         ;
                mem_wdata_o          <=   mem_wdata_i          ;
                regs_we_o            <=   regs_we_i            ; 
                regs_waddr_o         <=   regs_waddr_i         ;
                memtoreg_o           <=   memtoreg_i           ;
                return_address_we_o  <=   return_address_we_i  ;
                return_address_o     <=   return_address_i     ;
                next_delaysolt_o     <=   next_delaysolt_i     ;
                sw_relate_o<=sw_relate_i;
         end else begin //ÔÝÍ£id£¬exe£¬
//                $display("2,stop_i[2]:%b\t,stop_i[3]:%b\t,pc_o%h\t£¬inst_o%h\t",stop_i[2],stop_i[3],pc_o,inst_o) ;
                pc_o                 <=   pc_o                 ;
                inst_o               <=   inst_o               ;
                alu_op_o             <=   alu_op_o             ;
                alu_oper1_o          <=   alu_oper1_o          ;
                alu_oper2_o          <=   alu_oper2_o          ;
                mem_req_o            <=   mem_req_o            ;
                mem_we_o             <=   mem_we_o             ;
                mem_rwbyte_o         <=   mem_rwbyte_o         ;
                mem_wdata_o          <=   mem_wdata_o          ;
                regs_we_o            <=   regs_we_o            ; 
                regs_waddr_o         <=   regs_waddr_o         ;
                memtoreg_o           <=   memtoreg_o           ;
                return_address_we_o  <=   return_address_we_o  ;
                return_address_o     <=   return_address_o     ;
                next_delaysolt_o     <=   next_delaysolt_o     ;
                sw_relate_o<=sw_relate_o;
         end
        
 end

        

endmodule
