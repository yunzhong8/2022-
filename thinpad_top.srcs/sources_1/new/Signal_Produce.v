`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/23 12:58:21
// Design Name: 
// Module Name: Signal_Produce
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
module Signal_Produce(
input wire rstL,
//输入
    //OP&func
        input wire [`InstOpBus]op_i,
        input wire [`InstFuncBus]func_i,
//输出
    //运算类型
        output reg [`AluOpBus]aluop_o,
    //信号
        output reg[`SignBus]sign_o
   
    );
    
 //产生指令信号 
  always @(*)
      if(rstL==`RstEnable)//复位
          begin
             aluop_o<=`AluOpLen'd0;
             sign_o<=`SignLen'd0;
          end
      else
          begin
              case(op_i)
                    `RInstOp://R型指令
                              case(func_i)
                                  //逻辑操作 
                                  `AndInstFunc: begin//与指令
                                                    aluop_o<=`AndAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                  
                                  `OrInstFunc: begin//或指令
                                                     aluop_o<=`OrAluOp;
                                                    sign_o<=`RInstSign;
                                               end
                                  
                                  `XorInstFunc: begin//或非指令
                                                   aluop_o<=`XorAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                  //简单算术运算
                                  `AddInstFunc:begin//或非指令
                                                    aluop_o<=`AddAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                   `AdduInstFunc:begin//或非指令
                                                    aluop_o<=`AdduAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                   `SubInstFunc:begin//或非指令
                                                    aluop_o<=`SubAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                    `SltInstFunc:begin//或非指令
                                                    aluop_o<=`SltAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                  
                                  //移位操作 
                                  `SllInstFunc:
                                               begin
                                                    aluop_o<=`SllAluOp;
                                                    sign_o<=`RSInstSign;
                                                end
                                  `SrlInstFunc:
                                               begin
                                                    aluop_o<=`SrlAluOp;
                                                    sign_o<=`RSInstSign;
                                                end
                                  `SraInstFunc:
                                               begin
                                                    aluop_o<=`SraAluOp;
                                                    sign_o<=`RSInstSign;
                                                end
                                          
                                  `SllvInstFunc:
                                               begin
                                                    aluop_o<=`SllAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                  `SrlvInstFunc:
                                               begin
                                                   aluop_o<=`SrlAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                  `SravInstFunc:
                                               begin
                                                    aluop_o<=`SraAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                   //移位指令
                                    `JrInstFunc:
                                               begin
                                                    aluop_o<=`NoAluOp;
                                                    sign_o<=`JrInstSign;
                                                end
                                     `JalrInstFunc:
                                               begin
                                                    aluop_o<=`NoAluOp;
                                                    sign_o<=`JalrInstSign;
                                                end
                                  //SysCall
                                      `SysCallInstFunc:
                                               begin
                                                    aluop_o<=`NoAluOp;
                                                    sign_o<=`SysCallInstSign;
                                                end
                                         default: begin
                                                  aluop_o<=`NoAluOp;
                                                  sign_o<=`SignLen 'h000_0000;
                                                end  
                              endcase
                      //逻辑操作 
                     `AndiInstOp: begin
                                       aluop_o<=`AndAluOp;
                                       sign_o<=`IZInstSign;
                                    end
                     `OriInstOp: begin
                                        aluop_o<=`OrAluOp;
                                        sign_o<=`IZInstSign;
                                    end
                     `XoriInstOp: begin
                                      aluop_o<=`XorAluOp;
                                      sign_o<=`IZInstSign;
                                    end
                      `LuiInstOp: begin
                                      aluop_o<=`LuiAluOp;
                                      sign_o<=`IZInstSign;
                                    end
                      //简单算术指令
                      `AddiInstOp: begin
                                      aluop_o<=`AddAluOp;
                                      sign_o<=`ISInstSign;
                                    end
                      `AddiuInstOp: begin
                                      aluop_o<=`AdduAluOp;
                                      sign_o<=`ISInstSign;
                                    end
                        //复杂指令
                       `MulInstOp: begin
                                      aluop_o<=`MulAluOp;
                                      sign_o<=`MulInstSign;
                                    end
                        //跳转指令 J
                       `JInstOp: begin
                                      aluop_o<=`NoAluOp;
                                      sign_o<=`JInstSign;
                                    end
                        `JalInstOp: begin
                                      aluop_o<=`NoAluOp;
                                      sign_o<=`JalInstSign;
                                    end
                          //分支指令
                        `BeqInstOp: begin
                                      aluop_o<=`NoAluOp;
                                      sign_o<=`BeqInstSign;
                                    end
                         `BneInstOp: begin
                                      aluop_o<=`NoAluOp;
                                      sign_o<=`BneInstSign;
                                    end
                         `BgtzInstOp: begin
                                      aluop_o<=`NoAluOp;
                                      sign_o<=`BgtzInstSign;
                                    end
                          `BlezInstOp: begin
                                      aluop_o<=`NoAluOp;
                                      sign_o<=`BlezInstSign;
                                    end
                             //同操作码BZ类的分支命令
                          `BzInstOp: begin
                                      aluop_o<=`NoAluOp;
                                      sign_o<=`BzInstSign;
                                    end
                            //加载指令
                           `LbInstOp: begin
                                      aluop_o<=`AddAluOp;
                                      sign_o<=`LbInstSign;
                                    end
                           `LwInstOp: begin
                                      aluop_o<=`AddAluOp;
                                      sign_o<=`LwInstSign;
                                    end
                           //存储指令
                           `SbInstOp: begin
                                      aluop_o<=`AddAluOp;
                                      sign_o<=`SbInstSign;
                                    end
                          `SwInstOp: begin
                                      aluop_o<=`AddAluOp;
                                      sign_o<=`SwInstSign;                                    
                                    end 
                           default: begin
                                      aluop_o<=`NoAluOp;
                                      sign_o<=`SignLen 'h000_0000;
                                    end
                              
              endcase
          end
endmodule
