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
//����
    //������
        input wire[`AluOpBus]          alu_op_i      ,
        input wire[`AluOperBus]        alu_oper1_i   ,
        input wire[`AluOperBus]        alu_oper2_i   ,
     //�洢��
        input wire                     mem_req_i     ,
        input wire                     mem_we_i      ,
        input wire                     mem_rwbyte_i  ,
        input wire[31:0]               mem_wdata_i   ,
    //�Ĵ�����
        input wire                     regs_we_i     ,
        input wire[`RegsAddrBus]       regs_waddr_i  ,
        input wire                     memtoreg_i    ,
    //��תд��
        input wire                     return_address_we_i   ,
        input wire [`RegsDataBus]      return_address_i      ,
    //�ӳٲ�
        input wire                     next_delaysolt_i      ,
    //
        input wire [`StopBus] stop_i,
    
////////////////////////////////////////���
    //������
        output reg[`AluOpBus]           alu_op_o          ,
        output reg[`AluOperBus]         alu_oper1_o       ,
        output reg[`AluOperBus]         alu_oper2_o       ,
     //�洢��
        output reg                      mem_req_o         ,        
        output reg                      mem_we_o          ,
        output reg                      mem_rwbyte_o      ,
        output reg[31:0]                mem_wdata_o       ,    
    //�Ĵ�����
        output reg                      regs_we_o         ,
        output reg[`RegsAddrBus]        regs_waddr_o      ,      
        output reg                      memtoreg_o        ,
    //��תд��
        output reg                      return_address_we_o     ,
        output reg[`RegsDataBus]        return_address_o        ,
    //�ӳٲ�
        output reg                      next_delaysolt_o ,
     //swд�������
        input wire                    sw_relate_i,
         //swд���
        output  reg                    sw_relate_o
    );
always@(posedge clk)begin
        if(rstL==`RstEnable)begin
            pc_o<=`ZeroWord32B;
            inst_o<=`ZeroWord32B;
            //������
            alu_op_o<=`ZeroWord32B;
            alu_oper1_o<=`ZeroWord32B;
            alu_oper2_o<=`ZeroWord32B;
            //�洢��
            mem_req_o<=1'b0;
            mem_we_o<=1'b0;
            mem_rwbyte_o<=1'b0;
            mem_wdata_o<=32'h0;
            //�Ĵ���������  
            regs_we_o<=`ZeroWord32B;
            regs_waddr_o<=`ZeroWord32B;
            memtoreg_o<=1'b0;
            //��תд��
            return_address_we_o<=1'b0;
            return_address_o<=`RegsAddrLen'd0;
            //�ӳٲ�
            next_delaysolt_o<=1'b0;
             sw_relate_o<=1'b0;
           
            
         end else if(stop_i[2] ==`StopEnable && stop_i[3] == `StopDisable)begin//��ͣid��exeִ��0000_0000
//            $display("0,stop_i[2]:%b\t,stop_i[3]:%b\t,pc_o%h\t��inst_o%h\t",stop_i[2],stop_i[3],pc_o,inst_o)    ;
            pc_o                     <=      `ZeroWord32B        ;
            inst_o                   <=      `ZeroWord32B        ;
            //������
            alu_op_o                 <=       `ZeroWord32B     ;
            alu_oper1_o              <=       `ZeroWord32B     ;
            alu_oper2_o              <=       `ZeroWord32B     ;
            //�洢��
            mem_req_o                <=       1'b0             ;
            mem_we_o                 <=       1'b0             ;
            mem_rwbyte_o             <=       1'b0             ;
            mem_wdata_o              <=       32'h0            ;
            //�Ĵ���������  
            regs_we_o                <=       `ZeroWord32B     ;
            regs_waddr_o             <=       `ZeroWord32B     ;
            memtoreg_o               <=       1'b0             ;
            //��תд��
            return_address_we_o      <=       1'b0             ;
            return_address_o         <=       `RegsAddrLen'd0  ;
            //�ӳٲ�
               next_delaysolt_o      <=       1'b0             ;
              sw_relate_o<=1'b0;
          end else if(stop_i[2] ==`StopDisable) begin
//                $display("1,stop_i[2]:%b\t,stop_i[3]:%b\t,pc_o%h\t��inst_o%h\t",stop_i[2],stop_i[3],pc_o,inst_o); 
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
         end else begin //��ͣid��exe��
//                $display("2,stop_i[2]:%b\t,stop_i[3]:%b\t,pc_o%h\t��inst_o%h\t",stop_i[2],stop_i[3],pc_o,inst_o) ;
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
