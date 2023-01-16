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
//����
    //OP&func
        input wire [`InstOpBus]op_i,
        input wire [`InstFuncBus]func_i,
//���
    //��������
        output reg [`AluOpBus]aluop_o,
    //�ź�
        output reg[`SignBus]sign_o
   
    );
    
 //����ָ���ź� 
  always @(*)
      if(rstL==`RstEnable)//��λ
          begin
             aluop_o<=`AluOpLen'd0;
             sign_o<=`SignLen'd0;
          end
      else
          begin
              case(op_i)
                    `RInstOp://R��ָ��
                              case(func_i)
                                  //�߼����� 
                                  `AndInstFunc: begin//��ָ��
                                                    aluop_o<=`AndAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                  
                                  `OrInstFunc: begin//��ָ��
                                                     aluop_o<=`OrAluOp;
                                                    sign_o<=`RInstSign;
                                               end
                                  
                                  `XorInstFunc: begin//���ָ��
                                                   aluop_o<=`XorAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                  //����������
                                  `AddInstFunc:begin//���ָ��
                                                    aluop_o<=`AddAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                   `AdduInstFunc:begin//���ָ��
                                                    aluop_o<=`AdduAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                   `SubInstFunc:begin//���ָ��
                                                    aluop_o<=`SubAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                    `SltInstFunc:begin//���ָ��
                                                    aluop_o<=`SltAluOp;
                                                    sign_o<=`RInstSign;
                                                end
                                  
                                  //��λ���� 
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
                                   //��λָ��
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
                      //�߼����� 
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
                      //������ָ��
                      `AddiInstOp: begin
                                      aluop_o<=`AddAluOp;
                                      sign_o<=`ISInstSign;
                                    end
                      `AddiuInstOp: begin
                                      aluop_o<=`AdduAluOp;
                                      sign_o<=`ISInstSign;
                                    end
                        //����ָ��
                       `MulInstOp: begin
                                      aluop_o<=`MulAluOp;
                                      sign_o<=`MulInstSign;
                                    end
                        //��תָ�� J
                       `JInstOp: begin
                                      aluop_o<=`NoAluOp;
                                      sign_o<=`JInstSign;
                                    end
                        `JalInstOp: begin
                                      aluop_o<=`NoAluOp;
                                      sign_o<=`JalInstSign;
                                    end
                          //��ָ֧��
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
                             //ͬ������BZ��ķ�֧����
                          `BzInstOp: begin
                                      aluop_o<=`NoAluOp;
                                      sign_o<=`BzInstSign;
                                    end
                            //����ָ��
                           `LbInstOp: begin
                                      aluop_o<=`AddAluOp;
                                      sign_o<=`LbInstSign;
                                    end
                           `LwInstOp: begin
                                      aluop_o<=`AddAluOp;
                                      sign_o<=`LwInstSign;
                                    end
                           //�洢ָ��
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
