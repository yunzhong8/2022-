`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 00:36:39
// Design Name: 
// Module Name: Arith_Logic_Unit
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
//����:������־���caseĳ��������ɴ����Ӧ�����������д�����Σ�11��d:;11'd:;,������˾Ͱ���������ʽ���һ��
module Arith_Logic_Unit
(
    input  wire [31: 0] x       ,   // Դ������x, ��һ����rs��ֵ, ���һ��ȷ�� (�� sll, srl, sra)  
    input  wire [31: 0] y       ,   // Դ������y, ��һ����rt��ֵ, ���һ��ȷ�� (�� I��ָ��)
    input  wire [3 : 0] aluop   ,   // alu op
    output reg  [31: 0] r           // ������ result
    );
    
    always @(*)begin                // ��д��������� (�����Ż����Ӽ��Ƚ϶���ͨ���ӷ������)
//        r = 0;
        case(aluop)
            `SllAluOp: r = (y << x[4:0]);                     // 0sll, sllv
            `SrlAluOp: r = (y >> x[4:0]);                     // 1srl, srlv
            `SraAluOp: r = ($signed(y) >>> x[4:0]);           // 2sra, srav   
            // (verilog����Ĭ���޷�����, $signed()ǿ��ת��Ϊ�з�����, ">>>"�������������)
            
            `AddAluOp: r = x + y;                             // 3add
            `SubAluOp: r = x - y;                             // 4sub

            `AndAluOp: r =  (x & y);                          // 5and
            `OrAluOp : r =  (x | y);                          // 6or
            `XorAluOp: r =  (x ^ y);                          // 7xor
            `NorAluOp: r = ~(x | y);                          // 8nor

            `SltAluOp : r = ($signed(x) < $signed(y))? 1 : 0; //9slt
            `SltuAluOp: r = (x < y)? 1 : 0;                   //10sltu

            `LuiAluOp: r = {y[15:0], 16'h0000};               //11 lui
            `MulAluOp: r = x*y;  //mul
          
            default: r = 0;
        endcase
    end
endmodule


