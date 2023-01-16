`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/20 21:21:13
// Design Name: 
// Module Name: IF_ID
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
module IF_ID(
input wire rstL,
input wire clk,

input wire [`PCBus] pc_i,//�����ݴ��pc
input wire  [`InstBus]inst_i,//�����ݴ�pc��Ӧ��ָ��
input wire [`StopBus] stop_i,
output reg [`PCBus] pc_o,//����ݴ��pc
output reg [`InstBus]inst_o//���PC��Ӧ��ָ��
    );
 //*******************************************Define Inner Variable�������ڲ�������***********************************************//
	//XXXX ģ���������

 //*******************************************loginc Implementation�������߼�ʵ�֣�***********************************************//  
//����PCֵ
always@(posedge clk)
        if(rstL ==`RstEnable)begin
            pc_o<=`ZeroWord32B;
        end else if(stop_i[1]==`StopDisable) begin//û����ͣ
            pc_o<=pc_i;
        end else if(stop_i[1] == `StopEnable&& stop_i[2]==`StopDisable)begin//��ͣif�׶Σ�exeִ��0000_0000
            pc_o<=`ZeroWord32B;
        end else begin //��ͣif,��id�׶�Ҳ��ͣ
            pc_o<=pc_o;
        end         
//����ָ��
    always@(posedge clk)
        if(rstL ==`RstEnable)begin
            inst_o<=`ZeroWord32B;
        end else if(stop_i[1] == `StopEnable&& stop_i[2]==`StopDisable)begin
            inst_o<=`ZeroWord32B;
        end else if(stop_i[1]==`StopDisable) begin
            inst_o<=inst_i;
        end else begin
            inst_o<=inst_o;
        end
        
endmodule
