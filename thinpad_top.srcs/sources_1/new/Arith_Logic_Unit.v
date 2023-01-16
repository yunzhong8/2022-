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
//错误:如果发现警告case某种情况不可达，那是应该这种情况你写了两次，11‘d:;11'd:;,报错如此就按照这样方式检查一下
module Arith_Logic_Unit
(
    input  wire [31: 0] x       ,   // 源操作数x, 不一定是rs的值, 需进一步确定 (如 sll, srl, sra)  
    input  wire [31: 0] y       ,   // 源操作数y, 不一定是rt的值, 需进一步确定 (如 I型指令)
    input  wire [3 : 0] aluop   ,   // alu op
    output reg  [31: 0] r           // 运算结果 result
    );
    
    always @(*)begin                // 本写法最简单明了 (还可优化，加减比较都可通过加法器解决)
//        r = 0;
        case(aluop)
            `SllAluOp: r = (y << x[4:0]);                     // 0sll, sllv
            `SrlAluOp: r = (y >> x[4:0]);                     // 1srl, srlv
            `SraAluOp: r = ($signed(y) >>> x[4:0]);           // 2sra, srav   
            // (verilog变量默认无符号数, $signed()强制转换为有符号数, ">>>"算术右移运算符)
            
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


