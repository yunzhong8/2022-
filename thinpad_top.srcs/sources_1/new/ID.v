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
//����
    //ָ���PC
        input wire [`PCBus]           pc_i          ,
        input wire [`InstBus]         inst_i        ,
        output wire [`PCBus]           pc_o          ,
        output wire [`InstBus]         inst_o        ,
    //�Ĵ������������
        input wire [`RegsDataBus]     regs_rdata1_i,
        input wire [`RegsDataBus]     regs_rdata2_i,
    //ִ�н׶ο��ܵ��������
        input wire                    ex_regs_we_i,
        input wire [`RegsAddrBus]     ex_regs_waddr_i,
        input wire [`RegsDataBus]     ex_regs_wdata_i,
        input wire                    ex_memtoreg_i,
    //�洢�׶ο��ܵ��������
        input wire                    mem_regs_we_i,
        input wire[`RegsAddrBus]      mem_regs_waddr_i,
        input wire[`RegsDataBus]      mem_regs_wdata_i,
    //��ǰָ���ӳٲ��ź�
        input wire                    delayslot_i,//���뱾��ָ���Ƿ����ӳٲ�
    //ǰһ��ָ����loadָ��
        input wire                    pre_inst_is_li,
    
//���
    //output wire regs_re1_o,
        output reg [`RegsAddrBus]    regs_raddr1_o,//�Ĵ��������ַ1
    //output wire regs_re2_o,
        output reg [`RegsAddrBus]    regs_raddr2_o,//�Ĵ��������ַ2
    //������
        output wire [`AluOpBus]       alu_op_o,
        output wire [`AluOperBus]     alu_oper1_o,
        output wire[`AluOperBus]      alu_oper2_o,
     //�洢�����
        output wire                   mem_req_o,
        output wire                   mem_we_o,//�洢��дʹ���ź�
        output wire                   mem_rwbyte_o,//�洢����д�ֽ�,1��ʾ���ֽڣ�0��ʾ��˫��
        output wire  [31:0]           mem_wdata_o,
    
    //�Ĵ������
        output reg                    regs_we_o,//�Ĵ�����дʹ��
        output reg [`RegsAddrBus]     regs_waddr_o,//�Ĵ���д��ַ
        output wire                   memtoreg_o,//�Ĵ�����д��ֵ���Դ洢��
    
    
    
    
    //��ת�ź�
        output wire                   banch_flag_o,//��ת��־
        output reg [`PCBus]           banch_address_o,//��תת��ַ
    //��ת���ص�ַ
        output wire                   return_address_we_o,//��תָ��淵�ص�ַʹ��
        output wire [`RegsDataBus]    return_address_o,//��ת���ص�ַ
    //�ӳٲ��ź�
        output wire                   next_delayslot_o,//��һ��ָ�����ӳٲ۵ı�־
    //��ͣ
        output wire                   id_stop_o,
        output wire                   id_exe_relate_o,
    //sw��lw���
        output wire                   id_sw_relate_o
//    //�������ʾ����
//       output wire [`RegsDataBus]     led_data
    );
 //���룺
//�����
//���ܣ�
 //*******************************************Define Inner Variable�������ڲ�������***********************************************//
 parameter regs_re1=1'b1;
 parameter regs_re2=1'b1;
//ָ��ֽ� ģ���������
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

 //������չ��ģ���������
      wire se_sign_i;
      wire [`AluOperBus]se_data_o;
 //ָ������źŲ���ģ�鶨��
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
    
     //��֧
     wire spBeq;
     wire spBne;
     wire spBz;
     wire spBgtz;
     wire spBlez;
     //
     wire spBltz;
     wire spBgez;
    
     //��ת
     wire spJr;
     wire spJmp;
     wire spSysCall; 
 wire [`SignBus]sp_sign_o;
 
 //B��ָ��
     wire B;
     wire B_gt;
     wire B_equ;
     wire B_lt;
 
 //������ؼ��ģ���������
    wire exe_relate1_o;//�Ĵ�����1�ſ��Ƿ��������
    wire mem_relate1_o;//

    wire exe_relate2_o;//�Ĵ�����2�ſ��Ƿ��������
    wire mem_relate2_o;
