module mips_collec();

`include "alu.v"
`include "jump.v"
`include "data_mem.v"
`include "myinverter.v"
`include "programCoun.v"
`include "alu_control.v"
`include "control_unit.v"
`include "configuration.v"
`include "register_file2.v"
`include "inst_modulated.v"


reg reset,clk;
//pc&inst
wire [31:0]pc_reg,instruction;
wire [1:0]flag;
//instruction line
wire [4:0]RS,RT,RD,shamt;
wire [15:0]immediate_16;
wire [25:0]jump_26;
wire [5:0]opcode,funct;
//3bas:)
wire [31:0]jump_address;
//control
wire [1:0]ALUOp,MemtoReg,RegDst;
wire branch, jump,RegWrite,ALUSrc,MemRead,MemWrite;
//register file 
wire [31:0]data1,data2,writedata;
//alu control
wire [3:0] ALUCtl;
//alu
wire [31:0] ALUout;
wire zero;
//muxes
wire[4: 0] writeRegAdd;
wire[31:0] alu2ndoperand,data3;
//datamem
wire[31:0]read_data;

parameter raRegAdd =5'b11111;//return address reg
// modules
pc pc_mips(pc_reg,reset,flag,data3,jump_address,clk);
inst_modulated mips_mem(instruction,pc_reg);
//instruction_mem mips_mem (instruction,pc_reg,clk);
instruction_conf instruction_line(instruction,opcode,RS,RT,RD,shamt,funct,immediate_16,jump_26);
control_unit mips_control(jump,branch, RegDst ,RegWrite,ALUSrc,ALUOp,MemRead,MemWrite,MemtoReg,opcode,funct);
mux_3_5 mux1(writeRegAdd, RT,RD,raRegAdd,RegDst);
register reg_file (RS,RT,writeRegAdd,writedata,RegWrite,data1,data2,clk);
jump_branch control_branch (jump_address,flag,zero,branch,opcode,funct,jump,jump_26,data1);
alu_control alu_cont(ALUCtl,ALUOp,funct);
sign_extend extend (data3,instruction[15:0]);
muxMIPS2 mux2(alu2ndoperand, data2,data3,ALUSrc);
MIPSALU alu_mips (ALUCtl,data1,alu2ndoperand,shamt,ALUout,zero);
datamem memory (read_data,ALUout,data2,MemRead,MemWrite,clk );
mux_3_31 dataStoredInReg (writedata,ALUout,read_data,(pc_reg+1),MemtoReg);//for jal

always begin #5 clk=~clk; end
initial
begin
clk=1'b0;
reset=1'b1;

#5
reset=1'b0;

$monitor("aluctrl %b,aluout %b,memwrite is %b,memread is %b ,writedata is %b,readdata is %b ,value of pc is %b,and memetoreg is %b",ALUCtl,ALUout ,MemWrite,MemRead,writedata,read_data, pc_reg,MemtoReg); 
end
endmodule
