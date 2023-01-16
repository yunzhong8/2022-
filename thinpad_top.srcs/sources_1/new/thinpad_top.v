`default_nettype none

module thinpad_top(
    input wire clk_50M,           //50MHz ʱ������
    input wire clk_11M0592,       //11.0592MHz ʱ�����루���ã��ɲ��ã�

    input wire clock_btn,         //BTN5�ֶ�ʱ�Ӱ�ť���أ���������·������ʱΪ1
    input wire reset_btn,         //BTN6�ֶ���λ��ť���أ���������·������ʱΪ1

    input  wire[3:0]  touch_btn,  //BTN1~BTN4����ť���أ�����ʱΪ1
    input  wire[31:0] dip_sw,     //32λ���뿪�أ�������ON��ʱΪ1
    output wire[15:0] leds,       //16λLED�����ʱ1����
    output wire[7:0]  dpy0,       //����ܵ�λ�źţ�����С���㣬���1����
    output wire[7:0]  dpy1,       //����ܸ�λ�źţ�����С���㣬���1����

    //BaseRAM�ź�
    inout wire[31:0] base_ram_data,  //BaseRAM���ݣ���8λ��CPLD���ڿ���������
    output wire[19:0] base_ram_addr, //BaseRAM��ַ
    output wire[3:0] base_ram_be_n,  //BaseRAM�ֽ�ʹ�ܣ�����Ч�������ʹ���ֽ�ʹ�ܣ��뱣��Ϊ0
    output wire base_ram_ce_n,       //BaseRAMƬѡ������Ч
    output wire base_ram_oe_n,       //BaseRAM��ʹ�ܣ�����Ч
    output wire base_ram_we_n,       //BaseRAMдʹ�ܣ�����Ч

    //ExtRAM�ź�
    inout wire[31:0] ext_ram_data,  //ExtRAM����
    output wire[19:0] ext_ram_addr, //ExtRAM��ַ
    output wire[3:0] ext_ram_be_n,  //ExtRAM�ֽ�ʹ�ܣ�����Ч�������ʹ���ֽ�ʹ�ܣ��뱣��Ϊ0
    output wire ext_ram_ce_n,       //ExtRAMƬѡ������Ч
    output wire ext_ram_oe_n,       //ExtRAM��ʹ�ܣ�����Ч
    output wire ext_ram_we_n,       //ExtRAMдʹ�ܣ�����Ч

    //ֱ�������ź�
    output wire txd,  //ֱ�����ڷ��Ͷ�
    input  wire rxd,  //ֱ�����ڽ��ն�

    //Flash�洢���źţ��ο� JS28F640 оƬ�ֲ�
    output wire [22:0]flash_a,      //Flash��ַ��a0����8bitģʽ��Ч��16bitģʽ������
    inout  wire [15:0]flash_d,      //Flash����
    output wire flash_rp_n,         //Flash��λ�źţ�����Ч
    output wire flash_vpen,         //Flashд�����źţ��͵�ƽʱ���ܲ�������д
    output wire flash_ce_n,         //FlashƬѡ�źţ�����Ч
    output wire flash_oe_n,         //Flash��ʹ���źţ�����Ч
    output wire flash_we_n,         //Flashдʹ���źţ�����Ч
    output wire flash_byte_n,       //Flash 8bitģʽѡ�񣬵���Ч����ʹ��flash��16λģʽʱ����Ϊ1

    //ͼ������ź�
    output wire[2:0] video_red,    //��ɫ���أ�3λ
    output wire[2:0] video_green,  //��ɫ���أ�3λ
    output wire[1:0] video_blue,   //��ɫ���أ�2λ
    output wire video_hsync,       //��ͬ����ˮƽͬ�����ź�
    output wire video_vsync,       //��ͬ������ֱͬ�����ź�
    output wire video_clk,         //����ʱ�����
    output wire video_de           //��������Ч�źţ���������������
    
//    output wire video_de,           //��������Ч�źţ���������������
////    //trace -debug
//    output wire [31:0] debug_wb_pc,
//    output wire [3:0] debug_wb_rf_wen,
//    output wire [4:0] debug_wb_rf_wnum,
//    output wire [31:0] debug_wb_rf_wdata
);
/* =========== Demo code begin =========== */
     wire [31:0] debug_wb_pc        ;
     wire [3:0] debug_wb_rf_wen     ;
     wire [4:0] debug_wb_rf_wnum    ;
     wire [31:0] debug_wb_rf_wdata  ;
// PLL��Ƶʾ��
wire locked, clk_10M, clk_20M;
pll_example clock_gen 
 (
  // Clock in ports
  .clk_in1(clk_50M),  // �ⲿʱ������
  // Clock out ports
  .clk_out1(clk_10M), // ʱ�����1��Ƶ����IP���ý���������
  .clk_out2(clk_20M), // ʱ�����2��Ƶ����IP���ý���������
  // Status and control signals
  .reset(reset_btn), // PLL��λ����
  .locked(locked)    // PLL����ָʾ�����"1"��ʾʱ���ȶ���
                     // �󼶵�·��λ�ź�Ӧ���������ɣ����£�
 );

reg reset_of_clk10M;
// �첽��λ��ͬ���ͷţ���locked�ź�תΪ�󼶵�·�ĸ�λreset_of_clk10M
always@(posedge clk_10M or negedge locked) begin
    if(~locked) reset_of_clk10M <= 1'b1;
    else        reset_of_clk10M <= 1'b0;
end

always@(posedge clk_10M or posedge reset_of_clk10M) begin
    if(reset_of_clk10M)begin
        // Your Code
    end
    else begin
        // Your Code
    end
end

// ��ʹ���ڴ桢����ʱ��������ʹ���ź�
//assign base_ram_ce_n = 1'b1;
//assign base_ram_oe_n = 1'b1;
//assign base_ram_we_n = 1'b1;

//assign ext_ram_ce_n = 1'b1;
//assign ext_ram_oe_n = 1'b1;
//assign ext_ram_we_n = 1'b1;

// ��������ӹ�ϵʾ��ͼ��dpy1ͬ��
// p=dpy0[0] // ---a---
// c=dpy0[1] // |     |
// d=dpy0[2] // f     b
// e=dpy0[3] // |     |
// b=dpy0[4] // ---g---
// a=dpy0[5] // |     |
// f=dpy0[6] // e     c
// g=dpy0[7] // |     |
//           // ---d---  p

// 7���������������ʾ����number��16������ʾ�����������
wire[7:0] number;
SEG7_LUT segL(.oSEG1(dpy0), .iDIG(number[3:0])); //dpy0�ǵ�λ�����
SEG7_LUT segH(.oSEG1(dpy1), .iDIG(number[7:4])); //dpy1�Ǹ�λ�����

reg[15:0] led_bits;
assign leds = led_bits;

always@(posedge clock_btn or posedge reset_btn) begin
    if(reset_btn)begin //��λ���£�����LEDΪ��ʼֵ
        led_bits <= 16'h1;
    end
    else begin //ÿ�ΰ���ʱ�Ӱ�ť��LEDѭ������
        led_bits <= {led_bits[14:0],led_bits[15]};
    end
end

//ֱ�����ڽ��շ�����ʾ����ֱ�������յ��������ٷ��ͳ�ȥ
////������
//wire [7:0] ext_uart_rx;
//wire ext_uart_ready, ext_uart_clear;
////������
//wire ext_uart_busy;
//reg ext_uart_start;
//reg  [7:0]  ext_uart_tx;
////������
//reg ext_uart_avai;
//reg  [7:0] ext_uart_buffer; 
  
//assign number = ext_uart_buffer;

//async_receiver #(.ClkFrequency(50000000),.Baud(9600)) //����ģ�飬9600�޼���λ
//    ext_uart_r(
//        .clk(clk_50M),                       //�ⲿʱ���ź�
//        .RxD(rxd),                           //�ⲿ�����ź�����
//        .RxD_data_ready(ext_uart_ready),  //���ݽ��յ���־
//        .RxD_clear(ext_uart_clear),       //������ձ�־
//        .RxD_data(ext_uart_rx)             //���յ���һ�ֽ�����
//    );

//assign ext_uart_clear = ext_uart_ready; //�յ����ݵ�ͬʱ�������־����Ϊ������ȡ��ext_uart_buffer��
//always @(posedge clk_50M) begin //���յ�������ext_uart_buffer
//    if(ext_uart_ready)begin
//        ext_uart_buffer <= ext_uart_rx;
//        ext_uart_avai <= 1;
//    end else if(!ext_uart_busy && ext_uart_avai)begin 
//        ext_uart_avai <= 0;
//    end
//end
//always @(posedge clk_50M) begin //��������ext_uart_buffer���ͳ�ȥ
//    if(!ext_uart_busy && ext_uart_avai)begin 
//        ext_uart_tx <= ext_uart_buffer;
//        ext_uart_start <= 1;
//    end else begin 
//        ext_uart_start <= 0;
//    end
//end

//async_transmitter #(.ClkFrequency(50000000),.Baud(9600)) //����ģ�飬9600�޼���λ
//    ext_uart_t(
//        .clk(clk_50M),                  //�ⲿʱ���ź�
//        .TxD(txd),                      //�����ź����
//        .TxD_busy(ext_uart_busy),       //������æ״ָ̬ʾ
//        .TxD_start(ext_uart_start),    //��ʼ�����ź�
//        .TxD_data(ext_uart_tx)        //�����͵�����
//    );

//ͼ�������ʾ���ֱ���800x600@75Hz������ʱ��Ϊ50MHz
wire [11:0] hdata;
assign video_red = hdata < 266 ? 3'b111 : 0; //��ɫ����
assign video_green = hdata < 532 && hdata >= 266 ? 3'b111 : 0; //��ɫ����
assign video_blue = hdata >= 532 ? 2'b11 : 0; //��ɫ����
assign video_clk = clk_50M;
vga #(12, 800, 856, 976, 1040, 600, 637, 643, 666, 1, 1) vga800x600at75 (
    .clk(clk_50M), 
    .hdata(hdata), //������
    .vdata(),      //������
    .hsync(video_hsync),
    .vsync(video_vsync),
    .data_enable(video_de)
);
/* =========== Demo code end =========== */
//*******************************************Define Inner Variable�������ڲ�������***********************************************//
	 //DS SRAM
         //ָ��洢����������
                wire[31:0]          ds_rom_rinst_o              ;
         //���ݴ洢����������
                wire [31:0]         ds_ram_rdata_o              ;
     //MIPS
        //ָ��洢������ַ
            wire[31:0]              mips_rom_raddr_o            ;
        //���ݴ洢��
            wire [31:0]             mips_ram_rwaddr_o           ;
            wire                    mips_ram_we_o               ;
            wire[3:0]               mips_ram_rwsel_o            ;
            wire[31:0]              mips_ram_wdata_o            ;
            wire                    mips_ram_req_o              ;
//         //�����
//             wire[31:0]       led_data;
 //*******************************************loginc Implementation�������߼�ʵ�֣�***********************************************// 
   //CPU
   wire rstL;
  wire  write_wb_regs_data_o;
   wire [31:0]wb_regs_data_o     ; 
   assign rstL=~reset_btn;
    MIPS mipsI(
          .rstL              ( ~reset_btn  )          ,//CPU�ǵ͵�ƽʹ��
//          .rstL              ( rstL )          ,//CPU�ǵ͵�ƽʹ��
//          .rstL              (1'b1)                  ,
          .clk               ( clk_50M )              ,
        //����
            //ָ��洢����������
             .rom_inst_i        ( ds_rom_rinst_o )    ,
            //���ݴ洢����������
             .ram_rdata_i      ( ds_ram_rdata_o )     ,
             .serial_rdata_i   (serial_rdata)         ,
        //���
            //ָ��洢������ַ
           .rom_raddr_o      (mips_rom_raddr_o)       ,
            //���ݴ洢��
           .ram_req_o        (mips_ram_req_o)         ,
           .ram_we_o         (mips_ram_we_o )         ,
           .ram_rwaddr_o     (mips_ram_rwaddr_o)      ,
           .ram_rwsel_o      (mips_ram_rwsel_o)       ,
           .ram_wdata_o      (mips_ram_wdata_o)       ,
           .write_wb_regs_data_o ( write_wb_regs_data_o),
           .wb_regs_data_o       ( wb_regs_data_o       )    ,
           //debug_trace
           .debug_wb_pc      (debug_wb_pc)            ,
           .debug_wb_rf_wen  (debug_wb_rf_wen)        ,
           .debug_wb_rf_wnum (debug_wb_rf_wnum)       ,
           .debug_wb_rf_wdata(debug_wb_rf_wdata)      
           
            //�������ʾ
//           .led_data         (led_data)
    );
//    //�ߵ�ƽ��Чת�͵�ƽ��Ч
     wire                    mips_ram_req_oL;
     wire                    mips_ram_we_oL;
     wire[3:0]               mips_ram_rwsel_oL;
     
     assign  mips_ram_req_oL   = ~mips_ram_req_o     ;
     assign  mips_ram_we_oL    = ~mips_ram_we_o      ;         
     assign  mips_ram_rwsel_oL = ~mips_ram_rwsel_o   ;      
       
//     assign  mips_ram_we_oL    = 1'b1     ;         
//     assign  mips_ram_rwsel_oL = 4'b1111  ;      
//     assign  mips_ram_req_oL   = 1'b1    ;  
////*******************************************���ڷ���&&SRAM����***********************************************//
////cpu��sram,���ڵ���
  (*mark_debug = "true"*) wire [31:0]serial_rdata;
    Serial SerialI(
    .rst                 (reset_btn)                    ,
    .clk                 (clk_50M)                      ,
//    .clk_50M             (clk_50Mppl),
    .serial_ce_iL        (mips_ram_req_oL  )          ,
    .serial_we_iL        (mips_ram_we_oL   )               ,    //���ڶ�дʹ��
    .serial_rwaddr_i     (mips_ram_rwaddr_o)            ,    //���ڷ��ʵ�ַ
    .serial_wdata_i      (mips_ram_wdata_o )             ,    //����д������
    
     .write_wb_regs_data_i(write_wb_regs_data_o ),
     .wb_regs_data_i      (wb_regs_data_o       ) , 
            
    .rxd_i               (rxd)                          ,    //ֱ�����ڽ��ն�
    .txd_o               (txd)                          ,    //ֱ�����ڷ��Ͷ�
    .serial_rdata_o      (serial_rdata)                   //���ڶ�������
);
 
 
 
 
 Data_Sram DS(
            .rst                 ( reset_btn )                     ,                                  
            .clk                 ( clk_50M )                     , 
//             .clk                (clk_55M)                      , //��Ƶ��ʱ�ӣ�����ϰ�ʹ�                                  
//            .rxd_i               ( rxd )                         ,      //ֱ�����ڽ��ն�                       
//            .txd_o               ( txd )                         ,      //ֱ�����ڷ��Ͷ�      
            //Rom����              
            .cpu_rom_raddr_i     ( mips_rom_raddr_o )            ,                                                  
            .cpu_rom_rdata_o     ( ds_rom_rinst_o )              ,                        
            //Ram����                
            .cpu_ram_ce_iL       ( mips_ram_req_oL )             ,
            .cpu_ram_we_iL       ( mips_ram_we_oL )              ,                                      
            .cpu_ram_rwaddr_i    ( mips_ram_rwaddr_o  )          ,
            .cpu_ram_sel_iL      ( mips_ram_rwsel_oL  )          ,                                 
            .cpu_ram_wdata_i     ( mips_ram_wdata_o )            ,                        
                               
            .cpu_ram_rdata_o     ( ds_ram_rdata_o )              ,
            .write_wb_regs_data_i(write_wb_regs_data_o ),
            .wb_regs_data_i      (wb_regs_data_o       ) ,  
            //SRAM�ź�    
            . ext_ram_ce_oL      ( ext_ram_ce_n     )            ,       //оƬʹ���ź�          
            . ext_ram_oe_oL      ( ext_ram_oe_n    )             ,       //��ʹ�ܵ͵�ƽ��Ч        
            . ext_ram_we_oL      ( ext_ram_we_n    )             ,       //дʹ�ܵ͵�ƽ��Ч        
            . ext_ram_addr_o     ( ext_ram_addr   )              ,       //���ʵ�ַ            
            . ext_ram_be_oL      ( ext_ram_be_n    )             ,       //Ƭѡ�ֽ��ź�          
            . ext_ram_rwdata_io  ( ext_ram_data )                ,       //��д����            
                               
            . base_ram_ce_oL     ( base_ram_ce_n  )              ,       //оƬʹ���ź�        
            . base_ram_oe_oL     ( base_ram_oe_n  )              ,       //��ʹ�ܵ͵�ƽ��Ч      
            . base_ram_we_oL     ( base_ram_we_n  )              ,       //дʹ�ܵ͵�ƽ��Ч       
            . base_ram_addr_o    ( base_ram_addr  )              ,       //���ʵ�ַ           
            . base_ram_be_oL     ( base_ram_be_n  )              ,       //Ƭѡ�ֽ��ź�         
            . base_ram_rwdata_io ( base_ram_data )                       //��д����           
   
   );
   

endmodule
