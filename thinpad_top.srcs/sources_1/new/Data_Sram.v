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
//窜口地址
`define SerialStateAddr 32'hBFD0_03FC//表示
`define SerialDataAddr 32'hBFD0_03F8//表示串口数据，写的地址使它就是表示在串口向外传输数据，就触发发送模块，
//由于串口比较慢，所以需要预先将数据保持一个寄存器

module Data_Sram(
    input wire                     rst               ,
    input wire                     clk,
 //串口
//        input     wire             rxd_i,  //直连串口接收端
//        output    wire             txd_o,  //直连串口发送端 
    //指令存储器
        (*mark_debug = "true"*)input wire[`MemAddrBus]     cpu_rom_raddr_i   ,
        (*mark_debug = "true"*)output wire[`MemDataBus]    cpu_rom_rdata_o   ,
    //数据存储器
        (*mark_debug = "true"*)input wire                 cpu_ram_ce_iL      ,
        (*mark_debug = "true"*)input wire                 cpu_ram_we_iL      ,
        (*mark_debug = "true"*)input wire [3:0]           cpu_ram_sel_iL     ,
        (*mark_debug = "true"*)input wire [`MemAddrBus]   cpu_ram_rwaddr_i   ,
        (*mark_debug = "true"*)input wire [`MemDataBus]   cpu_ram_wdata_i    ,
       (*mark_debug = "true"*) output reg[`MemDataBus]    cpu_ram_rdata_o    ,
       input wire                                           write_wb_regs_data_i  ,
       input wire [`RegsDataBus]                            wb_regs_data_i       ,
     //串口访问输入
//        (*mark_debug = "true"*)input wire [31:0]          serial_rdata_i     ,
    //SRAM信号
        //指令存储器
            output reg              ext_ram_ce_oL     ,       //芯片使能信号         
            output reg              ext_ram_oe_oL     ,       //读使能低电平有效       
            output reg              ext_ram_we_oL     ,       //写使能低电平有效       
            output reg    [19:0]    ext_ram_addr_o    ,      //访问地址         
            output reg    [3:0]     ext_ram_be_oL     ,       //片选字节信号        
            inout  wire   [31:0]    ext_ram_rwdata_io ,   //读写数据        
        //数据存储器
            output reg              base_ram_ce_oL    ,        //芯片使能信号                 
            output reg              base_ram_oe_oL    ,        //读使能低电平有效                
            output reg              base_ram_we_oL    ,       //写使能低电平有效                
            output reg    [19:0]    base_ram_addr_o   ,      //访问地址                   
            output reg    [3:0]     base_ram_be_oL    ,       //片选字节信号                 
            inout  wire   [31:0]    base_ram_rwdata_io    //读写数据                      
    );
//*******************************************Define Inner Variable（定义内部变量）***********************************************//
//串口访存
    wire is_RSerialState = (cpu_ram_rwaddr_i ==  `SerialStateAddr)?1'b1:1'b0;
    wire is_RWSerialData = (cpu_ram_rwaddr_i == `SerialDataAddr)?1'b1:1'b0;
   
    
