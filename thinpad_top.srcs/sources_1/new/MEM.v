`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/20 23:40:12
// Design Name: 
// Module Name: MEM
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
module MEM(
input wire rstL,
 input wire [`PCBus]            pc_i          ,
 input wire [`InstBus]          inst_i        ,
 output wire [`PCBus]           pc_o          ,
 output wire [`InstBus]         inst_o        ,
 
//����
    //������
        input wire [`AluOperBus] alu_result_i,
        input wire [31:0] serial_rdata_i,
    //�洢��
        input wire mem_req_i,
        input wire mem_we_i,
        input wire mem_rwbyte_i,
        input wire [31:0]         mem_rwaddr_i   ,
        input wire[`MemDataBus]   mem_wdata_i    ,
        input wire [`MemDataBus]  mem_rdata_i    ,
        
    //�Ĵ�����
        input wire[`RegsAddrBus] regs_waddr_i,
        input wire regs_we_i,
        input wire memtoreg_i,
    //����exe�׶��ǲ���Lָ��
        input wire exe_is_L_inst_o,
    
//���
    //�洢��
        output wire mem_req_o,
        output wire mem_we_o,
        output wire [`MemAddrBus]mem_rwaddr_o,
        output reg [3:0]mem_rwsel_o,
        output wire[`MemDataBus]mem_wdata_o,
        
//        output reg                 mem_req_o,
//        output reg                 mem_we_o,
//        output reg  [`MemAddrBus]  mem_rwaddr_o,
//        output reg [3:0]           mem_rwsel_o,
//        output reg [`MemDataBus]   mem_wdata_o,
        
    //�Ĵ�����
        output wire regs_we_o,
        output wire[`RegsAddrBus]regs_waddr_o,
        output wire[`RegsDataBus] regs_wdata_o,
    //��ǰָ���ǲ���mem
        output wire inst_is_s_o,
        output wire stop_o     ,
        input wire                sw_relate_i    ,
        input [31:0]              wb_regs_wdata 


    );
//*******************************************loginc Implementation�������߼�ʵ�֣�***********************************************//
  assign  pc_o    = pc_i      ;   
  assign  inst_o  = inst_i     ;  
  //�Ĵ�����
    assign regs_waddr_o=regs_waddr_i;
    assign regs_we_o=regs_we_i;
    assign regs_wdata_o=memtoreg_i?((mem_rwaddr_i==32'hBFD0_03FC||mem_rwaddr_i==32'hBFD0_03F8)?serial_rdata_i:mem_rdata_i):alu_result_i;
    
//�洢��  
    assign  mem_we_o     = mem_we_i;//дʹ��
//  assign  mem_rwaddr_o = mem_req_i?alu_result_i:32'h0000_0000;    
    assign  mem_rwaddr_o = mem_rwaddr_i; 
    assign  mem_wdata_o  = mem_wdata_i;
//   assign  mem_wdata_o  =sw_relate_i?wb_regs_wdata: mem_wdata_i;
    assign  mem_req_o    = mem_req_i;
    
always@(*)begin//д�ֽ�
       if(rstL==`RstEnable)begin
            mem_rwsel_o<=4'b0000;
       end else begin
            if(mem_rwbyte_i==1'b0)begin//Ϊ1��ʾ���ֽڶ�
                mem_rwsel_o<=4'b1111;
            end else begin
                case(alu_result_i[1:0])
                    2'b00:mem_rwsel_o<=4'b0001;
                    2'b01:mem_rwsel_o<=4'b0010;
                    2'b10:mem_rwsel_o<=4'b0100;
                    2'b11:mem_rwsel_o<=4'b1000;
                    default : mem_rwsel_o<=4'b0000;
                endcase
             end
        end
end
     //mem����
//     always@(*)//д�ֽ�
//       if(rstL==`RstEnable)begin
//            mem_rwsel_o<=4'b0000;
//            mem_rwaddr_o <=   32'h0000_0000;
//            mem_we_o     <=   1'b0;  
//            mem_req_o    <=   1'b0;                                              
//            mem_wdata_o  <=   32'h0000_0000;
            
//       end else
//            if(mem_rwbyte_i==1'b0)begin//Ϊ1��ʾ���ֽڶ�
//                mem_wdata_o  <=   mem_wdata_i;
//                mem_rwsel_o<=4'b1111;
//                mem_rwaddr_o <=   mem_rwaddr_i;
//                mem_we_o     <=   mem_we_i;  
//                mem_req_o    <=   mem_req_i;                                              
                
//            end else
//                case(alu_result_i[1:0])
//                    2'b00:begin
//                        mem_wdata_o  <=   mem_wdata_i;
//                        mem_rwsel_o<=4'b0001;
//                        mem_rwaddr_o <=   mem_rwaddr_i;
//                        mem_we_o     <=   mem_we_i;  
//                        mem_req_o    <=   mem_req_i;                                              
                        
//                    end 
//                    2'b01:begin
//                        mem_wdata_o  <=   mem_wdata_i;
//                        mem_rwsel_o<=4'b0010;
//                        mem_rwaddr_o <=   mem_rwaddr_i;
//                        mem_we_o     <=   mem_we_i;  
//                        mem_req_o    <=   mem_req_i;                                              
                       
//                    end
//                    2'b10:begin
//                        mem_wdata_o  <=   mem_wdata_i;
//                        mem_rwsel_o<=4'b0100;
//                        mem_rwaddr_o <=   mem_rwaddr_i;
//                        mem_we_o     <=   mem_we_i;  
//                        mem_req_o    <=   mem_req_i;                                              
                        
//                    end
//                    default:begin
//                        mem_wdata_o  <=   mem_wdata_i;
//                        mem_rwsel_o<=4'b1000;
//                        mem_rwaddr_o <=   mem_rwaddr_i;
//                        mem_we_o     <=   mem_we_i;  
//                        mem_req_o    <=   mem_req_i;                                              
                        
//                    end
                   
//                endcase
     
                           
                
                
      assign inst_is_s_o=(mem_req_i&&~mem_we_i)?1'b1:1'b0  ;
      //mem����baseram����ͣ���Ƿ��ʹ��ڵ�sw��һ��ָ����lw��lw���ʵ�ַ����BFD003FC��BFD003F8
      assign stop_o= (mem_rwaddr_i>=32'h8000_0000)&&(mem_rwaddr_i<32'h8040_0000)||(mem_req_i&&mem_we_i&&exe_is_L_inst_o)?1'b1:1'b0;//�������baseram����ͣ��ˮ    
      
      
       
       
endmodule
