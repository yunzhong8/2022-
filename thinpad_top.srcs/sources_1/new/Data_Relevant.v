`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/23 12:59:31
// Design Name: 
// Module Name: Data_Relevant
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

module Data_Relevant(
input wire rstL,
//����
    //ִ�н׶μĴ�������Ϣ
        input wire                   ex_regs_we_i,
        input wire                   ex_memtoreg_i,
        input wire [`RegsAddrBus]    ex_regs_waddr_i,
    //�洢�׶μĴ�������Ϣ
        input wire                   mem_regs_we_i,
        input wire[`RegsAddrBus]     mem_regs_waddr_i,
    //�����Ĵ�����������ݺͶ���ַ
//        input wire                   regs_re1_i,
        input wire [`RegsAddrBus]    regs_rwaddr1_i,
        
//        input wire                   regs_re2_i,
        input wire [`RegsAddrBus]    regs_rwaddr2_i,
//���
    //1�Ŷ˿��������   
        output reg exe_relate1_o,                   //Ϊ1��ʾ�������     
        output reg mem_relate1_o,     
    //2�Ŷ˿��������
        output reg exe_relate2_o,                   //Ϊ1��ʾ�������
        output reg mem_relate2_o
    );
//���룺
//�����
//���ܣ�
//����reg������if��Ҫ����

//�Ĵ�����1�Ŷ˿��������    
always@(*)begin
    if(rstL ==`RstEnable)begin
            exe_relate1_o<=1'b0;
    end else begin
        if(ex_regs_waddr_i == regs_rwaddr1_i&&ex_regs_we_i==`WriteEnable) begin//���Ȳ鿴�Ƿ���ִ�н׶�ex�������
            exe_relate1_o<=1'b1;
        end else begin
            exe_relate1_o<=1'b0;
        end
    end
end
always@(*)begin
    if(rstL ==`RstEnable)begin
            mem_relate1_o<=1'b0;
    end else if(mem_regs_waddr_i == regs_rwaddr1_i && mem_regs_we_i==`WriteEnable)begin//��β鿴�Ǵ洢�׶�MEM�������
            mem_relate1_o<=1'b1;
    end else begin
            mem_relate1_o<=1'b0;
    end
end
                    
//�Ĵ�����2�Ŷ˿��������    
always@(*)begin
    if(rstL ==`RstEnable)begin
        exe_relate2_o<=1'b0;
    end else if(ex_regs_waddr_i == regs_rwaddr2_i&&ex_regs_we_i==`WriteEnable)begin//���Ȳ鿴�Ƿ���ִ�н׶�ex�������      
        exe_relate2_o<=1'b1;
    end else begin
        exe_relate2_o<=1'b0;
    end
end
always@(*)begin
    if(rstL ==`RstEnable)begin
        mem_relate2_o<=1'b0;
    end else if(mem_regs_waddr_i == regs_rwaddr2_i && mem_regs_we_i==`WriteEnable)begin//��β鿴�Ǵ洢�׶�MEM�������           
        mem_relate2_o<=1'b1;
    end else
        mem_relate2_o<=1'b0;
end
                     
endmodule
