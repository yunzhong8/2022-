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


//ȫ��ʹ�õĺ궨�� 
    `define ZeroWord32B 32'h0000_0000//32λ0

//��λ�ź�
    `define RstEnable 1'b0 //��λ�ź���Ч
    `define RstDisable 1'b1 //��λ�ź���Ч

//PC��� 
    `define PCBus 31:0 //PC���
//ָ����
    `define InstBus 31:0 //ָ����
//ָ��OP���� �����
    `define InstOpLen       6 //ָ��Op����
    `define InstOpBus       5:0 //ָ��Op���
    
//ָ��Func���ȣ����
    `define InstFuncLen      6//ָ��Func����
    `define InstFuncBus      5:0 //ָ��Func���

//��д�ź�
    `define WriteEnable      1'b1 //дʹ��
    `define WriteDisable     1'b0 //д��ֹ
    
    `define ReadEnable       1'b1 //��ʹ���ź�
    `define ReadDisable      1'b0 //��ֹ��
    
    `define  MemEnable       1'b1
    `define  MemDisable      1'b0
//�źſ�� 
    `define SignMaxLen        20//ʹ���ź���󳤶�
    `define SignMaxBus        `SignMaxLen-1:0//ʹ���źŵ����λ��
    
    
    `define SignUseLen       18//�ź�ʵ��ʹ�ó���
    `define SignUseBus       `SignUseLen-1:0//�ź�ʵ��ʹ�ÿ��
    
    
    `define SignLen          28//�ź�ʵ��ʹ�ó���
    `define SignBus        `SignLen-1:0//�ź�ʵ��ʹ�ÿ��
