/*				CPU				*/
module CPU(	//ALU + AU + RS + IB
	input wire clk
);

reg [9:0]PC;	//Program Counter
reg [15:0]AC;	//Accumulator
reg [9:0]MAR;	//Memory Adderss Register
reg [15:0]MDR;	//Memory Data Register
reg [15:0]IR;	//Instruction Register / [15:12]:op-code / [11:8]:address1 / [7:4]:address2  / [4:0]: 

reg [15:0]MM [1023:0]; //Main Memory(2^10 * 16bit)

initial begin
	PC = 10'b0;
/*		Main Memory		*/
//MM[0] = 16'b


/////////////////////////////////////////
end

always@ (posedge clk)begin 

/*		Fetch Cycle		*/
	MAR = PC;		//MAR <- PC
	MDR = MM[MAR];		//MDR <- M[MAR]
	PC = PC + 10'b1;	//PC <- PC + 1
	IR = MDR;		//IR <- MDR
//////////////////////////////////////////
//
	case (IR[15:12])	//CU.OP_CODE
		4'b0000: ; //NOP
		4'b0001: ; //LOAD
		4'b0010: ; //STORE
		4'b0011: ; //ADD
		4'b0100: ; //SUB
		4'b0101: ; //JUMP
	endcase
end


endmodule
/////////////////////////////////////////////////////////////////
/*
module ALU(

)

endmodule
*/

/*				CU				*/
module CU(
	input wire clk,
	input wire [3:0]OP_CODE	//CPU.IR[15:12]
	
);

reg [6:0]CAR;	//Contorl Address Register
reg [6:0]CBR;	//Contorll Buffer Register
reg [6:0]SBR;	//SuBroutine Register

reg [16:0]CM [127:0];	//Contorl Memory: ROM(2^7 * 17bit) / [16:14]:instruction1 / [13:11]:instruction2 / [10:9]: condition / [8:7]: branch / [6:0]: addressfield

reg [6:0]MAPPING_ADDR;


initial begin
/*		Mapping			*/
MAPPING_ADDR = {1'b1, OP_CODE, 2'b00};
/////////////////////////////////////////


/*		Control Memory		*/	//64~127: Excution Cycle
//Fetch subroutine
CM[0] = 17'b001_000_00_00_0000001;	//MAR <- PC
CM[1] = 17'b100_001_00_00_0000010;	//MDR <- [MAR], PC <- PC + 1
CM[2] = 17'b110_000_00_11_0000000;	//IR <- MDR

//Indirect subroutine
CM[4] = 17'b010_000_00_00_0000101;	//MAR <- IR(addr)
CM[5] = 17'b100_000_00_00_0000110;	//MDR <- M[MAR]
CM[6] = 17'b110_000_00_10_0000000;	//IR(addr) <- MDR


//NOP
CM[64] = 17'b000_001_00_00_0000000;	//PC <- PC+1

//LOAD
CM[68] = 17'b000_000_01_01_0000100;
CM[69] = 17'b010_000_00_00_1000110;	//MAR <- IR(Addr)
CM[70] = 17'b100_000_00_00_1000111;	//MDR <- M[MAR]
CM[71] = 17'b101_000_00_00_0000000;	//AC <- MDR

//STORE
CM[72] = 17'b000_000_01_01_0000100;
CM[73] = 17'b010_000_00_00_1001010;	//MAR <- IR(addr)
CM[74] = 17'b000_010_00_00_1001011;	//MDR <- AC
CM[75] = 17'b111_000_00_00_0000000;	//M[MAR] <- MDR

//ADD
CM[76] = 17'b010_000_00_00_1001101;	//MAR <- IR(addr)
CM[77] = 17'b100_000_00_00_1001110;	//MDR <- M[MAR]
CM[78] = 17'b011_000_00_00_0000000;	//AC <- AC + MDR

//SUB
CM[80] = 17'b010_000_00_00_1010001;	//MAR <- IR(addr)
CM[81] = 17'b100_000_00_00_1010010;	//MDR <- M[MAR]
CM[82] = 17'b000_110_00_00_0000000;	//AC <- AC - MDR

//JUMP
CM[84] = 17'b000_111_00_00_0000000;	//PC <- IR(addr)

/////////////////////////////////////////
end

wire [1:0]CD;
wire [1:0]BR;	//BR[1]=I0, BR[0]=I1
wire [6:0]ADF;

assign CD = CBR[10:9];
assign BR = CBR[8:7];
assign ADF = CBR[6:0];


/*		MUX2		*/
reg C;
always @(CD) begin
	case (CD)
		2'b00: C = 0;
		2'b01: C = 0;
		2'b10: C = 0;
		2'b11: C = 0;
	endcase
end
////////////////////////////////

/*		MUX1_sel		*/
wire S1;
wire S0;
wire L;

assign S1 = BR[0];
assign S0 = ((~BR[0])&C) | (BR[1]&BR[0]);
assign L = (~BR[0])&BR[1]&C;
/////////////////////////////////////////

/*		MUX1		*/
always @(S1, S0) begin
	case({S1,S0})
		2'b00: CAR = CAR + 1'b1;
		2'b01: CAR = ADF;
		2'b10: CAR = SBR;
		2'b11: CAR = MAPPING_ADDR;
	endcase
end
//////////////////////////////////

/*		SBR		*/
always @(L) begin
	SBR = CAR + 1'b1;
end

////////////////////////////////

endmodule

///////////////////////////////////////////////////////////////////////////////



