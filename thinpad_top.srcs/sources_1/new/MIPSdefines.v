`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/20 13:20:40
// Design Name: 
// Module Name: MIPSdefines
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


//全局使用的宏定义 
    `define ZeroWord32B 32'h0000_0000//32位0

//复位信号
    `define RstEnable 1'b0 //复位信号有效
    `define RstDisable 1'b1 //复位信号无效

//PC宽度 
    `define PCBus 31:0 //PC宽度
//指令宽度
    `define InstBus 31:0 //指令宽度
//指令OP长度 ，宽度
    `define InstOpLen       6 //指令Op长度
    `define InstOpBus       5:0 //指令Op宽度
    
//指令Func长度，宽度
    `define InstFuncLen      6//指令Func长度
    `define InstFuncBus      5:0 //指令Func宽度

//读写信号
    `define WriteEnable      1'b1 //写使能
    `define WriteDisable     1'b0 //写禁止
    
    `define ReadEnable       1'b1 //读使能信号
    `define ReadDisable      1'b0 //禁止读
    
    `define  MemEnable       1'b1
    `define  MemDisable      1'b0
//信号宽度 
    `define SignMaxLen        20//使用信号最大长度
    `define SignMaxBus        `SignMaxLen-1:0//使用信号的最大位宽
    
    
    `define SignUseLen       18//信号实际使用长度
    `define SignUseBus       `SignUseLen-1:0//信号实际使用宽度
    
    
    `define SignLen          28//信号实际使用长度
    `define SignBus        `SignLen-1:0//信号实际使用宽度
//暂停流水
    `define StopLen         6
    `define StopBus         `StopLen-1:0
    `define StopEnable      1'b1
    `define StopDisable     1'b0
   

//寄存器组宏定义 
    `define RegsAddrLen 5
    `define RegsAddrBus `RegsAddrLen-1:0 //寄存器组访问地址宽度
    
    `define RegsDataBus 31:0 //寄存器组数据宽度
    `define RegsNum 32 //寄存器组寄存器个数
    `define RegsNumLog2  5 //寻址通用寄存器使用的地址长度
//存储器宏定义
    `define MemAddrLen 32
    `define MemAddrBus `MemAddrLen-1:0
    `define MemDataBus 31:0

//ALU 
    `define AluOpLen 4 //运算器运算类型控制长度
    `define AluOpBus `AluOpLen-1:0 //运算器运算类型控制长度
    
    `define AluShmatBus 4:0
    `define AluShmatLen 5
    
    `define AluOperBus 31:0 //运算器参与运算的数的宽度
    
//ALU操作码 
     //移位运算ALU操作码
        `define SllAluOp       `AluOpLen'd0//逻辑左运算
        `define SrlAluOp       `AluOpLen'd1//逻辑右运算
        `define SraAluOp       `AluOpLen'd2//算术右运算
     //算术运算ALU操作码
        `define AddAluOp       `AluOpLen'd3//加法
        `define SubAluOp       `AluOpLen'd4//减法
     //逻辑运算ALU操作码
        `define AndAluOp        `AluOpLen'd5//按位与
        `define OrAluOp         `AluOpLen'd6//按位或
        `define XorAluOp        `AluOpLen'd7//按位异或
        `define NorAluOp        `AluOpLen'd8//按位或非
        `define SltAluOp        `AluOpLen'd9//有符号比较
        `define SltuAluOp       `AluOpLen'd10//无符号比较
        `define LuiAluOp        `AluOpLen'd11//无符号比较
      //
       `define MulAluOp         `AluOpLen'd12//乘法
        `define DivAluOp        `AluOpLen'd4//除法
        `define AdduAluOp       `AluOpLen'd3//无符号加
        `define NoAluOp         `AluOpLen'd13//误操作
        
   
      
       