//��ͣ��ˮ
    `define StopLen         6
    `define StopBus         `StopLen-1:0
    `define StopEnable      1'b1
    `define StopDisable     1'b0
   

//�Ĵ�����궨�� 
    `define RegsAddrLen 5
    `define RegsAddrBus `RegsAddrLen-1:0 //�Ĵ�������ʵ�ַ���
    
    `define RegsDataBus 31:0 //�Ĵ��������ݿ��
    `define RegsNum 32 //�Ĵ�����Ĵ�������
    `define RegsNumLog2  5 //Ѱַͨ�üĴ���ʹ�õĵ�ַ����
//�洢���궨��
    `define MemAddrLen 32
    `define MemAddrBus `MemAddrLen-1:0
    `define MemDataBus 31:0

//ALU 
    `define AluOpLen 4 //�������������Ϳ��Ƴ���
    `define AluOpBus `AluOpLen-1:0 //�������������Ϳ��Ƴ���
    
    `define AluShmatBus 4:0
    `define AluShmatLen 5
    
    `define AluOperBus 31:0 //������������������Ŀ��
    
//ALU������ 
     //��λ����ALU������
        `define SllAluOp       `AluOpLen'd0//�߼�������
        `define SrlAluOp       `AluOpLen'd1//�߼�������
        `define SraAluOp       `AluOpLen'd2//����������
     //��������ALU������
        `define AddAluOp       `AluOpLen'd3//�ӷ�
        `define SubAluOp       `AluOpLen'd4//����
     //�߼�����ALU������
        `define AndAluOp        `AluOpLen'd5//��λ��
        `define OrAluOp         `AluOpLen'd6//��λ��
        `define XorAluOp        `AluOpLen'd7//��λ���
        `define NorAluOp        `AluOpLen'd8//��λ���
        `define SltAluOp        `AluOpLen'd9//�з��űȽ�
        `define SltuAluOp       `AluOpLen'd10//�޷��űȽ�
        `define LuiAluOp        `AluOpLen'd11//�޷��űȽ�
      //
       `define MulAluOp         `AluOpLen'd12//�˷�
        `define DivAluOp        `AluOpLen'd4//����
        `define AdduAluOp       `AluOpLen'd3//�޷��ż�
        `define NoAluOp         `AluOpLen'd13//�����
        
   
      
       

//ָ�� 
    //Rָ�� 
        `define RInstOp                  `InstOpLen'b00_0000 //R��ָ��Op
    //�߼�����
        //Rָ��
            `define AndInstFunc           `InstFuncLen'b10_0100
            `define OrInstFunc            `InstFuncLen'b10_0101
            `define XorInstFunc           `InstFuncLen'b10_0110
            
        //Iָ��
            `define AndiInstOp            `InstOpLen'b00_1100
            `define OriInstOp             `InstOpLen'b00_1101
            `define XoriInstOp            `InstOpLen'b00_1110
            `define LuiInstOp             `InstOpLen'b00_1111
    
    //��λָ��
        //Rָ��
            `define SllInstFunc            `InstFuncLen'b00_0000
            `define SrlInstFunc            `InstFuncLen'b00_0010
            `define SraInstFunc            `InstFuncLen'b00_0011
            `define SllvInstFunc           `InstFuncLen'b00_0100
            `define SrlvInstFunc           `InstFuncLen'b00_0110
            `define SravInstFunc           `InstFuncLen'b00_0111
    
    //������ָ��
        //Rָ�� 
            `define AddInstFunc           `InstFuncLen'b10_0000
            `define AdduInstFunc           `InstFuncLen'b10_0001
            `define SubInstFunc            `InstFuncLen'b10_0010
            `define SltInstFunc            `InstFuncLen'b10_1010
        //Iָ��
            `define AddiInstOp             `InstOpLen'b00_1000
            `define AddiuInstOp            `InstOpLen'b00_1001
    //����ָ�� 
        //�˷�ָ�� 
            `define MulInstOp               `InstOpLen'b01_1100
            `define MulInstFunc             `InstFuncLen'b00_0010
    //��תָ�� 
        //Rָ��
             `define JrInstFunc             `InstFuncLen'b00_1000
             `define JalrInstFunc           `InstFuncLen'b00_1001
        //Jָ��
             `define JInstOp                `InstFuncLen'b00_0010
             `define JalInstOp              `InstFuncLen'b00_0011
      //��ָ֧��
        //Iָ��
             `define BeqInstOp               `InstOpLen'b00_0100
             `define BneInstOp               `InstOpLen'b00_0101
             `define BgtzInstOp              `InstOpLen'b00_0111
             `define BlezInstOp              `InstOpLen'b00_0110
            //ͬOP��BZ����תָ��
                `define BzInstOp             `InstOpLen'b00_0001
            
      //�洢ָ��
        //Iָ�� 
            `define SbInstOp                 `InstOpLen'b10_1000
            `define SwInstOp                 `InstOpLen'b10_1011
     //����ָ�� 
        //Iָ�� 
            `define LbInstOp                 `InstOpLen'b10_0000
            `define LwInstOp                 `InstOpLen'b10_0011
     //Syscallָ��
            `define SysCallInstFunc          `InstOpLen'b00_1100
            
            
            
//�����ź�
    //Rָ�� 
        `define RInstSign                    `SignLen'h000_0300 //R��ָ��O
        `define RSInstSign                   `SignLen'h000_0301 //R��ָ����λʹ�üĴ�����ֵ
    //�߼�����
        `define ISInstSign                   `SignLen'h000_0106 //I�ͷ�����չ              
        `define IZInstSign                   `SignLen'h000_0102  //I��0��չ   andi,ori,xori,lui  
    //����ָ�� 
        //�˷�ָ�� 
            `define MulInstSign              `SignLen'h000_0300 //
    //��תָ�� 
        //Rָ�� 
             `define JrInstSign              `SignLen'h100_0000
             `define JalrInstSign            `SignLen'h100_1300
        //Jָ
            `define JInstSign                `SignLen'h200_0000
            `define JalInstSign              `SignLen'h200_1500
      //��ָ֧
        //Iָ
            `define BeqInstSign              `SignLen'h001_0000
            `define BneInstSign              `SignLen'h002_0000
            //ͬOP��BZ����תָ
                `define BzInstSign           `SignLen'h004_0000
            `define BgtzInstSign             `SignLen'h008_0000
            `define BlezInstSign             `SignLen'h010_0000
           
           
      //�洢ָ
        //Iָ��
            `define SbInstSign               `SignLen'h000_0076
            `define SwInstSign               `SignLen'h000_0036
     //����ָ��
        //Iָ��
            `define LbInstSign               `SignLen'h000_0956
            `define LwInstSign               `SignLen'h000_0916
     //Syscallָ
            `define SysCallInstSign          `SignLen'h400_0000
           
  
