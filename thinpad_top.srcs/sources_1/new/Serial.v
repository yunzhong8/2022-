`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/27 22:15:59
// Design Name: 
// Module Name: Serial
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
`define SerialStateAddr 32'hBFD0_03FC//指令访存地址是它，表示获取串口的状态
`define SerialDataAddr 32'hBFD0_03F8//指令访存地址是它，表示访问串口数据，
//if 1：指令是写的指令，使它就是表示在串口向外传输数据，就触发发送模块，else 2: 读取串口接收数据
`include"MIPSdefines.v"
module Serial(
    input  wire                  rst                 ,
    input  wire                  clk                 ,
    input  wire                  serial_ce_iL        ,
    input  wire                  serial_we_iL        ,  //串口读写使能
    input  wire[`MemAddrBus]     serial_rwaddr_i     ,  //串口访问地址
    input  wire [31:0]           serial_wdata_i      ,  //串口写入数据
    
     input wire       write_wb_regs_data_i ,
     input wire [31:0] wb_regs_data_i        , 
    
    input  wire                  rxd_i               ,  //直连串口接收端
    output wire                  txd_o               ,  //直连串口发送端
    output wire [31:0]           serial_rdata_o         //串口读出数据

    );
//*******************************************Define Inner Variable（定义内部变量）***********************************************//
//接收器变量
    wire [7:0] serial_receiver_data;//串口接收到的8bit数据
    wire       serial_receiver_ready;//接收器接受完数据后置为1，表示接受器可以继续接受数据
    wire        serial_receiver_clear;//为1表示下个时钟会将接收器标准位清除
//发送器变量 
    reg  [7:0] serial_transmit_data;//串口发送的8bit数据
    wire       serial_transmitter_busy;//1表示发送器在发送数据，0表示不忙碌，已经发送完了
    reg        serial_transmitter_start;//1表示发送器可以发送，0表示不发生，发送器使能信号
//串口缓存区变量
    reg        serial_receiver_buffer_avai;//1、表示缓存区可用，0表示已经保存了数据，不可用
    reg [7:0]  serial_receiver_buffer;//串口的发送缓冲区
//*******************************************loginc Implementation（程序逻辑实现）***********************************************//   
//接收模块，9600无检验位,接受外部设备数据保存到cpu内部寄存器
async_receiver #(.ClkFrequency(50000000),.Baud(9600)) 
               ext_uart_r(
                   .clk(clk)                                   ,      // i 1 外部时钟信号
                   .RxD(rxd_i)                                 ,      // i 1 串口接收的外部的1bit 。  输入外界传入的1bit数据
                   .RxD_data_ready(serial_receiver_ready)      ,     //o 1串口是否完成全部数据接收，  输出：串口接收数据完成信号，1表示：接收完成
                   .RxD_clear( serial_receiver_clear)          ,    // i 1是否清除上次接收数据，      输入串口清除使能，1表示：清除上次接收到的数据（一般cpu把串口数据读取出则该信号为1）
                   .RxD_data(serial_receiver_data)                   // o 8串口接收到的一字节数据8bit  输出：串口当前接收到的数据
               );   
 //发送模块，9600无检验位，将写数据发送出
 async_transmitter #(.ClkFrequency(50000000),.Baud(9600)) 
                  ext_uart_t(
                      .clk(clk)                               ,    // i 1 外部时钟信号
                      .TxD(txd_o)                             ,   //o 1 串行发出的一个bit   输出串口当前时钟周期发送的1bit数据
                      .TxD_busy(serial_transmitter_busy)      ,   //o 1 发送器当前是否忙碌。输出到串口的状态是否忙碌，1表示是
                      .TxD_start(serial_transmitter_start)    ,  //i 1 串口发送使能。      输入串口发送使能，1：表示发送使能
                      .TxD_data(serial_transmit_data)            //i 8 待发送的数据8bit。  输入待发送的8比特数据
                  );  
  //接收区                
 assign serial_receiver_clear =serial_receiver_ready;
 always @(posedge clk)begin
    if(rst)begin
        serial_receiver_buffer_avai<=1'b0;
        serial_receiver_buffer <=8'b0;
    end else if(serial_receiver_ready)begin
        serial_receiver_buffer <=serial_receiver_data;
        serial_receiver_buffer_avai<=1'b1;
    end else if(serial_rwaddr_i==32'hBFD0_03F8&&~serial_ce_iL&&serial_we_iL && serial_receiver_buffer_avai)begin//本时钟周期时读串口数据，下个时钟周期就清空接收缓存区
        serial_receiver_buffer_avai <=1'b0;
        serial_receiver_buffer      <=8'b0;
    end else begin
        serial_receiver_buffer_avai<=serial_receiver_buffer_avai;
        serial_receiver_buffer <=serial_receiver_buffer;
    end
end
//发送区
always @(posedge clk)begin
    if(rst)begin
        serial_transmitter_start<=1'b0;
        serial_transmit_data<=8'b0;
    end else if(!serial_transmitter_busy&&serial_rwaddr_i==32'hBFD0_03F8&&~serial_ce_iL&&~serial_we_iL)begin
        if(write_wb_regs_data_i)begin
             serial_transmitter_start<=1'b1;
             serial_transmit_data<=wb_regs_data_i[7:0];
        end else begin
             serial_transmitter_start<=1'b1;
             serial_transmit_data<=serial_wdata_i[7:0];
        end
    end else begin
        serial_transmitter_start<=1'b0;
        serial_transmit_data<=serial_transmit_data;
    end
end

assign serial_rdata_o=(serial_rwaddr_i==32'hBFD0_03FC&&~serial_ce_iL&&serial_we_iL)?{30'h0,serial_receiver_buffer_avai,~serial_transmitter_busy}://读串口状态
                      (serial_rwaddr_i==32'hBFD0_03F8&&~serial_ce_iL&&serial_we_iL)?{24'h0,serial_receiver_buffer}:32'h0;//读串口数据
                      
                      
endmodule