//数据访问变量
    //数据存储器访存地址在0X80000000~0X803FFFF   映射到 BaseRAM，      指令空间，则表示访存指令存储器，is_base_ram=1
        wire is_base_ram =  (cpu_ram_rwaddr_i >= 32'h8000_0000) && (cpu_ram_rwaddr_i < 32'h8040_0000)&&(cpu_ram_ce_iL ==1'b0);
        wire [31:0]base_ram_rdata;//baseRam读出数据
    //数据存储器访存地址在0×80400000~0×807FFFF   映射到 EXtRAM，       数据空间，则表示访存数据存储器，is_ext_ram=1
        wire is_ext_ram =   (cpu_ram_rwaddr_i >= 32'h8040_0000) && (cpu_ram_rwaddr_i < 32'h8080_0000)  ;
        wire [31:0]ext_ram_rdata;
//*******************************************loginc Implementation（程序逻辑实现）***********************************************//
//*******************************************SRAM访问***********************************************//
//访存Base_ram
//BaseRam
    assign base_ram_rwdata_io = is_base_ram ?((cpu_ram_we_iL==1'b0)?(write_wb_regs_data_i?wb_regs_data_i:cpu_ram_wdata_i):32'hzzzz_zzzz)//将base_ram写入数据传入
                                            :32'hzzzz_zzzz;
    assign base_ram_rdata = base_ram_rwdata_io;//获取base-ram读出数据
    always@(*)begin
            if(rst)begin//初始化base_sram传入信号
                     base_ram_ce_oL<=1'b1;  
                     base_ram_oe_oL<=1'b1; 
                     base_ram_we_oL<=1'b1; 
                     base_ram_addr_o<=20'h0_0000;   
                     base_ram_be_oL<=4'b1111;
             end else begin
                       if(is_base_ram)begin//如果数据访存指令访存的是指令空间时
                                 base_ram_ce_oL<=1'b0;  
                                 base_ram_oe_oL<=!cpu_ram_we_iL; 
                                 base_ram_we_oL<=cpu_ram_we_iL; 
                                 base_ram_addr_o<=cpu_ram_rwaddr_i[21:2];   
                                 base_ram_be_oL<=cpu_ram_sel_iL;
                        end else begin//不会导致同时间的取指令阶段出错吗？？？，访存的时候必须暂停流水了
                                 base_ram_ce_oL<=1'b0;  
                                 base_ram_oe_oL<=1'b0; 
                                 base_ram_we_oL<=1'b1; 
                                 base_ram_addr_o<=cpu_rom_raddr_i[21:2];   
                                 base_ram_be_oL<=4'b0000;
                         end
              end
    end
    assign       cpu_rom_rdata_o = base_ram_rdata;
//访存ExtRam       
    assign ext_ram_rwdata_io = cpu_ram_we_iL?32'hzzzz_zzzz:write_wb_regs_data_i?wb_regs_data_i:cpu_ram_wdata_i;
    assign ext_ram_rdata = ext_ram_rwdata_io;//获取Ext-ram读出数据
    always@(*)begin
            if(rst)begin//初始化base_sram传入信号
                     ext_ram_ce_oL<=1'b1;  
                     ext_ram_oe_oL<=1'b1; 
                     ext_ram_we_oL<=1'b1; 
                     ext_ram_addr_o<=20'h0_0000;   
                     ext_ram_be_oL<=4'b1111;
             end else begin
                       if(is_ext_ram)begin//如果数据访存指令访存的是数据空间时
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
    //访问串口
//   (*mark_debug = "true"*) wire [31:0]serial_rdata;
//    Serial SerialI(
//    .rst                 (rst)                    ,
//    .clk                 (clk)                      ,
//    .serial_ce_iL        (cpu_ram_ce_iL  )          ,
//    .serial_we_iL        (cpu_ram_we_iL  )               ,    //串口读写使能
//    .serial_rwaddr_i     (cpu_ram_rwaddr_i)            ,    //串口访问地址
//    .serial_wdata_i      (cpu_ram_wdata_i )             ,    //串口写入数据
//    .rxd_i               (rxd_i)                          ,    //直连串口接收端
//    .txd_o               (txd_o)                          ,    //直连串口发送端
//    .serial_rdata_o      (serial_rdata)                   //串口读出数据
//);
//外部存储器访存得到数据传给cpu
always@(*)begin
          if(rst)begin
                cpu_ram_rdata_o<=32'h0000_0000;
          end else begin
//                   if((is_RSerialState||is_RWSerialData)&&~cpu_ram_ce_iL &&cpu_ram_we_iL)begin//如果是CPU是访问串口的话
//                          cpu_ram_rdata_o<=serial_rdata;
//                  end else 
                  if(is_base_ram)begin//访问指令空间
                            case(cpu_ram_sel_iL)
                                //字节访问
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
                                //双字访问
                                4'b0000:begin
                                        cpu_ram_rdata_o<=base_ram_rdata;
                                    end
                                default:begin
                                        cpu_ram_rdata_o<=base_ram_rdata;
                                    end
                              endcase  
                   end else if(is_ext_ram)begin//访问数据空间
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

