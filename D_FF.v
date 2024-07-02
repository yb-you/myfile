module D_FF(
	input wire D,
	input wire clk,
	output wire Q,
	output wire Q_bar
);

wire w1, w2, w3;

NOT	u0(w1, D);
AND	u1(w2, w1, clk);
AND	u2(w3, clk, D);
NOR	u3(Q, w2, Q_bar);
NOR	u4(Q_bar, Q, w3);


endmodule


module NOT(output wire o ,input wire a);
assign o = ~a;
endmodule


module AND(output wire o,input wire a, input wire b);
assign o = a&b;
endmodule

module OR(output wire o,input wire a, input wire b);
assign o = a|b;
endmodule

module NAND(output wire o, input wire a, input wire b);
assign o = ~(a&b);
endmodule

module NOR(output wire o, input wire a, input wire b);
assign o = ~(a|b);
endmodule

module XOR(output wire o, input wire a, input wire b);
assign o = a^b;
endmodule




module tb;

reg D;
reg clk;
wire Q;
wire Q_bar;

D_FF uu(.D(D), .clk(clk), .Q(Q), .Q_bar(Q_bar));


initial begin
	clk = 1'b0;
	forever #10 clk = ~clk;

end

initial begin
	D = 1'b0;
	#15
	D = 1'b1;
	#33
	D = 1'b0;
	#22
	D = 1'b1;
end

initial begin
	$monitor("Q = %b, Q_bar = %b", Q, Q_bar);
end

initial begin
	$dumpvars;

	#100
	$dumpflush;
	$finish;
end


endmodule
