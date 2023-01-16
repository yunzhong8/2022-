`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/20 22:26:31
// Design Name: 
// Module Name: EX
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
module EX(
//input rstL,
input wire [`PCBus]           pc_i          , 
input wire [`InstBus]         inst_i        , 
output wire [`PCBus]           pc_o          ,
output wire [`InstBus]         inst_o        ,
//输入
    //运算器
        input wire [`AluOpBus]         alu_op_i      ,
        input wire[`AluOperBus]        alu_oper1_i   ,
        input wire[`AluOperBus]        alu_oper2_i   ,
    //存储器
        input wire                     mem_req_i     ,
        input wire                     mem_we_i      ,
        input wire                     mem_rwbyte_i  ,
        input wire [31:0]              mem_wdata_i   ,
        
    //寄存器组
        input wire                     regs_we_i     ,
        input wire[`RegsAddrBus]       regs_waddr_i  ,
        input wire                     memtoreg_i    ,
    
    
    //跳转写回
        input wire                    return_address_we_i   ,
        input wire[`RegsDataBus]      return_address_i   ,
    // 前一条指令是sw
        input wire                    pre_inst_exe_realte_i,
////////////////////////////输出
    //运算器运算结果
        output wire [`AluOperBus]     alu_result_o  ,
    //存储器
        output wire                  mem_req_o       , 
        output wire                  mem_we_o        ,
        output wire                  mem_rwbyte_o    ,
//        output wire   [3:0]           mem_rwsel_o,
        output wire [31:0]           mem_rwaddr_o    ,
        output wire [31:0]           mem_wdata_o     ,
        
    //寄存器组
        output wire                   regs_we_o      ,
        output wire[`RegsAddrBus]     regs_waddr_o   ,
        output wire                   memtoreg_o     ,
    //
        output wire                   is_L_inst_o,
    // stop
        output wire                   stop_o,
        input wire                    id_sw_relate_i,
        input wire                     sw_relate_i   ,
        output wire                  sw_relate_o     ,
        input wire [31:0]            mem_regs_rdata 
     
    
    );
//*******************************************Define Inner Variable（定义内部变量）***********************************************//
	//XXXX 模块变量定义
         wire alu_equ_o;
         wire [`AluOperBus]alu_rl_o;
         wire [`AluOperBus]alu_rh_o;
 //*******************************************loginc Implementation（程序逻辑实现）***********************************************//
    //$$$$$$$$$$$$$$$（  模块调用）$$$$$$$$$$$$$$$$$$// 
	  Arith_Logic_Unit ALU(
                            alu_oper1_i,alu_oper2_i,
                            alu_op_i,
                            alu_rl_o);
  //*******************************************输出变量计算***********************************************//
    assign  pc_o    = pc_i      ;
    assign  inst_o  = inst_i     ;  
    
    
    //存储器
    assign mem_req_o      =   mem_req_i;
    assign  mem_we_o      =   mem_we_i;
    assign mem_rwbyte_o   =   mem_rwbyte_i;
    assign mem_rwaddr_o   =   mem_req_i?alu_rl_o:32'h0000_0000;
//    assign mem_wdata_o    =   sw_relate_i?mem_regs_rdata:mem_wdata_i;
    assign mem_wdata_o    =  mem_wdata_i;
    
//    assign mem_rwsel_o =(mem_rwbyte_i==1'b0)?4'b1111:
//                        (alu_result_i[1:0]==2'b00)?4'b0001:
//                        (alu_result_i[1:0]==2'b01)?4'b0010:
//                        (alu_result_i[1:0]==2'b10)?4'b0100:
//                        (alu_result_i[1:0]==2'b11)?4'b1000:4'b0000;
    
    
    //寄存器组
    assign alu_result_o    =  return_address_we_i?return_address_i:alu_rl_o;
 	assign regs_waddr_o    =  regs_waddr_i;
    assign regs_we_o       =  regs_we_i;
    assign memtoreg_o      =  memtoreg_i;
   
    
   
//    assign is_L_inst_o = (mem_req_i&&~mem_we_i&&mem_rwaddr_o!=32'hBFD003F8&&mem_rwaddr_o!=32'hBFD003FC)?1'b1:1'b0;
     assign is_L_inst_o = (mem_req_i&&~mem_we_i)?1'b1:1'b0;
    //
//    assign stop_o  = (pre_inst_exe_realte_i&&mem_req_i&&~mem_we_i)?1'b1:1'b0;
      assign sw_relate_o    =   sw_relate_i;
      assign stop_o  = id_sw_relate_i?1'b0:
                     (pre_inst_exe_realte_i&&mem_req_i&&~mem_we_i)?1'b1:1'b0;    
    
endmodule
