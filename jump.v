module jump_branch (jump_address,flag,zero,branch,opcode,funct,jump,jump_26,data1);

output reg [31:0]jump_address;
output reg [1:0] flag;
input wire [31:0]data1; //for jr 
input wire [5:0] opcode,funct;
input wire [25:0]jump_26;
input wire jump,zero,branch;

parameter op_bne=6'b000101;
parameter op_beq=6'b000100;
parameter op_jr =6'b000000;//at8irt
parameter jr_funct=6'b001000;

always @(zero,branch,opcode,jump,jump_26,funct,data1)
begin
if(jump == 1'b1)
begin
flag<=2'b10;
jump_address<={6'b000000,jump_26};
end 
else if ((zero==1'b1)&&(branch==1'b1)&&(opcode==op_beq))
begin
flag<=2'b00;
jump_address<={32{1'bx}};
end
else if (zero==1'b0&&branch==1'b1&&opcode==op_bne)
begin
flag<=2'b01;
jump_address<={32{1'bx}};
end
//jr
else if ((opcode==op_jr)&&(funct==jr_funct))
begin
flag<=2'b11; 
jump_address<=data1;
end
else 
begin
flag<=2'bxx;
jump_address<={32{1'bx}};
end 
end
endmodule 



module jump_tb();

wire  [31:0]jump_address;
wire [1:0] flag;
reg  [31:0]data1; //for jr 
reg [5:0] opcode,funct;
reg [25:0]jump_26;
reg jump,zero,branch;
 jump_branch jump_mips (jump_address,flag,zero,branch,opcode,funct,jump,jump_26,data1);
initial
begin
$monitor("address is %b, and flag is %b ",jump_address,flag);
opcode =6'b000011;
jump=1'b1;
jump_26={26{1'b1}};

#4
jump=1'b0;
#3
jump=1'b1;
jump_26=32'b11111111_00000000_11111111_10101010;
end
endmodule 