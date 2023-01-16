`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/28 00:35:54
// Design Name: 
// Module Name: Ctrl
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

module Ctrl(
input wire                rst              ,
input wire                clk              ,
input wire                stop_from_id_i   ,
input wire                stop_from_exe_i  ,
input wire                stop_from_mem_i  ,
input wire                stop_from_wb_i   ,
output reg [`StopBus]     stop_o

    );
    reg[3:0] mem_time ;
// always@(negedge clk) begin
//     if(rst==`RstEnable)begin
//        stop_o<=6'b00_0000;
//        mem_time<=1'b0;
//     end if( stop_from_id_i == `StopEnable) begin
//            stop_o<=6'b00_0111;
//     end else if(stop_from_exe_i == `StopEnable)begin
//            stop_o<= 6'b00_1111;
//     end else if(stop_from_wb_i == `StopEnable)begin
//            if(mem_time==1'b0)begin
//                stop_o<= 6'b11_1111;
//                mem_time<=mem_time+1'b1;
//            end else begin
//                stop_o<=6'b00_0000;
//                mem_time<=mem_time+1'b1;
//            end
//     end else begin
//            stop_o<=6'b00_0000;
//     end
//  end
        
//always@(negedge clk) begin
//     if(rst==`RstEnable)begin
//        stop_o<=6'b00_0000;
//        mem_time<=4'b0000;
//     end if( stop_from_id_i == `StopEnable) begin
//            stop_o<=6'b00_0011;
//            mem_time<=4'b0001; 
//     end else begin
//        case(mem_time)
//            4'b0001:begin
//                mem_time<=4'b0010;
//                stop_o<=6'b00_0011;
//             end
//             4'b0010:begin
//                mem_time<=4'b0100;
//                stop_o<=6'b00_0011;
//             end
//            4'b0100:begin
//                mem_time<=4'b1000;
//                stop_o<=6'b00_0011;
//             end
//            4'b1000:begin
//                mem_time<=4'b0000;
//                stop_o<=6'b00_0000;
//             end
//            default:begin
//                mem_time<=4'b0000;
//                stop_o<=6'b00_0000;
//            end
//         endcase
//      end
//  end
    always@(negedge clk) begin
//    always@(*) begin
        if(rst==`RstEnable)begin
            stop_o<=6'b00_0000;
        end else if (stop_from_mem_i)begin
            stop_o<=6'b00_1111;//if,id£¬exeÔÝÍ££¬memÖ´ÐÐ0000_0000
        end else if (stop_from_exe_i)begin
            stop_o<=6'b00_0111;//if,id,ÔÝÍ££¬exeÖ´ÐÐ0000_0000
        end else begin
            stop_o<=6'b00_0000;
        end
  end
endmodule
