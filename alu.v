module MIPSALU (ALUCtl,A,B,shamt,ALUout,zero);
input [3:0] ALUCtl;
input [4:0] shamt;
input [31:0] A,B;
output reg [31:0] ALUout;
output zero;
assign zero=(ALUout==0);
always @(ALUCtl, A,B)
case (ALUCtl) 
4'b0000: ALUout<=A&B;
4'b0001: ALUout<=A|B;
4'b0010: ALUout<=A+B;
4'b0011: ALUout<=A-B;
4'b0100: ALUout<=A<B?1:0;//slt 
4'b0101: ALUout<=~(A|B);//nor
4'b0110: ALUout<=(B<<shamt);//sll
4'b0111: ALUout<=($signed(B) >>> shamt);//sra 
4'b1000: ALUout<=(B>>shamt);//srl
4'b1001: ALUout<=A^B;//xor
default: ALUout<={32{1'bx}};
endcase
endmodule

module alu_tb();
reg[3:0]ALUCtl;
reg[31:0]A,B;
reg[4:0]shamt;
wire[31:0]ALUout;
wire zero;
MIPSALU tb (ALUCtl,A,B,shamt,ALUout,zero);
initial 
begin
$monitor ("aluout is %b ",ALUout);
ALUCtl=4'b0111;
A=32'b11111111_11111111_00000111_11111111;
shamt=5'b00101;
#3
ALUCtl=4'b0101;
A=32'b00010000_11111111_00000111_11111111;
B=32'b11111111_00000111_11111111_11111111;
shamt=5'b00101;

#3
ALUCtl=4'b0100;
A=32'b00010000_11111111_00000111_11111111;
B=32'b11111111_00000111_11111111_11111111;

#3
ALUCtl=4'b1000;
A=32'b00010000_11111111_00000111_11111111;
B=32'b11111111_00000111_11111111_11111111;
shamt=5'b00101;

end
endmodule 