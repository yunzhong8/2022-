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
//����
    //ָ��洢����������
        input wire[`InstBus]      rom_inst_i            ,
    //���ݴ洢����������
        input wire [`RegsDataBus] ram_rdata_i           ,
        input wire [31:0]         serial_rdata_i        ,
//���
    //ָ��洢������ַ
        output wire[`PCBus]       rom_raddr_o           ,
    //���ݴ洢��
        output wire [`MemAddrBus]         ram_rwaddr_o  ,
        output wire               ram_we_o              ,
        output wire[3:0]          ram_rwsel_o           ,
        output wire[`RegsDataBus] ram_wdata_o           ,
        output wire               ram_req_o             ,
        output wire                write_wb_regs_data_o  ,//swд�����ݸ���ʹ��
        output wire [`RegsDataBus] wb_regs_data_o       ,//��ȷ��sw����
        
        output wire [31:0] debug_wb_pc                  ,
        output wire [3:0]  debug_wb_rf_wen              ,
        output wire [4:0]  debug_wb_rf_wnum             ,
        output wire [31:0] debug_wb_rf_wdata            
        
    //�������ʾ����
//        output [`RegsDataBus]      led_data
    );
//*******************************************Define Inner Variable�������ڲ�������***********************************************//
//�������� �ĸ��׶β�����_���������ĸ��׶�ʹ�õġ����ԡ�����������ߵ͵�ƽ��Ч
    
     //ID ģ��������� id
         wire [`PCBus]    id_pc_o;
         wire [`InstBus]  id_inst_o;
         //�Ĵ������
            wire id_regs_re1_o;
            wire [`RegsAddrBus]id_regs_raddr1_o;
            
            wire id_regs_re2_o;
            wire [`RegsAddrBus]id_regs_raddr2_o;
        //������
            wire [`AluOpBus]id_alu_op_o;
            wire [`AluOperBus]id_alu_oper1_o;
            wire [`AluOperBus] id_alu_oper2_o;
            wire[`AluShmatBus]id_alu_shmat_o;
         
         //�洢��
            wire id_mem_req_o;
            wire id_mem_we_o;//�洢��дʹ���ź�
            wire id_mem_rwbyte_o;//�洢����д�ֽ�
            wire [31:0]id_mem_wdata_o;
         //�Ĵ�����д
            wire id_regs_we_o;
            wire[`RegsAddrBus] id_regs_waddr_o;
            wire id_memtoreg_o;
        //��ת�ź�
            wire id_banch_flag_o;
            wire[`PCBus] id_banch_address_o;
            wire id_return_address_we_o;
            wire [`RegsDataBus]id_return_address_o;
        //�ӳٲ��ź�
            wire id_next_delayslot_o;
            
     //�Ĵ�����ģ���������
        //�Ĵ������
            wire rf_re1_i;
            wire [`RegsDataBus]rf_rdata1_o;
            wire rf_re2_i;
            wire [`RegsDataBus]rf_rdata2_o;
        //�Ĵ�����д
            wire rf_we_i;
            wire[`RegsAddrBus] rf_waddr_i;
            wire[`RegsDataBus]rf_wdata_i;
         //��ͣ
           wire id_stop_o;
    
     //ID_EXģ���������
         wire [`PCBus]    idex_pc_o;
         wire [`InstBus]  idex_inst_o;
         //������
            wire[`AluOpBus]idex_alu_op_o;
            wire[`AluOperBus]idex_alu_oper1_o;
            wire[`AluOperBus]idex_alu_oper2_o;
            wire[`AluShmatBus]idex_alu_shmat_o;
        //�洢��
            wire idex_mem_we_o;
            wire idex_mem_rwbyte_o;
            wire idex_mem_req_o;
            wire [31:0]idex_mem_wdata_o;
         //�Ĵ�����д
            wire[`RegsAddrBus]idex_regs_waddr_o;
            wire idex_regs_we_o;
            wire idex_memtoreg_o;
        //��תд��
            wire idex_return_address_we_o;
            wire [`RegsDataBus]idex_return_address_o;
        //�ӳٲ�
            wire idex_next_delayslot_o;
    
     //EX exģ�鶨��
         wire [`PCBus]    ex_pc_o;
         wire [`InstBus]  ex_inst_o;
        //������
           wire[`AluOperBus] ex_alu_result_o;
        //�洢��
            wire ex_mem_we_o;
            wire ex_mem_rwbyte_o;
            wire [`MemDataBus]ex_mem_wdata_o;
             wire ex_mem_req_o;
        //�Ĵ�����
           wire[`RegsAddrBus] ex_regs_waddr_o;
           wire ex_regs_we_o;
           wire ex_memtoreg_o;
        //
           wire ex_is_L_inst_o;
     
     //EX_MEM em
         wire [`PCBus]    em_pc_o;
         wire [`InstBus]  em_inst_o;
        //������
            wire [`AluOperBus]em_alu_result_o;
        //�Ĵ�����
            wire em_regs_we_o;
            wire [`RegsAddrBus]em_regs_waddr_o;
            wire em_memtoreg_o;
        //�洢��
            wire em_mem_we_o;
            wire [`MemDataBus]em_mem_wdata_o;
            wire em_mem_rwbyte_o;
            wire em_mem_req_o;
            
     //MEM 
         wire [`PCBus]    mem_pc_o;
         wire [`InstBus]  mem_inst_o;
         //�Ĵ�����
           wire mem_regs_we_o;
           wire [`RegsAddrBus]mem_regs_waddr_o;
           wire [`RegsDataBus]mem_regs_wdata_o;
        //�洢��
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
//*******************************************loginc Implementation�������߼�ʵ�֣�***********************************************//
    
    //$$$$$$$$$$$$$$$�� IFȡָ ģ�飩$$$$$$$$$$$$$$$$$$// 
     //IF ģ��������� 
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
    
    
        
    //$$$$$$$$$$$$$$$��IFIDȡָ�����ݴ�  ģ�飩$$$$$$$$$$$$$$$$$$// 
     //IF_ID ģ��������� ifid
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
   
    
   
    
    
    //$$$$$$$$$$$$$$$�� ID���� ģ�飩$$$$$$$$$$$$$$$$$$// 
    wire id_exe_relate_o;
     wire id_sw_relate_o ;
         ID IDI(
                .rstL          (rstL),
                .clk           (clk),
                //����
                    .pc_i          (ifid_pc_o),
                    .inst_i        (ifid_inst_o), 
                    .pc_o          (id_pc_o),
                    .inst_o        (id_inst_o), 
                    //����Ĵ������������
                        .regs_rdata1_i          (rf_rdata1_o),
                        .regs_rdata2_i          (rf_rdata2_o),
                    //ִ�н׶ο��ܵ��������
                        .ex_regs_we_i           (ex_regs_we_o),
                        .ex_regs_waddr_i        (ex_regs_waddr_o),
                        .ex_regs_wdata_i        (ex_alu_result_o),
                        .ex_memtoreg_i          (ex_memtoreg_o),
                    //�洢�׶ο��ܵ��������
                        .mem_regs_we_i         (mem_regs_we_o),
                        .mem_regs_waddr_i      (mem_regs_waddr_o),
                        .mem_regs_wdata_i      (mem_regs_wdata_o),
                    //�ӳٲ��ź�
                        .delayslot_i           (idex_next_delayslot_o),
                    //ǰһ��ָ����Lָ��
                        .pre_inst_is_li         (ex_is_L_inst_o)    ,
                //���
                     //�Ĵ������ź�
                        .regs_raddr1_o         (id_regs_raddr1_o),
                        .regs_raddr2_o         (id_regs_raddr2_o),
                    //���������
                        .alu_op_o              (id_alu_op_o),
                        .alu_oper1_o           (id_alu_oper1_o),
                        .alu_oper2_o           (id_alu_oper2_o),
                      //�洢�����
                        .mem_req_o            (id_mem_req_o),
                        .mem_we_o             (id_mem_we_o),
                        .mem_rwbyte_o         (id_mem_rwbyte_o),
                        .mem_wdata_o          (id_mem_wdata_o),
                        
                    //����Ĵ�����
                        .regs_we_o            (id_regs_we_o),
                        .regs_waddr_o         (id_regs_waddr_o),
                        .memtoreg_o           (id_memtoreg_o),

                    //��ת�޸�PC
                        .banch_flag_o        (id_banch_flag_o),
                        .banch_address_o     (id_banch_address_o),
                    //��ת���ص�ַ
                        .return_address_we_o (id_return_address_we_o),
                        .return_address_o    (id_return_address_o),
                    //�ӳٲ��ź�
                        .next_delayslot_o   (id_next_delayslot_o),
                    //��ˮ��ָͣ��
                        .id_stop_o          (id_stop_o)        ,
                        .id_exe_relate_o    (id_exe_relate_o)   ,//id�׶�ָ����exe�׶�ָ���������
                      //sw��д���������
                        .id_sw_relate_o     (id_sw_relate_o)  //id�׶�sw��д�����ݺ�exe���
                    //�������ʾ����
//                        .led_data           (led_data)
                   
                );
        //��ʾ����
//          Instruct_Display_id IDI_id(  ifid_inst_o,ifid_pc_o);//����׶�ָ��
        //#################��ID���� ģ�������#################// 
    
    
    
    
    //$$$$$$$$$$$$$$$�� �Ĵ����� ģ�飩$$$$$$$$$$$$$$$$$$// 
         Reg_File RFI(
                   .rf_in_rstL   ( rstL )        ,
                   .rf_in_clk    ( clk )         ,
                   
                     //����
                         //����Ĵ�������
                       .rf_in_re1           (   1'b1              )      ,
                       .rf_in_raddr1        (   id_regs_raddr1_o  )      ,
                       .rf_in_re2           (   1'b1              )      ,
                       .rf_in_raddr2        (   id_regs_raddr2_o  )      , 
                       //д����
                        .rf_in_we           (   mw_regs_we_o      )      ,
                        .rf_in_waddr        (   mw_regs_waddr_o   )      ,
                        .rf_in_wdata        (   mw_regs_wdata_o   )      ,
                         
                     //����Ĵ������
                       .rf_out_rdata1       (  rf_rdata1_o    )          ,
                       .rf_out_rdata2       (  rf_rdata2_o    )          
                     ); 
                     
                     
      //debug
       assign debug_wb_rf_wen   =  {4{mw_regs_we_o}} ;
       assign debug_wb_rf_wnum  =  mw_regs_waddr_o   ;
       assign debug_wb_rf_wdata =  mw_regs_wdata_o   ;
    //#################���Ĵ�����  ģ�������#################//  
    
    
     
     
    //$$$$$$$$$$$$$$$�� IDEX����ִ���ݴ� ģ�飩$$$$$$$$$$$$$$$$$$//  
     wire idex_sw_relate_o;
             ID_EX IDEXI(
                        .rstL            ( rstL )     ,
                        .clk             ( clk  )     ,
                        .pc_i          (id_pc_o),
                        .inst_i        (id_inst_o), 
                        .pc_o          (idex_pc_o),
                        .inst_o        (idex_inst_o), 
                         //����
                            //������
                               .alu_op_i      ( id_alu_op_o       )        ,
                               .alu_oper1_i   ( id_alu_oper1_o    )        ,
                               .alu_oper2_i   ( id_alu_oper2_o    )        ,
                            //�洢��
                                .mem_req_i     ( id_mem_req_o         )     ,                     
                                .mem_we_i      ( id_mem_we_o          )     ,                     
                                .mem_rwbyte_i  ( id_mem_rwbyte_o      )     ,                     
                                .mem_wdata_i   ( id_mem_wdata_o       )     ,                     
                            //�Ĵ�����
                               .regs_we_i      ( id_regs_we_o        )     ,
                               .regs_waddr_i   ( id_regs_waddr_o     )     ,
                               .memtoreg_i     ( id_memtoreg_o       )     ,
                            
                            //��תд��
                               .return_address_we_i  ( id_return_address_we_o    )         ,
                               .return_address_i     ( id_return_address_o       )         ,
                            
                            //�ӳٲ�
                               .next_delaysolt_i    (  id_next_delayslot_o  )              ,
                               .stop_i               ( ctrl_stop_o)                        ,
            
                        //���
                            //������
                            .alu_op_o               ( idex_alu_op_o       )          ,
                            .alu_oper1_o            ( idex_alu_oper1_o    )          ,
                            .alu_oper2_o            ( idex_alu_oper2_o    )          ,
                            //�洢��                                                   
                            .mem_req_o              ( idex_mem_req_o      )          ,
                            .mem_we_o               ( idex_mem_we_o       )          ,
                            .mem_rwbyte_o           ( idex_mem_rwbyte_o   )          ,
                            .mem_wdata_o            ( idex_mem_wdata_o    )          ,
                            //�Ĵ���                                                        
                            .regs_we_o              ( idex_regs_we_o        )        ,
                            .regs_waddr_o           ( idex_regs_waddr_o     )        ,
                            .memtoreg_o             ( idex_memtoreg_o       )        ,
                           //��תд��                                                    
                            .return_address_we_o    ( idex_return_address_we_o )     ,
                            .return_address_o       ( idex_return_address_o    )     ,
                              //swд���
                               .sw_relate_i         (id_sw_relate_o),//��ǰָ������ǰһ��ָ���д��Ĵ�������������
                            //SW���
                            .sw_relate_o            (idex_sw_relate_o),
                           //�ӳٲ�
                            .next_delaysolt_o       ( idex_next_delayslot_o )     
                        );
    
    //$$$$$$$$$$$$$$$�� EXִ�� ģ�飩$$$$$$$$$$$$$$$$$$//  
    wire [31:0]ex_mem_rwaddr_o;
     wire ex_sw_relate_o;
    wire ex_stop_o;
         EX EXI(
//                 .rstL                   (rstL)                      ,
                  .pc_i          (idex_pc_o),
                  .inst_i        (idex_inst_o), 
                  .pc_o          (ex_pc_o),
                  .inst_o        (ex_inst_o), 
                 //����
                     //������
                       .alu_op_i         (idex_alu_op_o      )       ,
                       .alu_oper1_i      (idex_alu_oper1_o   )       ,
                       .alu_oper2_i      (idex_alu_oper2_o   )       ,
                     //�洢��
                       .mem_req_i         (  idex_mem_req_o     )      ,
                       .mem_we_i          (  idex_mem_we_o      )      ,
                       .mem_rwbyte_i      (  idex_mem_rwbyte_o  )      ,
                       .mem_wdata_i       (  idex_mem_wdata_o   )      ,
                    //�Ĵ�����
                      .regs_we_i          ( idex_regs_we_o     )       ,
                      .regs_waddr_i       ( idex_regs_waddr_o  )       ,
                      .memtoreg_i         ( idex_memtoreg_o    )       ,
                    
                    //��תд��
                       .return_address_we_i  ( idex_return_address_we_o  )   ,
                       .return_address_i     ( idex_return_address_o     )   ,
                    //
                       .pre_inst_exe_realte_i      (id_exe_relate_o       )               ,
                //���
                    //������
                        .alu_result_o       (ex_alu_result_o)                ,
                    //�洢��
                       . mem_req_o         ( ex_mem_req_o        )    ,
                       . mem_we_o          ( ex_mem_we_o         )    ,
                       . mem_rwbyte_o      ( ex_mem_rwbyte_o     )    ,
                       .mem_rwaddr_o       ( ex_mem_rwaddr_o     )    ,
                       . mem_wdata_o       ( ex_mem_wdata_o      )    ,
                    //�Ĵ�����
                      .regs_we_o           (  ex_regs_we_o     )       ,
                      .regs_waddr_o        (  ex_regs_waddr_o  )       ,
                      .memtoreg_o          (  ex_memtoreg_o    )       ,
                   //��ǰָ���ǲ���L
                      .is_L_inst_o         (  ex_is_L_inst_o  )       ,
                  //��ͣ��ˮ
                      .stop_o              (ex_stop_o)         ,
                       .id_sw_relate_i          (id_sw_relate_o),//��ǰexe�׶�ָ���sw��д���������
                        .sw_relate_i       (idex_sw_relate_o)           ,//��ǰָ������ǰһ��ָ���д��Ĵ�������������
                        .sw_relate_o        (ex_sw_relate_o)            ,
                        .mem_regs_rdata     (mem_regs_wdata_o)          
                     
                       
         );
   
     
    //$$$$$$$$$$$$$$$�� EXMEMִ�зô��ݴ� ģ�飩$$$$$$$$$$$$$$$$$$//  
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
                        //����
                            //������
                                 .alu_result_i      (ex_alu_result_o)    ,
                            //�洢��
                                 .mem_req_i         ( ex_mem_req_o    )  ,
                                 .mem_we_i          ( ex_mem_we_o     )  ,
                                 .mem_rwbyte_i      ( ex_mem_rwbyte_o )  ,
                                 .mem_rwaddr_i      ( ex_mem_rwaddr_o )  ,
                                 .mem_wdata_i       ( ex_mem_wdata_o  )  ,
                                 
                            //�Ĵ�����
                                .regs_we_i          (ex_regs_we_o)       ,
                                .regs_waddr_i       (ex_regs_waddr_o)    ,
                                .memtoreg_i         (ex_memtoreg_o)      ,
                                .stop_i              (ctrl_stop_o)       ,
                               
                            
                                
                        //���
                            //������
                                 .alu_result_o       (em_alu_result_o)   ,
                            //�洢��
                                 .mem_req_o          ( em_mem_req_o    ) ,
                                 .mem_we_o           ( em_mem_we_o     ) ,
                                 .mem_rwbyte_o       ( em_mem_rwbyte_o ) ,
                                 .mem_rwaddr_o       ( em_mem_rwaddr_o )  ,
                                 .mem_wdata_o        ( em_mem_wdata_o  ) ,
                                 
                            //�Ĵ�����
                                 .regs_we_o          ( em_regs_we_o    ),
                                 .regs_waddr_o       ( em_regs_waddr_o ),
                                 .memtoreg_o         ( em_memtoreg_o   ),
                                 .sw_relate_i       (ex_sw_relate_o)     ,
                                 .sw_relate_o       (em_sw_relate_o) ,   
                                 
                                 .id_sw_relate_i      (id_sw_relate_o) ,//exeִ��ָ������һ��ָ���swload���   
                                 .id_sw_relate_o      (em_id_sw_relate_o) ,   
//                                 .                      
                                 .sw_relate_data_we   (em_id_sw_relate_o),   //mem�׶�ָ������һ��ָ��sw���ͣ�swд���������
                                 .sw_relate_data_i    (mem_regs_wdata_o), //   mem�׶εļĴ�����д�����ݱ���
                                 .sw_relate_data_o    (em_sw_relate_data_o)//����ϸ��׶μĴ�����д������
                                                                  
                                 
                                  
                            
                                
         );
         assign write_wb_regs_data_o= em_sw_relate_o;//sw�׶�д�����ݲ���mem��������
         assign  wb_regs_data_o= em_sw_relate_data_o;//��ȷ��swд������
   
    //$$$$$$$$$$$$$$$�� MEM�ô� ģ�飩$$$$$$$$$$$$$$$$$$//  
    wire mem_stop_o;
         MEM MEMI(
                 .rstL(rstL),
                  .pc_i          (em_pc_o),
                  .inst_i        (em_inst_o), 
                  .pc_o          (mem_pc_o),
                  .inst_o        (mem_inst_o), 
                //����
                    //������
                        .alu_result_i(em_alu_result_o),
                        .serial_rdata_i(serial_rdata_i),
                    //�洢��
                        .mem_req_i(em_mem_req_o),
                        .mem_we_i(em_mem_we_o),
                        .mem_rwbyte_i(em_mem_rwbyte_o),
                        .mem_rwaddr_i (em_mem_rwaddr_o),
                        .mem_wdata_i(em_mem_wdata_o),
                        .mem_rdata_i(ram_rdata_i),
                    //�Ĵ�����
                        .regs_waddr_i(em_regs_waddr_o),
                        .regs_we_i(em_regs_we_o),
                        .memtoreg_i(em_memtoreg_o),
                   //exe�׶��ǲ���Lָ��
                        .exe_is_L_inst_o(ex_is_L_inst_o),
                    
                //���
                    //�洢��
                       .mem_req_o    (mem_mem_req_o),
                       .mem_we_o     (mem_mem_we_o)     ,
                       .mem_rwaddr_o  (mem_mem_rwaddr_o)  ,
                       .mem_rwsel_o  (mem_mem_rwsel_o)  ,
                       .mem_wdata_o  (mem_mem_wdata_o)  ,
                      
                    //�Ĵ�����                            
                        .regs_we_o    (mem_regs_we_o)      ,
                        .regs_waddr_o (mem_regs_waddr_o)   ,
                        .regs_wdata_o (mem_regs_wdata_o)   ,
                    //��ǰָ����sw
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
       
    
    
    //$$$$$$$$$$$$$$$�� MEM_WB�ô�&�Ĵ�����д���ݴ� ģ�飩$$$$$$$$$$$$$$$$$$//  
         MEM_WB MEMWBI(
                        .rstL          ( rstL )   ,
                        .clk           ( clk )    ,
                        .pc_i          (mem_pc_o),
                        .inst_i        (mem_inst_o), 
                        .pc_o          (mw_pc_o),
                        .inst_o        (mw_inst_o), 
                    //����
                        .mem_inst_is_L_i      (  mem_inst_is_L_o)     ,
                        //�Ĵ�����
                            .regs_we_i        (mem_regs_we_o   )       ,
                            .regs_waddr_i     (mem_regs_waddr_o)       ,
                            .regs_wdata_i     (mem_regs_wdata_o)       ,
                            .stop_i           (ctrl_stop_o     )       ,
                     //���
                           .mem_inst_is_L_o   ( mw_inst_is_L_o    ) ,
                        //�Ĵ�����
                           .regs_we_o         ( mw_regs_we_o    )      ,
                           .regs_waddr_o      ( mw_regs_waddr_o )      ,
                           .regs_wdata_o      ( mw_regs_wdata_o  )   
         );

 assign   debug_wb_pc = mw_pc_o;
 assign   wb_stop_o=mw_inst_is_L_o ? 1'b1:1'b0;
 
  //#################��CTRL���� ģ�飩#################//  
   
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
