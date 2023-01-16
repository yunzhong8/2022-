`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/27 16:35:42
// Design Name: 
// Module Name: Data_Sram
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
//�ܿڵ�ַ
`define SerialStateAddr 32'hBFD0_03FC//��ʾ
`define SerialDataAddr 32'hBFD0_03F8//��ʾ�������ݣ�д�ĵ�ַʹ�����Ǳ�ʾ�ڴ������⴫�����ݣ��ʹ�������ģ�飬
//���ڴ��ڱȽ�����������ҪԤ�Ƚ����ݱ���һ���Ĵ���

module Data_Sram(
    input wire                     rst               ,
    input wire                     clk,
 //����
//        input     wire             rxd_i,  //ֱ�����ڽ��ն�
//        output    wire             txd_o,  //ֱ�����ڷ��Ͷ� 
    //ָ��洢��
        (*mark_debug = "true"*)input wire[`MemAddrBus]     cpu_rom_raddr_i   ,
        (*mark_debug = "true"*)output wire[`MemDataBus]    cpu_rom_rdata_o   ,
    //���ݴ洢��
        (*mark_debug = "true"*)input wire                 cpu_ram_ce_iL      ,
        (*mark_debug = "true"*)input wire                 cpu_ram_we_iL      ,
        (*mark_debug = "true"*)input wire [3:0]           cpu_ram_sel_iL     ,
        (*mark_debug = "true"*)input wire [`MemAddrBus]   cpu_ram_rwaddr_i   ,
        (*mark_debug = "true"*)input wire [`MemDataBus]   cpu_ram_wdata_i    ,
       (*mark_debug = "true"*) output reg[`MemDataBus]    cpu_ram_rdata_o    ,
       input wire                                           write_wb_regs_data_i  ,
       input wire [`RegsDataBus]                            wb_regs_data_i       ,
     //���ڷ�������
//        (*mark_debug = "true"*)input wire [31:0]          serial_rdata_i     ,
    //SRAM�ź�
        //ָ��洢��
            output reg              ext_ram_ce_oL     ,       //оƬʹ���ź�         
            output reg              ext_ram_oe_oL     ,       //��ʹ�ܵ͵�ƽ��Ч       
            output reg              ext_ram_we_oL     ,       //дʹ�ܵ͵�ƽ��Ч       
            output reg    [19:0]    ext_ram_addr_o    ,      //���ʵ�ַ         
            output reg    [3:0]     ext_ram_be_oL     ,       //Ƭѡ�ֽ��ź�        
            inout  wire   [31:0]    ext_ram_rwdata_io ,   //��д����        
        //���ݴ洢��
            output reg              base_ram_ce_oL    ,        //оƬʹ���ź�                 
            output reg              base_ram_oe_oL    ,        //��ʹ�ܵ͵�ƽ��Ч                
            output reg              base_ram_we_oL    ,       //дʹ�ܵ͵�ƽ��Ч                
            output reg    [19:0]    base_ram_addr_o   ,      //���ʵ�ַ                   
            output reg    [3:0]     base_ram_be_oL    ,       //Ƭѡ�ֽ��ź�                 
            inout  wire   [31:0]    base_ram_rwdata_io    //��д����                      
    );
//*******************************************Define Inner Variable�������ڲ�������***********************************************//
//���ڷô�
    wire is_RSerialState = (cpu_ram_rwaddr_i ==  `SerialStateAddr)?1'b1:1'b0;
    wire is_RWSerialData = (cpu_ram_rwaddr_i == `SerialDataAddr)?1'b1:1'b0;
   
    
//���ݷ��ʱ���
    //���ݴ洢���ô��ַ��0X80000000~0X803FFFF   ӳ�䵽 BaseRAM��      ָ��ռ䣬���ʾ�ô�ָ��洢����is_base_ram=1
        wire is_base_ram =  (cpu_ram_rwaddr_i >= 32'h8000_0000) && (cpu_ram_rwaddr_i < 32'h8040_0000)&&(cpu_ram_ce_iL ==1'b0);
        wire [31:0]base_ram_rdata;//baseRam��������
    //���ݴ洢���ô��ַ��0��80400000~0��807FFFF   ӳ�䵽 EXtRAM��       ���ݿռ䣬���ʾ�ô����ݴ洢����is_ext_ram=1
        wire is_ext_ram =   (cpu_ram_rwaddr_i >= 32'h8040_0000) && (cpu_ram_rwaddr_i < 32'h8080_0000)  ;
        wire [31:0]ext_ram_rdata;
//*******************************************loginc Implementation�������߼�ʵ�֣�***********************************************//
//*******************************************SRAM����***********************************************//
//�ô�Base_ram
//BaseRam
    assign base_ram_rwdata_io = is_base_ram ?((cpu_ram_we_iL==1'b0)?(write_wb_regs_data_i?wb_regs_data_i:cpu_ram_wdata_i):32'hzzzz_zzzz)//��base_ramд�����ݴ���
                                            :32'hzzzz_zzzz;
    assign base_ram_rdata = base_ram_rwdata_io;//��ȡbase-ram��������
    always@(*)begin
            if(rst)begin//��ʼ��base_sram�����ź�
                     base_ram_ce_oL<=1'b1;  
                     base_ram_oe_oL<=1'b1; 
                     base_ram_we_oL<=1'b1; 
                     base_ram_addr_o<=20'h0_0000;   
                     base_ram_be_oL<=4'b1111;
             end else begin
                       if(is_base_ram)begin//������ݷô�ָ��ô����ָ��ռ�ʱ
                                 base_ram_ce_oL<=1'b0;  
                                 base_ram_oe_oL<=!cpu_ram_we_iL; 
                                 base_ram_we_oL<=cpu_ram_we_iL; 
                                 base_ram_addr_o<=cpu_ram_rwaddr_i[21:2];   
                                 base_ram_be_oL<=cpu_ram_sel_iL;
                        end else begin//���ᵼ��ͬʱ���ȡָ��׶γ����𣿣������ô��ʱ�������ͣ��ˮ��
                                 base_ram_ce_oL<=1'b0;  
                                 base_ram_oe_oL<=1'b0; 
                                 base_ram_we_oL<=1'b1; 
                                 base_ram_addr_o<=cpu_rom_raddr_i[21:2];   
                                 base_ram_be_oL<=4'b0000;
                         end
              end
    end
    assign       cpu_rom_rdata_o = base_ram_rdata;
//�ô�ExtRam       
    assign ext_ram_rwdata_io = cpu_ram_we_iL?32'hzzzz_zzzz:write_wb_regs_data_i?wb_regs_data_i:cpu_ram_wdata_i;
    assign ext_ram_rdata = ext_ram_rwdata_io;//��ȡExt-ram��������
    always@(*)begin
            if(rst)begin//��ʼ��base_sram�����ź�
                     ext_ram_ce_oL<=1'b1;  
                     ext_ram_oe_oL<=1'b1; 
                     ext_ram_we_oL<=1'b1; 
                     ext_ram_addr_o<=20'h0_0000;   
                     ext_ram_be_oL<=4'b1111;
             end else begin
                       if(is_ext_ram)begin//������ݷô�ָ��ô�������ݿռ�ʱ
                                 ext_ram_ce_oL<=1'b0;  
                                 ext_ram_oe_oL<=!cpu_ram_we_iL; 
                                 ext_ram_we_oL<=cpu_ram_we_iL; 
                                 ext_ram_addr_o<=cpu_ram_rwaddr_i[21:2];   
                                 ext_ram_be_oL<=cpu_ram_sel_iL;
                        end else begin
                                 ext_ram_ce_oL<=1'b0;  
                                 ext_ram_oe_oL<=1'b0; 
                                 ext_ram_we_oL<=1'b1; 
                                 ext_ram_addr_o<=20'h0_0000;   
                                 ext_ram_be_oL<=4'b1111;
                        end
              end
    end
    //���ʴ���
//   (*mark_debug = "true"*) wire [31:0]serial_rdata;
//    Serial SerialI(
//    .rst                 (rst)                    ,
//    .clk                 (clk)                      ,
//    .serial_ce_iL        (cpu_ram_ce_iL  )          ,
//    .serial_we_iL        (cpu_ram_we_iL  )               ,    //���ڶ�дʹ��
//    .serial_rwaddr_i     (cpu_ram_rwaddr_i)            ,    //���ڷ��ʵ�ַ
//    .serial_wdata_i      (cpu_ram_wdata_i )             ,    //����д������
//    .rxd_i               (rxd_i)                          ,    //ֱ�����ڽ��ն�
//    .txd_o               (txd_o)                          ,    //ֱ�����ڷ��Ͷ�
//    .serial_rdata_o      (serial_rdata)                   //���ڶ�������
//);
//�ⲿ�洢���ô�õ����ݴ���cpu
always@(*)begin
          if(rst)begin
                cpu_ram_rdata_o<=32'h0000_0000;
          end else begin
//                   if((is_RSerialState||is_RWSerialData)&&~cpu_ram_ce_iL &&cpu_ram_we_iL)begin//�����CPU�Ƿ��ʴ��ڵĻ�
//                          cpu_ram_rdata_o<=serial_rdata;
//                  end else 
                  if(is_base_ram)begin//����ָ��ռ�
                            case(cpu_ram_sel_iL)
                                //�ֽڷ���
                                4'b1110:begin
                                         cpu_ram_rdata_o<={{24{base_ram_rdata[7]}},base_ram_rdata[7:0]};
                                        end
                                4'b1101:begin
                                        cpu_ram_rdata_o<={{24{base_ram_rdata[15]}},base_ram_rdata[15:8]};
                                    end
                                4'b1011:begin
                                        cpu_ram_rdata_o<={{24{base_ram_rdata[23]}},base_ram_rdata[23:16]};
                                    end
                                4'b0111:begin
                                        cpu_ram_rdata_o<={{24{base_ram_rdata[31]}},base_ram_rdata[31:24]};
                                    end
                                //˫�ַ���
                                4'b0000:begin
                                        cpu_ram_rdata_o<=base_ram_rdata;
                                    end
                                default:begin
                                        cpu_ram_rdata_o<=base_ram_rdata;
                                    end
                              endcase  
                   end else if(is_ext_ram)begin//�������ݿռ�
                            case(cpu_ram_sel_iL)
                                4'b1110:begin
                                            cpu_ram_rdata_o<={{24{ext_ram_rdata[7]}},ext_ram_rdata[7:0]};
                                        end
                                4'b1101:begin
                                            cpu_ram_rdata_o<={{24{ext_ram_rdata[15]}},ext_ram_rdata[15:8]};
                                        end
                                4'b1011:begin
                                            cpu_ram_rdata_o<={{24{ext_ram_rdata[23]}},ext_ram_rdata[23:16]};
                                        end
                                4'b0111:begin
                                            cpu_ram_rdata_o<={{24{ext_ram_rdata[31]}},ext_ram_rdata[31:24]};
                                        end
                                4'b0000:begin
                                            cpu_ram_rdata_o<=ext_ram_rdata;
                                        end
                                default:begin
                                            cpu_ram_rdata_o<=ext_ram_rdata;
                                        end
                             endcase 
                   end else begin
                       cpu_ram_rdata_o<=32'h0000_0000;
                   end                      
            end
 end
       
endmodule