//���������غ�Ĵ������������
    wire [`RegsDataBus]regs_rdata1;
    wire[`RegsDataBus]regs_rdata2;
 //*******************************************loginc Implementation�������߼�ʵ�֣�***********************************************//
  assign next_pc =pc_i+32'h4;
  //$$$$$$$$$$$$$$$�� ָ��ֽ�ģ�� ģ����ã�$$$$$$$$$$$$$$$$$$// 
	//ģ�����룺
	//ģ����ã�
	 assign {op,rs,rt,rd,shmat ,func}=inst_i;
     assign imm16=inst_i[15:0];
     assign sign_ext_imm16 = {{16{inst_i[15]}},inst_i[15:0]};
     assign zero_ext_imm16 = {16'h0000,inst_i[15:0]};
     assign imm26=inst_i[25:0];
     
	//ģ�����������ʾ��  

  //$$$$$$$$$$$$$$$�� ������ؼ�� ģ����ã�$$$$$$$$$$$$$$$$$$// 
	//ģ����ã�
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
	//ģ�����������ʾ��  

 	
 	
 	 
 
   //$$$$$$$$$$$$$$$�� �Ĵ���������������� ��$$$$$$$$$$$$$$$$$$// 
	//ģ�����룺
	//ģ����ã�
	assign regs_rdata1=exe_relate1_o?ex_regs_wdata_i:(mem_relate1_o?mem_regs_wdata_i:regs_rdata1_i);
    assign regs_rdata2=exe_relate2_o?ex_regs_wdata_i:(mem_relate2_o?mem_regs_wdata_i:regs_rdata2_i);
	//ģ�����������ʾ��  

 
 	

   //$$$$$$$$$$$$$$$�� ָ������źŲ��� ģ����ã�$$$$$$$$$$$$$$$$$$// 
        //ģ�����룺
        //ģ����ã�
             Signal_Produce sp(rstL,op,func,spAluOp,sp_sign_o);
             //��ȡEXE�׶��ź�
             assign  { spSignedExt,spAluSrcB,spAluSrcA }=sp_sign_o[2:0];
             //MEM
              assign {spMemRWByte,spMemWrite,spMemReq }=sp_sign_o[6:4];
              
            //WB
              assign {spMemToReg, spJal, spRegDst,spRegWirte}=sp_sign_o[11:8];
              assign spReturnAddrToReg=sp_sign_o[12];
    
    
           //��֧
             assign  {spBgtz,spBz,spBne,spBeq} =sp_sign_o[19:16];
             assign spBlez=sp_sign_o[20];
             assign spBltz=(spBz==1'b1)?((rt==5'h0)?1'b1:1'b0):1'b0;
             assign spBgez=(spBz==1'b1)?((rt==5'b0_0001)?1'b1:1'b0):1'b0;
    
         //��ת
           assign {spSysCall,spJmp,spJr}=sp_sign_o[26:24];
           
             
        //ģ�����������ʾ��
//           always@(*)
//                $display($time,,"spAluOp=%b,sp_sign_o=%h",spAluOp,sp_sign_o);
//           always@(*)
//                $display($time,,"spBz=%b,spMemRWByte=%b,spShmatReg=%b,spJal=%b,spJmp=%b,spJalr=%b,spJr=%b,spBne=%b,spBeq=%b, spBlez=%b,spBgtz=%b,spRegDst=%b,spSignedExt=%b,spSysCall=%b,spRegWirte=%b,spAluSrc=%b,spMemWrite=%b,spMemToReg=%b",spBz,spMemRWByte,
//                     spShmatReg,spJal,spJmp,spJalr,
//                     spJr,spBne,spBeq, spBlez,
//                     spBgtz,spRegDst,spSignedExt,spSysCall,
//                     regs_we_o,spAluSrc,mem_we_o,spMemToReg);  
 	
   //$$$$$$$$$$$$$$$�� B����תָ�� ģ�飩$$$$$$$$$$$$$$$$$$//     
        //�Ƚ�
        assign B_gt=(spBlez|spBgtz|spBz)?((regs_rdata1>`ZeroWord32B)?1'b1:1'b0):((regs_rdata1>regs_rdata2)?1'b1:1'b0);
        assign B_equ=(spBlez|spBgtz|spBz)?((regs_rdata1==`ZeroWord32B)?1'b1:1'b0):((regs_rdata1==regs_rdata2)?1'b1:1'b0);
        assign B_lt=(spBlez|spBgtz|spBz)?((regs_rdata1<`ZeroWord32B)?1'b1:1'b0):((regs_rdata1<regs_rdata2)?1'b1:1'b0);
        
        assign B=(spBeq&B_equ)|(spBne&~B_equ)|(spBltz&B_lt)|(spBgtz&B_gt)|(spBlez&(B_equ|B_lt))|(spBgez&(B_gt|B_equ));//�Ƿ����B��ָ����ת
 //*******************************************�������***********************************************//
     //################����Ĵ��������################//
     assign  pc_o    = pc_i      ;
     assign  inst_o  = inst_i     ;   
      //�Ĵ�������ַ1
             always@(*)begin
                 if(rstL==`RstEnable)begin
                    regs_raddr1_o<=5'd0;
                 end else if(spSysCall)begin
                        regs_raddr1_o<=5'd2;
                 end else begin
                        regs_raddr1_o<=rs;
                 end
              end
          //�Ĵ�������ַ2
             always@(*)begin
                 if(rstL==`RstEnable)begin
                    regs_raddr2_o<=5'd0;
                 end else if(spSysCall)begin
                    regs_raddr2_o<=5'd4;
                 end else begin
                         regs_raddr2_o<=rt; 
                 end
              end 
      //################�����ALU(EXE)���################//
          //ALU��������
             assign alu_op_o = spAluOp;
         //ALu_oper1������������1
             assign alu_oper1_o=spAluSrcA?{17'h0,shmat}:regs_rdata1;
            
        //ALu_oper2������������2
            assign alu_oper2_o=spAluSrcB?(spSignedExt?sign_ext_imm16:zero_ext_imm16):regs_rdata2;
    //################�����MEM���################//
      //�洢��ʹ��
        assign mem_req_o=spMemReq;
      //�洢����д�ֽ�
        assign mem_rwbyte_o=spMemRWByte;
      
      //�洢������д��Ĵ���ʹ��
        assign memtoreg_o=spMemToReg;
      
      //�洢��дʹ��+�ӳٲ�
         assign mem_we_o=spMemWrite&~delayslot_i;
         assign mem_wdata_o = regs_rdata2;
    //################����WB(regs_write)���################//         
      //�Ĵ�����дʹ��+�ӳٲ�
          always@(*)begin
                if(rstL==`RstEnable)begin
                    regs_we_o<=`WriteDisable;
                end else begin
                    regs_we_o<=spRegWirte&~delayslot_i;
                end
           end
     //�Ĵ�����д���ַ
         always@(*)begin
                if(rstL==`RstEnable)begin
                    regs_waddr_o<=`RegsAddrLen'd0;
                end else if(spRegDst)begin
                    regs_waddr_o<=rd;
                end else if(spJal)begin//��ת��ַ����ļĴ������ַ
                    regs_waddr_o<=`RegsAddrLen'd31;
                end else begin
                    regs_waddr_o<=rt;
                end
         end
    //################������ת���################//   
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
                
           assign banch_flag_o=(B|spJmp|spJr)&~delayslot_i;//��ת�ź�
           
     //################������ת���ص�ַ���################//   
         assign return_address_we_o=spReturnAddrToReg;//��ת�����ַʹ��
         assign return_address_o=pc_i+32'h8;//��ת���ص�ַ
        
    //################������ͣ��ˮ���################//     
//        assign id_stop_o= ((exe_relate1_o||exe_relate2_o)&&pre_inst_is_l) ?1'b1:1'b0;
          assign id_stop_o=spMemReq;
          assign id_exe_relate_o =exe_relate1_o||exe_relate2_o;//��exe�׶η���������أ���exe�׶���
     //################�����ӳٲ����################//  
//        assign next_delayslot_o=banch_flag_o;//��һ��ָ���Ƿ����ӳٲ�
     assign next_delayslot_o=1'b0;//�ر�ָʾ��һ�����ӳٲ�
     assign id_sw_relate_o = spMemWrite&&~exe_relate1_o&&exe_relate2_o;//ʱд��ָ�ͬʱд���exe�׶ε����н��������أ�������sw��exe�׶�memwdata��mem�׶ε�regwdata
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