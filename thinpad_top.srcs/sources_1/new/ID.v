`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/20 21:54:36
// Design Name: 
// Module Name: ID
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

module ID(
input wire rstL,
input wire clk,
//输入
    //指令和PC
        input wire [`PCBus]           pc_i          ,
        input wire [`InstBus]         inst_i        ,
        output wire [`PCBus]           pc_o          ,
        output wire [`InstBus]         inst_o        ,
    //寄存器组读出数据
        input wire [`RegsDataBus]     regs_rdata1_i,
        input wire [`RegsDataBus]     regs_rdata2_i,
    //执行阶段可能的数据相关
        input wire                    ex_regs_we_i,
        input wire [`RegsAddrBus]     ex_regs_waddr_i,
        input wire [`RegsDataBus]     ex_regs_wdata_i,
        input wire                    ex_memtoreg_i,
    //存储阶段可能的数据相关
        input wire                    mem_regs_we_i,
        input wire[`RegsAddrBus]      mem_regs_waddr_i,
        input wire[`RegsDataBus]      mem_regs_wdata_i,
    //当前指令延迟槽信号
        input wire                    delayslot_i,//输入本条指令是否是延迟槽
    //前一条指令是load指令
        input wire                    pre_inst_is_li,
    
//输出
    //output wire regs_re1_o,
        output reg [`RegsAddrBus]    regs_raddr1_o,//寄存器组读地址1
    //output wire regs_re2_o,
        output reg [`RegsAddrBus]    regs_raddr2_o,//寄存器组读地址2
    //运算器
        output wire [`AluOpBus]       alu_op_o,
        output wire [`AluOperBus]     alu_oper1_o,
        output wire[`AluOperBus]      alu_oper2_o,
     //存储器输出
        output wire                   mem_req_o,
        output wire                   mem_we_o,//存储器写使能信号
        output wire                   mem_rwbyte_o,//存储器读写字节,1表示读字节，0表示读双字
        output wire  [31:0]           mem_wdata_o,
    
    //寄存器输出
        output reg                    regs_we_o,//寄存器组写使能
        output reg [`RegsAddrBus]     regs_waddr_o,//寄存器写地址
        output wire                   memtoreg_o,//寄存器组写入值来自存储器
    
    
    
    
    //跳转信号
        output wire                   banch_flag_o,//跳转标志
        output reg [`PCBus]           banch_address_o,//跳转转地址
    //跳转返回地址
        output wire                   return_address_we_o,//跳转指令保存返回地址使能
        output wire [`RegsDataBus]    return_address_o,//跳转返回地址
    //延迟槽信号
        output wire                   next_delayslot_o,//下一条指令是延迟槽的标志
    //暂停
        output wire                   id_stop_o,
        output wire                   id_exe_relate_o,
    //sw和lw相关
        output wire                   id_sw_relate_o
//    //跑马灯显示数据
//       output wire [`RegsDataBus]     led_data
    );
 //输入：
//输出：
//功能：
 //*******************************************Define Inner Variable（定义内部变量）***********************************************//
 parameter regs_re1=1'b1;
 parameter regs_re2=1'b1;
//指令分解 模块变量定义
     wire [5:0]op;
     wire[4:0] rs ;
     wire [4:0]rt;
     wire [4:0]rd;
     wire[15:0] imm16;
     wire[31:0] sign_ext_imm16;
     wire[31:0] zero_ext_imm16;
     wire[25:0] imm26;
     wire[4:0] shmat;
     wire [5:0]func;
     wire[`PCBus] next_pc;

 //符号扩展器模块变量定义
      wire se_sign_i;
      wire [`AluOperBus]se_data_o;
 //指令控制信号产生模块定义
     wire[`AluOpBus] spAluOp;
     //EXE
     wire spAluSrcA;
     wire spAluSrcB;
     wire spSignedExt;
     //MEM
     wire spMemReq;
     wire spMemWrite;
     wire spMemRWByte;
     //WB
     wire spRegWirte;
     wire spRegDst;
     wire spJal;
     wire spMemToReg;
     wire spReturnAddrToReg;
    
     //分支
     wire spBeq;
     wire spBne;
     wire spBz;
     wire spBgtz;
     wire spBlez;
     //
     wire spBltz;
     wire spBgez;
    
     //跳转
     wire spJr;
     wire spJmp;
     wire spSysCall; 
 wire [`SignBus]sp_sign_o;
 
 //B类指令
     wire B;
     wire B_gt;
     wire B_equ;
     wire B_lt;
 
 //数据相关检查模块变量定义
    wire exe_relate1_o;//寄存器组1号口是否数据相关
    wire mem_relate1_o;//

    wire exe_relate2_o;//寄存器组2号口是否数据相关
    wire mem_relate2_o;
