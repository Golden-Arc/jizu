`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/26 09:34:21
// Design Name: 
// Module Name: IM
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

module IM(
	input [31:0] address,//��ǰPC
	output [5:0] opcode,//������
	output [4:0] rs, //Դ�Ĵ���1
	output [4:0] rt, //Դ�Ĵ���2
	output [4:0] rd, //Ŀ�ļĴ���
	output [4:0] shamt,	//��λ��
	output [31:0] immediate, //������
	output [25:0] addr	//��ת��ַ
    );
	
	reg[7:0] mem[1023:0];//// 8λ����ָ��洢��Ԫ����1024��
	reg[31:0] instruction;
	integer i;
	initial 
	begin
	    for(i=0;i<1024;i=i+1) mem[i]=0;
        $readmemb("C:/vivado/one-cycle-cpu/instructions.txt", mem);
        instruction=0;
    end
	
	always@(*)
	begin
		instruction={mem[address],mem[address+1],mem[address+2],mem[address+3]};
	end	
	assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
	assign immediate[15:0]=instruction[15:0];
    assign immediate[31:16]=instruction[15]?16'hffff:16'h0000;
    assign shamt = instruction[10:6];
    assign addr = instruction[25:0];
endmodule
