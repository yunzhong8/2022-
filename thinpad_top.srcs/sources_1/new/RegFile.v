`timescale 1ns / 1ps
`include"MIPSdefines.v"

module Reg_File(
input wire                           rf_in_rstL,
input wire                           rf_in_clk,
//����
    //���˿�1 
        input wire                    rf_in_re1           , //1�Ŷ˿ڶ�ʹ���ź� 
        input wire [`RegsAddrBus]     rf_in_raddr1        ,// 1�Ŷ˿ڶ���ַ 
    //���˿�2
        input wire                    rf_in_re2           , //2�Ŷ˿ڶ�ʹ���ź� 
        input wire [`RegsAddrBus]     rf_in_raddr2        ,// 2�Ŷ˿ڶ���ַ 
    //д�˿� 
        input wire                    rf_in_we            ,//дʹ���ź�
        input wire [`RegsAddrBus]     rf_in_waddr         , //д��ַ
        input wire [`RegsDataBus]     rf_in_wdata         ,//д����
    
//���
    output reg [`RegsDataBus]         rf_out_rdata1       , // 1�Ŷ˿ڶ����� 
    output reg [`RegsDataBus]         rf_out_rdata2         // 2�Ŷ˿ڶ����� 
    );
 //���ܣ��Ĵ����飬����ʵ�������˿�ͬʱ����һ���˿�д����д����ͬʱ���У������Ǵ�д�������
 //*******************************************Define Inner Variable�������ڲ�������***********************************************//
	//�洢�����������
	reg[`RegsDataBus]Regs[0:`RegsNum-1];
	integer i;
//    initial begin
//        for(i=0;i<32;i=i+1) Regs[i] = 0;   // ����ʹ�ã���Ϊ������δ��ʼ����reg��ֵΪX (��ʵ���ۺ�)
//    end
	
 //*******************************************loginc Implementation�������߼�ʵ�֣�***********************************************//
 
 //$$$$$$$$$$$$$$$��д����ģ�飩$$$$$$$$$$$$$$$$$$// 
 always @(posedge rf_in_clk) begin
        if(rf_in_rstL==`RstEnable)begin
            for(i=0;i<32;i=i+1) Regs[i] = 32'h0000_0000;
        end else begin//ϵͳ����ִ��
                if( ( rf_in_we == `WriteEnable )&& ( rf_in_waddr !=`RegsAddrLen'h0) )begin//���д���ź���Ч��д��Ĳ���$0�Ĵ���
                           Regs[rf_in_waddr] <= rf_in_wdata;
//                           $display($time,," Regs[%d]=%h", rf_in_waddr,Regs[rf_in_waddr]);
                end else begin
                     for(i=0;i<32;i=i+1) Regs[i] = Regs[i];
                end  
         end
         
    end
 //#################�� ģ�������#################//  	
 
 
 //$$$$$$$$$$$$$$$��1�Ŷ˿ڶ�����ģ�飩$$0$$$$$$$$$$$$$$$$// 
 always @(*)begin
        if(rf_in_rstL == `RstEnable)begin//��λ
            rf_out_rdata1<=`ZeroWord32B;
        end else if(rf_in_raddr1==`RegsAddrLen'h0) begin//����������$0�Ĵ���
            rf_out_rdata1<=`ZeroWord32B;       
        end else  if( (rf_in_raddr1==rf_in_waddr)&&(rf_in_we == `WriteEnable)&&(rf_in_re1 ==`ReadEnable) )begin //���д��Ч������Ч������������Ǵ�д��ڵ�����
            rf_out_rdata1<=rf_in_wdata;
        end else begin //��
            rf_out_rdata1<=Regs[rf_in_raddr1];
        end                 
 end
  
//#################�� ģ�������#################//  




//$$$$$$$$$$$$$$$��2�Ŷ˿ڶ�����ģ�飩$$0$$$$$$$$$$$$$$$$// 
 always @(*)begin
        if( rf_in_rstL == `RstEnable )begin//��λ
             rf_out_rdata2<=`ZeroWord32B; 
       end else  if(rf_in_raddr2==`RegsAddrLen'h0)begin//����������$0�Ĵ���
             rf_out_rdata2<=`ZeroWord32B;
       end else  if( (rf_in_raddr2==rf_in_waddr)&&(rf_in_we == `WriteEnable)&&(rf_in_re2 ==`ReadEnable) )begin//���д��Ч������Ч������������Ǵ�д��ڵ�����
             rf_out_rdata2<=rf_in_wdata;
       end else begin //��
             rf_out_rdata2<=Regs[rf_in_raddr2];
       end
 end
  
//#################�� ģ�������#################//  
 
endmodule
