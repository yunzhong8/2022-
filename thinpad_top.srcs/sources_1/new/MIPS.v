`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/20 23:58:06
// Design Name: 
// Module Name: MIPS
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
module MIPS(
input wire                       rstL                   ,
input wire                       clk                    ,
//输入
    //指令存储器读出数据
        input wire[`InstBus]      rom_inst_i            ,
    //数据存储器读出数据
        input wire [`RegsDataBus] ram_rdata_i           ,
        input wire [31:0]         serial_rdata_i        ,
//输出
    //指令存储器读地址
        output wire[`PCBus]       rom_raddr_o           ,
    //数据存储器
        output wire [`MemAddrBus]         ram_rwaddr_o  ,
        output wire               ram_we_o              ,
        output wire[3:0]          ram_rwsel_o           ,
        output wire[`RegsDataBus] ram_wdata_o           ,
        output wire               ram_req_o             ,
        output wire                write_wb_regs_data_o  ,//sw写入数据更新使能
        output wire [`RegsDataBus] wb_regs_data_o       ,//正确的sw数据
        
        output wire [31:0] debug_wb_pc                  ,
        output wire [3:0]  debug_wb_rf_wen              ,
        output wire [4:0]  debug_wb_rf_wnum             ,
        output wire [31:0] debug_wb_rf_wdata            
        
    //跑马灯显示数据
//        output [`RegsDataBus]      led_data
    );