//解决数据相关后寄存器组读出数据
    wire [`RegsDataBus]regs_rdata1;
    wire[`RegsDataBus]regs_rdata2;
 //*******************************************loginc Implementation（程序逻辑实现）***********************************************//
  assign next_pc =pc_i+32'h4;
  //$$$$$$$$$$$$$$$（ 指令分解模块 模块调用）$$$$$$$$$$$$$$$$$$// 
	//模块输入：
	//模块调用：
	 assign {op,rs,rt,rd,shmat ,func}=inst_i;
     assign imm16=inst_i[15:0];
     assign sign_ext_imm16 = {{16{inst_i[15]}},inst_i[15:0]};
     assign zero_ext_imm16 = {16'h0000,inst_i[15:0]};
     assign imm26=inst_i[25:0];
     
	//模块输入输出显示：  

  //$$$$$$$$$$$$$$$（ 数据相关检查 模块调用）$$$$$$$$$$$$$$$$$$// 
	//模块调用：
	 Data_Relevant DR(
                    .rstL            (rstL),
                    .ex_regs_we_i    ( ex_regs_we_i      )     ,
                    .ex_memtoreg_i   ( ex_memtoreg_i     )     ,
                    .ex_regs_waddr_i ( ex_regs_waddr_i   )     ,
                   
                    .mem_regs_we_i   ( mem_regs_we_i     )     ,
                    .mem_regs_waddr_i( mem_regs_waddr_i  )     ,

                   
                    .regs_rwaddr1_i  ( regs_raddr1_o  )       ,
                  
                   
                    .regs_rwaddr2_i  (  regs_raddr2_o )       ,
                    
                    .exe_relate1_o   ( exe_relate1_o  )       ,
                    .mem_relate1_o   ( mem_relate1_o  )       ,
                    .exe_relate2_o   ( exe_relate2_o  )       ,
                    .mem_relate2_o   ( mem_relate2_o  )       
                   );
	//模块输入输出显示：  

 	
 	
 	 
 
   //$$$$$$$$$$$$$$$（ 寄存器组读出数据修正 ）$$$$$$$$$$$$$$$$$$// 
	//模块输入：
	//模块调用：
	assign regs_rdata1=exe_relate1_o?ex_regs_wdata_i:(mem_relate1_o?mem_regs_wdata_i:regs_rdata1_i);
    assign regs_rdata2=exe_relate2_o?ex_regs_wdata_i:(mem_relate2_o?mem_regs_wdata_i:regs_rdata2_i);
	//模块输入输出显示：  

 
 	

   //$$$$$$$$$$$$$$$（ 指令控制信号产生 模块调用）$$$$$$$$$$$$$$$$$$// 
        //模块输入：
        //模块调用：
             Signal_Produce sp(rstL,op,func,spAluOp,sp_sign_o);
             //获取EXE阶段信号
             assign  { spSignedExt,spAluSrcB,spAluSrcA }=sp_sign_o[2:0];
             //MEM
              assign {spMemRWByte,spMemWrite,spMemReq }=sp_sign_o[6:4];
              
            //WB
              assign {spMemToReg, spJal, spRegDst,spRegWirte}=sp_sign_o[11:8];
              assign spReturnAddrToReg=sp_sign_o[12];
    
    
           //分支
             assign  {spBgtz,spBz,spBne,spBeq} =sp_sign_o[19:16];
             assign spBlez=sp_sign_o[20];
             assign spBltz=(spBz==1'b1)?((rt==5'h0)?1'b1:1'b0):1'b0;
             assign spBgez=(spBz==1'b1)?((rt==5'b0_0001)?1'b1:1'b0):1'b0;
    
         //跳转
           assign {spSysCall,spJmp,spJr}=sp_sign_o[26:24];
           
             
        //模块输入输出显示：
