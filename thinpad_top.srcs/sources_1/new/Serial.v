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
`define SerialStateAddr 32'hBFD0_03FC//ָ��ô��ַ��������ʾ��ȡ���ڵ�״̬
`define SerialDataAddr 32'hBFD0_03F8//ָ��ô��ַ��������ʾ���ʴ������ݣ�
//if 1��ָ����д��ָ�ʹ�����Ǳ�ʾ�ڴ������⴫�����ݣ��ʹ�������ģ�飬else 2: ��ȡ���ڽ�������
`include"MIPSdefines.v"
module Serial(
    input  wire                  rst                 ,
    input  wire                  clk                 ,
    input  wire                  serial_ce_iL        ,
    input  wire                  serial_we_iL        ,  //���ڶ�дʹ��
    input  wire[`MemAddrBus]     serial_rwaddr_i     ,  //���ڷ��ʵ�ַ
    input  wire [31:0]           serial_wdata_i      ,  //����д������
    
     input wire       write_wb_regs_data_i ,
     input wire [31:0] wb_regs_data_i        , 
    
    input  wire                  rxd_i               ,  //ֱ�����ڽ��ն�
    output wire                  txd_o               ,  //ֱ�����ڷ��Ͷ�
    output wire [31:0]           serial_rdata_o         //���ڶ�������

    );
//*******************************************Define Inner Variable�������ڲ�������***********************************************//
//����������
    wire [7:0] serial_receiver_data;//���ڽ��յ���8bit����
    wire       serial_receiver_ready;//���������������ݺ���Ϊ1����ʾ���������Լ�����������
    wire        serial_receiver_clear;//Ϊ1��ʾ�¸�ʱ�ӻὫ��������׼λ���
//���������� 
    reg  [7:0] serial_transmit_data;//���ڷ��͵�8bit����
    wire       serial_transmitter_busy;//1��ʾ�������ڷ������ݣ�0��ʾ��æµ���Ѿ���������
    reg        serial_transmitter_start;//1��ʾ���������Է��ͣ�0��ʾ��������������ʹ���ź�
//���ڻ���������
    reg        serial_receiver_buffer_avai;//1����ʾ���������ã�0��ʾ�Ѿ����������ݣ�������
    reg [7:0]  serial_receiver_buffer;//���ڵķ��ͻ�����
//*******************************************loginc Implementation�������߼�ʵ�֣�***********************************************//   
//����ģ�飬9600�޼���λ,�����ⲿ�豸���ݱ��浽cpu�ڲ��Ĵ���
async_receiver #(.ClkFrequency(50000000),.Baud(9600)) 
               ext_uart_r(
                   .clk(clk)                                   ,      // i 1 �ⲿʱ���ź�
                   .RxD(rxd_i)                                 ,      // i 1 ���ڽ��յ��ⲿ��1bit ��  ������紫���1bit����
                   .RxD_data_ready(serial_receiver_ready)      ,     //o 1�����Ƿ����ȫ�����ݽ��գ�  ��������ڽ�����������źţ�1��ʾ���������
                   .RxD_clear( serial_receiver_clear)          ,    // i 1�Ƿ�����ϴν������ݣ�      ���봮�����ʹ�ܣ�1��ʾ������ϴν��յ������ݣ�һ��cpu�Ѵ������ݶ�ȡ������ź�Ϊ1��
                   .RxD_data(serial_receiver_data)                   // o 8���ڽ��յ���һ�ֽ�����8bit  ��������ڵ�ǰ���յ�������
               );   
 //����ģ�飬9600�޼���λ����д���ݷ��ͳ�
 async_transmitter #(.ClkFrequency(50000000),.Baud(9600)) 
                  ext_uart_t(
                      .clk(clk)                               ,    // i 1 �ⲿʱ���ź�
                      .TxD(txd_o)                             ,   //o 1 ���з�����һ��bit   ������ڵ�ǰʱ�����ڷ��͵�1bit����
                      .TxD_busy(serial_transmitter_busy)      ,   //o 1 ��������ǰ�Ƿ�æµ����������ڵ�״̬�Ƿ�æµ��1��ʾ��
                      .TxD_start(serial_transmitter_start)    ,  //i 1 ���ڷ���ʹ�ܡ�      ���봮�ڷ���ʹ�ܣ�1����ʾ����ʹ��
                      .TxD_data(serial_transmit_data)            //i 8 �����͵�����8bit��  ��������͵�8��������
                  );  
  //������                
 assign serial_receiver_clear =serial_receiver_ready;
 always @(posedge clk)begin
    if(rst)begin
        serial_receiver_buffer_avai<=1'b0;
        serial_receiver_buffer <=8'b0;
    end else if(serial_receiver_ready)begin
        serial_receiver_buffer <=serial_receiver_data;
        serial_receiver_buffer_avai<=1'b1;
    end else if(serial_rwaddr_i==32'hBFD0_03F8&&~serial_ce_iL&&serial_we_iL && serial_receiver_buffer_avai)begin//��ʱ������ʱ���������ݣ��¸�ʱ�����ھ���ս��ջ�����
        serial_receiver_buffer_avai <=1'b0;
        serial_receiver_buffer      <=8'b0;
    end else begin
        serial_receiver_buffer_avai<=serial_receiver_buffer_avai;
        serial_receiver_buffer <=serial_receiver_buffer;
    end
end
//������
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

assign serial_rdata_o=(serial_rwaddr_i==32'hBFD0_03FC&&~serial_ce_iL&&serial_we_iL)?{30'h0,serial_receiver_buffer_avai,~serial_transmitter_busy}://������״̬
                      (serial_rwaddr_i==32'hBFD0_03F8&&~serial_ce_iL&&serial_we_iL)?{24'h0,serial_receiver_buffer}:32'h0;//����������
                      
                      
endmodule