//*******************************************Define Inner Variable（定义内部变量）***********************************************//
//命名规则 哪个阶段产生的_——最终哪个阶段使用的—属性——输入输出高低电平有效
    
     //ID 模块变量定义 id
         wire [`PCBus]    id_pc_o;
         wire [`InstBus]  id_inst_o;
         //寄存器组读
            wire id_regs_re1_o;
            wire [`RegsAddrBus]id_regs_raddr1_o;
            
            wire id_regs_re2_o;
            wire [`RegsAddrBus]id_regs_raddr2_o;
        //运算器
            wire [`AluOpBus]id_alu_op_o;
            wire [`AluOperBus]id_alu_oper1_o;
            wire [`AluOperBus] id_alu_oper2_o;
            wire[`AluShmatBus]id_alu_shmat_o;
         
         //存储器
            wire id_mem_req_o;
            wire id_mem_we_o;//存储器写使能信号
            wire id_mem_rwbyte_o;//存储器读写字节
            wire [31:0]id_mem_wdata_o;
         //寄存器组写
            wire id_regs_we_o;
            wire[`RegsAddrBus] id_regs_waddr_o;
            wire id_memtoreg_o;
        //跳转信号
            wire id_banch_flag_o;
            wire[`PCBus] id_banch_address_o;
            wire id_return_address_we_o;
            wire [`RegsDataBus]id_return_address_o;
        //延迟槽信号
            wire id_next_delayslot_o;
            
     //寄存器组模块变量定义
        //寄存器组读
            wire rf_re1_i;
            wire [`RegsDataBus]rf_rdata1_o;
            wire rf_re2_i;
            wire [`RegsDataBus]rf_rdata2_o;
        //寄存器组写
            wire rf_we_i;
            wire[`RegsAddrBus] rf_waddr_i;
            wire[`RegsDataBus]rf_wdata_i;
         //暂停
           wire id_stop_o;
    
     //ID_EX模块变量定义
         wire [`PCBus]    idex_pc_o;
         wire [`InstBus]  idex_inst_o;
         //运算器
            wire[`AluOpBus]idex_alu_op_o;
            wire[`AluOperBus]idex_alu_oper1_o;
            wire[`AluOperBus]idex_alu_oper2_o;
            wire[`AluShmatBus]idex_alu_shmat_o;
        //存储器
            wire idex_mem_we_o;
            wire idex_mem_rwbyte_o;
            wire idex_mem_req_o;
            wire [31:0]idex_mem_wdata_o;
         //寄存器组写
            wire[`RegsAddrBus]idex_regs_waddr_o;
            wire idex_regs_we_o;
            wire idex_memtoreg_o;
        //跳转写回
            wire idex_return_address_we_o;
            wire [`RegsDataBus]idex_return_address_o;
        //延迟槽
            wire idex_next_delayslot_o;
    
     //EX ex模块定义
         wire [`PCBus]    ex_pc_o;
         wire [`InstBus]  ex_inst_o;
        //运算器
           wire[`AluOperBus] ex_alu_result_o;
        //存储器
            wire ex_mem_we_o;
            wire ex_mem_rwbyte_o;
            wire [`MemDataBus]ex_mem_wdata_o;
             wire ex_mem_req_o;
        //寄存器组
           wire[`RegsAddrBus] ex_regs_waddr_o;
           wire ex_regs_we_o;
           wire ex_memtoreg_o;
        //
           wire ex_is_L_inst_o;
     
     //EX_MEM em
         wire [`PCBus]    em_pc_o;
         wire [`InstBus]  em_inst_o;
        //运算器
            wire [`AluOperBus]em_alu_result_o;
        //寄存器组
            wire em_regs_we_o;
            wire [`RegsAddrBus]em_regs_waddr_o;
            wire em_memtoreg_o;
        //存储器
            wire em_mem_we_o;
            wire [`MemDataBus]em_mem_wdata_o;
            wire em_mem_rwbyte_o;
            wire em_mem_req_o;
            
     //MEM 
         wire [`PCBus]    mem_pc_o;
         wire [`InstBus]  mem_inst_o;
         //寄存器组
           wire mem_regs_we_o;
           wire [`RegsAddrBus]mem_regs_waddr_o;
           wire [`RegsDataBus]mem_regs_wdata_o;
        //存储器
           wire mem_mem_we_o;
           wire [`MemAddrBus]mem_mem_rwaddr_o;
           wire [3:0]mem_mem_rwsel_o;
           wire[`MemDataBus]mem_mem_wdata_o;
           wire mem_mem_req_o;
           wire mem_inst_is_L_o;
         
     //MEM_WE
         wire [`PCBus]    mw_pc_o;
         wire [`InstBus]  mw_inst_o;
         wire mw_regs_we_o;
         wire [`RegsAddrBus]mw_regs_waddr_o;
         wire [`RegsDataBus]mw_regs_wdata_o;
         
         wire mw_inst_is_L_o;
     //WB
        wire wb_stop_o;
//*******************************************loginc Implementation（程序逻辑实现）***********************************************//
    
    //$$$$$$$$$$$$$$$（ IF取指 模块）$$$$$$$$$$$$$$$$$$// 
     //IF 模块变量定义 
        wire [`PCBus]if_pc_o;
        wire [`StopBus]ctrl_stop_o;
     //code
        IF IFI(
        .rstL             (rstL),
        .clk              (clk),
//        .pc_i             (pi_pc_o),
        .stop_i           (ctrl_stop_o),
        .banch_flag_i     (id_banch_flag_o),
        .banch_address_i  (id_banch_address_o),
        .pc_o             (if_pc_o)
                );
   assign rom_raddr_o= if_pc_o;       
    
    
        
    //$$$$$$$$$$$$$$$（IFID取指译码暂存  模块）$$$$$$$$$$$$$$$$$$// 
     //IF_ID 模块变量定义 ifid
         wire [`PCBus] ifid_pc_o;
         wire [`InstBus]ifid_inst_o;
         IF_ID IFIDI(
                .rstL          (rstL)          ,
                .clk           (clk)           ,
                .pc_i          (if_pc_o)       ,
                .inst_i        (rom_inst_i)    ,
                .stop_i        (ctrl_stop_o)   ,      
                .pc_o          (ifid_pc_o)     ,
                .inst_o        (ifid_inst_o )
         );
   
    
   
    
    
    //$$$$$$$$$$$$$$$（ ID译码 模块）$$$$$$$$$$$$$$$$$$// 
    wire id_exe_relate_o;
     wire id_sw_relate_o ;
         ID IDI(
                .rstL          (rstL),
                .clk           (clk),
                //输入
                    .pc_i          (ifid_pc_o),
                    .inst_i        (ifid_inst_o), 
                    .pc_o          (id_pc_o),
                    .inst_o        (id_inst_o), 
                    //输入寄存器组读出数据
                        .regs_rdata1_i          (rf_rdata1_o),
                        .regs_rdata2_i          (rf_rdata2_o),
                    //执行阶段可能的数据相关
                        .ex_regs_we_i           (ex_regs_we_o),
                        .ex_regs_waddr_i        (ex_regs_waddr_o),
                        .ex_regs_wdata_i        (ex_alu_result_o),
                        .ex_memtoreg_i          (ex_memtoreg_o),
                    //存储阶段可能的数据相关
                        .mem_regs_we_i         (mem_regs_we_o),
                        .mem_regs_waddr_i      (mem_regs_waddr_o),
                        .mem_regs_wdata_i      (mem_regs_wdata_o),
                    //延迟槽信号
                        .delayslot_i           (idex_next_delayslot_o),
                    //前一条指令是L指令
                        .pre_inst_is_li         (ex_is_L_inst_o)    ,
                //输出
                     //寄存器组信号
                        .regs_raddr1_o         (id_regs_raddr1_o),
                        .regs_raddr2_o         (id_regs_raddr2_o),
                    //输出运算器
                        .alu_op_o              (id_alu_op_o),
                        .alu_oper1_o           (id_alu_oper1_o),
                        .alu_oper2_o           (id_alu_oper2_o),
                      //存储器输出
                        .mem_req_o            (id_mem_req_o),
                        .mem_we_o             (id_mem_we_o),
                        .mem_rwbyte_o         (id_mem_rwbyte_o),
                        .mem_wdata_o          (id_mem_wdata_o),
                        
                    //输出寄存器组
                        .regs_we_o            (id_regs_we_o),
                        .regs_waddr_o         (id_regs_waddr_o),
                        .memtoreg_o           (id_memtoreg_o),

                    //跳转修改PC
                        .banch_flag_o        (id_banch_flag_o),
                        .banch_address_o     (id_banch_address_o),
                    //跳转返回地址
                        .return_address_we_o (id_return_address_we_o),
                        .return_address_o    (id_return_address_o),
                    //延迟槽信号
                        .next_delayslot_o   (id_next_delayslot_o),
                    //流水暂停指令
                        .id_stop_o          (id_stop_o)        ,
                        .id_exe_relate_o    (id_exe_relate_o)   ,//id阶段指令与exe阶段指令数据相关
                      //sw的写入数据相关
                        .id_sw_relate_o     (id_sw_relate_o)  //id阶段sw的写入数据和exe相关
                    //跑马灯显示数据
//                        .led_data           (led_data)
                   
                );
        //显示部分
//          Instruct_Display_id IDI_id(  ifid_inst_o,ifid_pc_o);//译码阶段指令
        //#################（ID译码 模块结束）#################// 
    
    
    
    
    //$$$$$$$$$$$$$$$（ 寄存器组 模块）$$$$$$$$$$$$$$$$$$// 
         Reg_File RFI(
                   .rf_in_rstL   ( rstL )        ,
                   .rf_in_clk    ( clk )         ,
                   
                     //输入
                         //输入寄存器读读
                       .rf_in_re1           (   1'b1              )      ,
                       .rf_in_raddr1        (   id_regs_raddr1_o  )      ,
                       .rf_in_re2           (   1'b1              )      ,
                       .rf_in_raddr2        (   id_regs_raddr2_o  )      , 
                       //写数据
                        .rf_in_we           (   mw_regs_we_o      )      ,
                        .rf_in_waddr        (   mw_regs_waddr_o   )      ,
                        .rf_in_wdata        (   mw_regs_wdata_o   )      ,
                         
                     //输出寄存器组读
                       .rf_out_rdata1       (  rf_rdata1_o    )          ,
                       .rf_out_rdata2       (  rf_rdata2_o    )          
                     ); 
                     
                     
      //debug
       assign debug_wb_rf_wen   =  {4{mw_regs_we_o}} ;
       assign debug_wb_rf_wnum  =  mw_regs_waddr_o   ;
       assign debug_wb_rf_wdata =  mw_regs_wdata_o   ;
    //#################（寄存器组  模块结束）#################//  
    
    
     
     
    //$$$$$$$$$$$$$$$（ IDEX译码执行暂存 模块）$$$$$$$$$$$$$$$$$$//  
     wire idex_sw_relate_o;
             ID_EX IDEXI(
                        .rstL            ( rstL )     ,
                        .clk             ( clk  )     ,
                        .pc_i          (id_pc_o),
                        .inst_i        (id_inst_o), 
                        .pc_o          (idex_pc_o),
                        .inst_o        (idex_inst_o), 
                         //输入
                            //运算器
                               .alu_op_i      ( id_alu_op_o       )        ,
                               .alu_oper1_i   ( id_alu_oper1_o    )        ,
                               .alu_oper2_i   ( id_alu_oper2_o    )        ,
                            //存储器
                                .mem_req_i     ( id_mem_req_o         )     ,                     
                                .mem_we_i      ( id_mem_we_o          )     ,                     
                                .mem_rwbyte_i  ( id_mem_rwbyte_o      )     ,                     
                                .mem_wdata_i   ( id_mem_wdata_o       )     ,                     
                            //寄存器组
                               .regs_we_i      ( id_regs_we_o        )     ,
                               .regs_waddr_i   ( id_regs_waddr_o     )     ,
                               .memtoreg_i     ( id_memtoreg_o       )     ,
                            
                            //跳转写回
                               .return_address_we_i  ( id_return_address_we_o    )         ,
                               .return_address_i     ( id_return_address_o       )         ,
                            
                            //延迟槽
                               .next_delaysolt_i    (  id_next_delayslot_o  )              ,
                               .stop_i               ( ctrl_stop_o)                        ,
            
                        //输出
                            //运算器
                            .alu_op_o               ( idex_alu_op_o       )          ,
                            .alu_oper1_o            ( idex_alu_oper1_o    )          ,
                            .alu_oper2_o            ( idex_alu_oper2_o    )          ,
                            //存储器                                                   
                            .mem_req_o              ( idex_mem_req_o      )          ,
                            .mem_we_o               ( idex_mem_we_o       )          ,
                            .mem_rwbyte_o           ( idex_mem_rwbyte_o   )          ,
                            .mem_wdata_o            ( idex_mem_wdata_o    )          ,
                            //寄存器                                                        
                            .regs_we_o              ( idex_regs_we_o        )        ,
                            .regs_waddr_o           ( idex_regs_waddr_o     )        ,
                            .memtoreg_o             ( idex_memtoreg_o       )        ,
                           //跳转写回                                                    
                            .return_address_we_o    ( idex_return_address_we_o )     ,
                            .return_address_o       ( idex_return_address_o    )     ,
                              //sw写相关
                               .sw_relate_i         (id_sw_relate_o),//当前指令是与前一条指令待写入寄存器组的数据相关
                            //SW相关
                            .sw_relate_o            (idex_sw_relate_o),
                           //延迟槽
                            .next_delaysolt_o       ( idex_next_delayslot_o )     
                        );
    
    //$$$$$$$$$$$$$$$（ EX执行 模块）$$$$$$$$$$$$$$$$$$//  
    wire [31:0]ex_mem_rwaddr_o;
     wire ex_sw_relate_o;
    wire ex_stop_o;
         EX EXI(
//                 .rstL                   (rstL)                      ,
                  .pc_i          (idex_pc_o),
                  .inst_i        (idex_inst_o), 
                  .pc_o          (ex_pc_o),
                  .inst_o        (ex_inst_o), 
                 //输入
                     //运算器
                       .alu_op_i         (idex_alu_op_o      )       ,
                       .alu_oper1_i      (idex_alu_oper1_o   )       ,
                       .alu_oper2_i      (idex_alu_oper2_o   )       ,
                     //存储器
                       .mem_req_i         (  idex_mem_req_o     )      ,
                       .mem_we_i          (  idex_mem_we_o      )      ,
                       .mem_rwbyte_i      (  idex_mem_rwbyte_o  )      ,
                       .mem_wdata_i       (  idex_mem_wdata_o   )      ,
                    //寄存器组
                      .regs_we_i          ( idex_regs_we_o     )       ,
                      .regs_waddr_i       ( idex_regs_waddr_o  )       ,
                      .memtoreg_i         ( idex_memtoreg_o    )       ,
                    
                    //跳转写回
                       .return_address_we_i  ( idex_return_address_we_o  )   ,
                       .return_address_i     ( idex_return_address_o     )   ,
                    //
                       .pre_inst_exe_realte_i      (id_exe_relate_o       )               ,
                //输出
                    //运算器
                        .alu_result_o       (ex_alu_result_o)                ,
                    //存储器
                       . mem_req_o         ( ex_mem_req_o        )    ,
                       . mem_we_o          ( ex_mem_we_o         )    ,
                       . mem_rwbyte_o      ( ex_mem_rwbyte_o     )    ,
                       .mem_rwaddr_o       ( ex_mem_rwaddr_o     )    ,
                       . mem_wdata_o       ( ex_mem_wdata_o      )    ,
                    //寄存器组
                      .regs_we_o           (  ex_regs_we_o     )       ,
                      .regs_waddr_o        (  ex_regs_waddr_o  )       ,
                      .memtoreg_o          (  ex_memtoreg_o    )       ,
                   //当前指令是不是L
                      .is_L_inst_o         (  ex_is_L_inst_o  )       ,
                  //暂停流水
                      .stop_o              (ex_stop_o)         ,
                       .id_sw_relate_i          (id_sw_relate_o),//当前exe阶段指令和sw待写入数据相关
                        .sw_relate_i       (idex_sw_relate_o)           ,//当前指令是与前一条指令待写入寄存器组的数据相关
                        .sw_relate_o        (ex_sw_relate_o)            ,
                        .mem_regs_rdata     (mem_regs_wdata_o)          
                     
                       
         );
   
     
    //$$$$$$$$$$$$$$$（ EXMEM执行访存暂存 模块）$$$$$$$$$$$$$$$$$$//  
    wire [31:0]em_mem_rwaddr_o;
    wire em_sw_relate_o;
    wire em_id_sw_relate_o;
    wire [31:0]em_sw_relate_data_o;
         EX_MEM EXMEMI(
                        .rstL          (rstL),
                        .clk           (clk) ,
                        .pc_i          (ex_pc_o),
                        .inst_i        (ex_inst_o), 
                        .pc_o          (em_pc_o),
                        .inst_o        (em_inst_o), 
                        //输入
                            //运算器
                                 .alu_result_i      (ex_alu_result_o)    ,
                            //存储器
                                 .mem_req_i         ( ex_mem_req_o    )  ,
                                 .mem_we_i          ( ex_mem_we_o     )  ,
                                 .mem_rwbyte_i      ( ex_mem_rwbyte_o )  ,
                                 .mem_rwaddr_i      ( ex_mem_rwaddr_o )  ,
                                 .mem_wdata_i       ( ex_mem_wdata_o  )  ,
                                 
                            //寄存器组
                                .regs_we_i          (ex_regs_we_o)       ,
                                .regs_waddr_i       (ex_regs_waddr_o)    ,
                                .memtoreg_i         (ex_memtoreg_o)      ,
                                .stop_i              (ctrl_stop_o)       ,
                               
                            
                                
                        //输出
                            //运算器
                                 .alu_result_o       (em_alu_result_o)   ,
                            //存储器
                                 .mem_req_o          ( em_mem_req_o    ) ,
                                 .mem_we_o           ( em_mem_we_o     ) ,
                                 .mem_rwbyte_o       ( em_mem_rwbyte_o ) ,
                                 .mem_rwaddr_o       ( em_mem_rwaddr_o )  ,
                                 .mem_wdata_o        ( em_mem_wdata_o  ) ,
                                 
                            //寄存器组
                                 .regs_we_o          ( em_regs_we_o    ),
                                 .regs_waddr_o       ( em_regs_waddr_o ),
                                 .memtoreg_o         ( em_memtoreg_o   ),
                                 .sw_relate_i       (ex_sw_relate_o)     ,
                                 .sw_relate_o       (em_sw_relate_o) ,   
                                 
                                 .id_sw_relate_i      (id_sw_relate_o) ,//exe执行指令与下一条指令发送swload相关   
                                 .id_sw_relate_o      (em_id_sw_relate_o) ,   
//                                 .                      
                                 .sw_relate_data_we   (em_id_sw_relate_o),   //mem阶段指令与下一条指令sw发送，sw写入数据相关
                                 .sw_relate_data_i    (mem_regs_wdata_o), //   mem阶段的寄存器组写入数据保存
                                 .sw_relate_data_o    (em_sw_relate_data_o)//输出上个阶段寄存器组写入数据
                                                                  
                                 
                                  
                            
                                
         );
         assign write_wb_regs_data_o= em_sw_relate_o;//sw阶段写入数据不是mem传出数据
         assign  wb_regs_data_o= em_sw_relate_data_o;//正确的sw写入数据
   
    //$$$$$$$$$$$$$$$（ MEM访存 模块）$$$$$$$$$$$$$$$$$$//  
    wire mem_stop_o;
         MEM MEMI(
                 .rstL(rstL),
                  .pc_i          (em_pc_o),
                  .inst_i        (em_inst_o), 
                  .pc_o          (mem_pc_o),
                  .inst_o        (mem_inst_o), 
                //输入
                    //运算结果
                        .alu_result_i(em_alu_result_o),
                        .serial_rdata_i(serial_rdata_i),
                    //存储器
                        .mem_req_i(em_mem_req_o),
                        .mem_we_i(em_mem_we_o),
                        .mem_rwbyte_i(em_mem_rwbyte_o),
                        .mem_rwaddr_i (em_mem_rwaddr_o),
                        .mem_wdata_i(em_mem_wdata_o),
                        .mem_rdata_i(ram_rdata_i),
                    //寄存器组
                        .regs_waddr_i(em_regs_waddr_o),
                        .regs_we_i(em_regs_we_o),
                        .memtoreg_i(em_memtoreg_o),
                   //exe阶段是不是L指令
                        .exe_is_L_inst_o(ex_is_L_inst_o),
                    
                //输出
                    //存储器
                       .mem_req_o    (mem_mem_req_o),
                       .mem_we_o     (mem_mem_we_o)     ,
                       .mem_rwaddr_o  (mem_mem_rwaddr_o)  ,
                       .mem_rwsel_o  (mem_mem_rwsel_o)  ,
                       .mem_wdata_o  (mem_mem_wdata_o)  ,
                      
                    //寄存器组                            
                        .regs_we_o    (mem_regs_we_o)      ,
                        .regs_waddr_o (mem_regs_waddr_o)   ,
                        .regs_wdata_o (mem_regs_wdata_o)   ,
                    //当前指令是sw
                        .inst_is_s_o  (mem_inst_is_L_o)    ,
                        .stop_o   (mem_stop_o)             ,
                        .sw_relate_i(em_sw_relate_o),
                        .wb_regs_wdata(mw_regs_wdata_o)
        );
        
        assign ram_req_o = mem_mem_req_o;
        assign ram_we_o=mem_mem_we_o;
        assign ram_rwaddr_o=mem_mem_rwaddr_o;
        assign ram_rwsel_o=mem_mem_rwsel_o;
        assign ram_wdata_o=mem_mem_wdata_o;
       
    
    
    //$$$$$$$$$$$$$$$（ MEM_WB访存&寄存器组写好暂存 模块）$$$$$$$$$$$$$$$$$$//  
         MEM_WB MEMWBI(
                        .rstL          ( rstL )   ,
                        .clk           ( clk )    ,
                        .pc_i          (mem_pc_o),
                        .inst_i        (mem_inst_o), 
                        .pc_o          (mw_pc_o),
                        .inst_o        (mw_inst_o), 
                    //输入
                        .mem_inst_is_L_i      (  mem_inst_is_L_o)     ,
                        //寄存器组
                            .regs_we_i        (mem_regs_we_o   )       ,
                            .regs_waddr_i     (mem_regs_waddr_o)       ,
                            .regs_wdata_i     (mem_regs_wdata_o)       ,
                            .stop_i           (ctrl_stop_o     )       ,
                     //输出
                           .mem_inst_is_L_o   ( mw_inst_is_L_o    ) ,
                        //寄存器组
                           .regs_we_o         ( mw_regs_we_o    )      ,
                           .regs_waddr_o      ( mw_regs_waddr_o )      ,
                           .regs_wdata_o      ( mw_regs_wdata_o  )   
         );

 assign   debug_wb_pc = mw_pc_o;
 assign   wb_stop_o=mw_inst_is_L_o ? 1'b1:1'b0;
 
  //#################（CTRL控制 模块）#################//  
   
    //code
      Ctrl CtrlI(
      .rst             ( rstL)               ,
      .clk             (clk     )            ,
      .stop_from_id_i  (id_stop_o)           ,
       
      .stop_from_exe_i  (ex_stop_o)           ,
      .stop_from_mem_i  (mem_stop_o)          ,    
      
//      .stop_from_wb_i (mem_inst_is_L_o),
//       .stop_from_id_i(1'b0),

      .stop_from_wb_i (1'b0),
      .stop_o(ctrl_stop_o)
     );
endmodule
