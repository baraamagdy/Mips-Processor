module alu_control(alu_4_lines,alu_op,functField);
output reg  [3:0] alu_4_lines;
input  wire [1:0] alu_op;
input  wire [5:0] functField;

parameter add=2'b00;
parameter sub=2'b01;
parameter ori=2'b11;
parameter R_formate=2'b10;

always @(alu_op,functField)
begin
if(alu_op == add)
alu_4_lines<=4'b0010;

else if(alu_op == sub)
alu_4_lines<=4'b0011;

else if(alu_op == ori)//at8irt
alu_4_lines<=4'b0001;

else if(alu_op == R_formate)
begin
case(functField)
32:alu_4_lines<=4'b0010;//add
34:alu_4_lines<=4'b0011;//sub
36:alu_4_lines<=4'b0000;//and
39:alu_4_lines<=4'b0101;//nor
37:alu_4_lines<=4'b0001;//or
0 :alu_4_lines<=4'b0110;//sll
42:alu_4_lines<=4'b0100;//slt
3 :alu_4_lines<=4'b0111;//sra
2 :alu_4_lines<=4'b1000;//srl
38:alu_4_lines<=4'b1001;//xor
default :alu_4_lines<=4'bxxxx;
endcase
end
else
alu_4_lines<=4'bxxxx;
end
endmodule

module tb_aluControl();
wire [3:0] alu_4_lines;
reg  [1:0] alu_op;
reg  [5:0] functField;
alu_control mips_aluControl (alu_4_lines,alu_op,functField);
initial
begin
$monitor("four bit outed to alu %b",alu_4_lines);

alu_op=2'b00;
functField=2'bxx;
#4

alu_op=2'b00;
functField=2'b00;

end
endmodule