//指令 
    //R指令 
        `define RInstOp                  `InstOpLen'b00_0000 //R型指令Op
    //逻辑运算
        //R指令
            `define AndInstFunc           `InstFuncLen'b10_0100
            `define OrInstFunc            `InstFuncLen'b10_0101
            `define XorInstFunc           `InstFuncLen'b10_0110
            
        //I指令
            `define AndiInstOp            `InstOpLen'b00_1100
            `define OriInstOp             `InstOpLen'b00_1101
            `define XoriInstOp            `InstOpLen'b00_1110
            `define LuiInstOp             `InstOpLen'b00_1111
    
    //移位指令
        //R指令
            `define SllInstFunc            `InstFuncLen'b00_0000
            `define SrlInstFunc            `InstFuncLen'b00_0010
            `define SraInstFunc            `InstFuncLen'b00_0011
            `define SllvInstFunc           `InstFuncLen'b00_0100
            `define SrlvInstFunc           `InstFuncLen'b00_0110
            `define SravInstFunc           `InstFuncLen'b00_0111
    
    //简单算术指令
        //R指令 
            `define AddInstFunc           `InstFuncLen'b10_0000
            `define AdduInstFunc           `InstFuncLen'b10_0001
            `define SubInstFunc            `InstFuncLen'b10_0010
            `define SltInstFunc            `InstFuncLen'b10_1010
        //I指令
            `define AddiInstOp             `InstOpLen'b00_1000
            `define AddiuInstOp            `InstOpLen'b00_1001
    //复杂指令 
        //乘法指令 
            `define MulInstOp               `InstOpLen'b01_1100
            `define MulInstFunc             `InstFuncLen'b00_0010
    //跳转指令 
        //R指令
             `define JrInstFunc             `InstFuncLen'b00_1000
             `define JalrInstFunc           `InstFuncLen'b00_1001
        //J指令
             `define JInstOp                `InstFuncLen'b00_0010
             `define JalInstOp              `InstFuncLen'b00_0011
      //分支指令
        //I指令
             `define BeqInstOp               `InstOpLen'b00_0100
             `define BneInstOp               `InstOpLen'b00_0101
             `define BgtzInstOp              `InstOpLen'b00_0111
             `define BlezInstOp              `InstOpLen'b00_0110
            //同OP的BZ类跳转指令
                `define BzInstOp             `InstOpLen'b00_0001
            
      //存储指令
        //I指令 
            `define SbInstOp                 `InstOpLen'b10_1000
            `define SwInstOp                 `InstOpLen'b10_1011
     //加载指令 
        //I指令 
            `define LbInstOp                 `InstOpLen'b10_0000
            `define LwInstOp                 `InstOpLen'b10_0011
     //Syscall指令
            `define SysCallInstFunc          `InstOpLen'b00_1100
            
            
            
//控制信号
    //R指令 
        `define RInstSign                    `SignLen'h000_0300 //R型指令O
        `define RSInstSign                   `SignLen'h000_0301 //R型指令移位使用寄存器的值
    //逻辑运算
        `define ISInstSign                   `SignLen'h000_0106 //I型符号扩展              
        `define IZInstSign                   `SignLen'h000_0102  //I型0扩展   andi,ori,xori,lui  
    //复杂指令 
        //乘法指令 
            `define MulInstSign              `SignLen'h000_0300 //
    //跳转指令 
        //R指令 
             `define JrInstSign              `SignLen'h100_0000
             `define JalrInstSign            `SignLen'h100_1300
        //J指
            `define JInstSign                `SignLen'h200_0000
            `define JalInstSign              `SignLen'h200_1500
      //分支指
        //I指
            `define BeqInstSign              `SignLen'h001_0000
            `define BneInstSign              `SignLen'h002_0000
            //同OP的BZ类跳转指
                `define BzInstSign           `SignLen'h004_0000
            `define BgtzInstSign             `SignLen'h008_0000
            `define BlezInstSign             `SignLen'h010_0000
           
           
      //存储指
        //I指令
            `define SbInstSign               `SignLen'h000_0076
            `define SwInstSign               `SignLen'h000_0036
     //加载指令
        //I指令
            `define LbInstSign               `SignLen'h000_0956
            `define LwInstSign               `SignLen'h000_0916
     //Syscall指
            `define SysCallInstSign          `SignLen'h400_0000
           
  