//           always@(*)
//                $display($time,,"spAluOp=%b,sp_sign_o=%h",spAluOp,sp_sign_o);
//           always@(*)
//                $display($time,,"spBz=%b,spMemRWByte=%b,spShmatReg=%b,spJal=%b,spJmp=%b,spJalr=%b,spJr=%b,spBne=%b,spBeq=%b, spBlez=%b,spBgtz=%b,spRegDst=%b,spSignedExt=%b,spSysCall=%b,spRegWirte=%b,spAluSrc=%b,spMemWrite=%b,spMemToReg=%b",spBz,spMemRWByte,
//                     spShmatReg,spJal,spJmp,spJalr,
//                     spJr,spBne,spBeq, spBlez,
//                     spBgtz,spRegDst,spSignedExt,spSysCall,
//                     regs_we_o,spAluSrc,mem_we_o,spMemToReg);  
 	
   //$$$$$$$$$$$$$$$（ B类跳转指令 模块）$$$$$$$$$$$$$$$$$$//     
        //比较
        assign B_gt=(spBlez|spBgtz|spBz)?((regs_rdata1>`ZeroWord32B)?1'b1:1'b0):((regs_rdata1>regs_rdata2)?1'b1:1'b0);
        assign B_equ=(spBlez|spBgtz|spBz)?((regs_rdata1==`ZeroWord32B)?1'b1:1'b0):((regs_rdata1==regs_rdata2)?1'b1:1'b0);
        assign B_lt=(spBlez|spBgtz|spBz)?((regs_rdata1<`ZeroWord32B)?1'b1:1'b0):((regs_rdata1<regs_rdata2)?1'b1:1'b0);
        
        assign B=(spBeq&B_equ)|(spBne&~B_equ)|(spBltz&B_lt)|(spBgtz&B_gt)|(spBlez&(B_equ|B_lt))|(spBgez&(B_gt|B_equ));//是否存在B类指令跳转
 //*******************************************计算输出***********************************************//
     //################计算寄存器读输出################//
     assign  pc_o    = pc_i      ;
     assign  inst_o  = inst_i     ;   
      //寄存器读地址1
             always@(*)begin
                 if(rstL==`RstEnable)begin
                    regs_raddr1_o<=5'd0;
                 end else if(spSysCall)begin
                        regs_raddr1_o<=5'd2;
                 end else begin
                        regs_raddr1_o<=rs;
                 end
              end
          //寄存器读地址2
             always@(*)begin
                 if(rstL==`RstEnable)begin
                    regs_raddr2_o<=5'd0;
                 end else if(spSysCall)begin
                    regs_raddr2_o<=5'd4;
                 end else begin
                         regs_raddr2_o<=rt; 
                 end
              end 
      //################计算寄ALU(EXE)输出################//
          //ALU运算类型
             assign alu_op_o = spAluOp;
         //ALu_oper1运算器运算数1
             assign alu_oper1_o=spAluSrcA?{17'h0,shmat}:regs_rdata1;
            
        //ALu_oper2运算器运算数2
            assign alu_oper2_o=spAluSrcB?(spSignedExt?sign_ext_imm16:zero_ext_imm16):regs_rdata2;
    //################计算寄MEM输出################//
      //存储器使能
        assign mem_req_o=spMemReq;
      //存储器读写字节
        assign mem_rwbyte_o=spMemRWByte;
      
      //存储器数据写入寄存器使能
        assign memtoreg_o=spMemToReg;
      
      //存储器写使能+延迟槽
         assign mem_we_o=spMemWrite&~delayslot_i;
         assign mem_wdata_o = regs_rdata2;
    //################计算WB(regs_write)输出################//         
      //寄存器组写使能+延迟槽
          always@(*)begin
                if(rstL==`RstEnable)begin
                    regs_we_o<=`WriteDisable;
                end else begin
                    regs_we_o<=spRegWirte&~delayslot_i;
                end
           end
     //寄存器组写入地址
         always@(*)begin
                if(rstL==`RstEnable)begin
                    regs_waddr_o<=`RegsAddrLen'd0;
                end else if(spRegDst)begin
                    regs_waddr_o<=rd;
                end else if(spJal)begin//跳转地址保存的寄存器组地址
                    regs_waddr_o<=`RegsAddrLen'd31;
                end else begin
                    regs_waddr_o<=rt;
                end
         end
    //################计算跳转输出################//   
          always @(*)begin
                  if(spJr)begin
                            banch_address_o<=regs_rdata1;
                  end else if(B)begin
                            banch_address_o<=(pc_i+4)+{{14{imm16[15]}},imm16,2'h0};
                  end else if(spJmp)begin
                            banch_address_o<={next_pc[31:28],imm26,2'h0};
                  end else begin
                        banch_address_o<=32'h0;
                  end
           end
                
           assign banch_flag_o=(B|spJmp|spJr)&~delayslot_i;//跳转信号
           
     //################计算跳转返回地址输出################//   
         assign return_address_we_o=spReturnAddrToReg;//跳转保存地址使能
         assign return_address_o=pc_i+32'h8;//跳转返回地址
        
    //################计算暂停流水输出################//     
//        assign id_stop_o= ((exe_relate1_o||exe_relate2_o)&&pre_inst_is_l) ?1'b1:1'b0;
          assign id_stop_o=spMemReq;
          assign id_exe_relate_o =exe_relate1_o||exe_relate2_o;//与exe阶段发送数据相关，且exe阶段是
     //################计算延迟槽输出################//  
//        assign next_delayslot_o=banch_flag_o;//下一条指令是否是延迟槽
     assign next_delayslot_o=1'b0;//关闭指示下一条是延迟槽
     assign id_sw_relate_o = spMemWrite&&~exe_relate1_o&&exe_relate2_o;//时写入指令，同时写入和exe阶段的运行结果数据相关，可以在sw到exe阶段memwdata用mem阶段的regwdata
//     assign id_sw_relate_o = 1'b0;
   
  
 
//wire n_halt;

//SysBanchMark sbmI(
//                  .rstL           (rstL)          ,
//                  .clk            (clk)           ,
//                  .regs_rdata1    (regs_rdata1)   ,
//                  .regs_rdata2    (regs_rdata2)   ,
//                  .SysCall        (spSysCall)     ,
//                  .led_data       (led_data)      ,
//                  .n_halt          (n_halt)
//                  );

endmodule