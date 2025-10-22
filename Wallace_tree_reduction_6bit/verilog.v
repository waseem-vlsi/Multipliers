// PP_GEN
module PP_gen #(
parameter N = 5 )
(
input [N:0]A,B,
output  [((N+1)*(N+1))-1:0]Y );

genvar i,j;
generate
for(i = 0; i<(N+1); i =  i+1)
begin
for(j = 0; j<(N+1); j =  j+1)
begin
 assign Y[(i*(N+1)) + j] = A[i] & B[j];
end
end
endgenerate
endmodule


//FULL ADDER

module full_adder(
input a,b,c,
output sum,carry);
assign sum = a^b^c;
assign carry = (a&b) | (b&c) | (c&a);
endmodule


// HALF ADDER

module Half_Adder(
    input a, b,
    output SUM, CARRY
);
    assign SUM  = a ^ b;
    assign CARRY = a & b;
endmodule

// 16 BIT CSA
module mux_2x1(a,b,sel,y);
input [4:0]a,b;
input sel;
output reg [4:0] y;
always@(*)
begin 
case(sel)
1'b0: y = a;
1'b1: y = b;
endcase
end
endmodule

module adder(
input a,b,c,
output p,g,s);
 assign g = a&b;
 assign p = a^b;
 assign s = a^b^c; 
endmodule
module carry_gen(
input [3:0]p,g,
input cin,
output cout,P0,G0,
output c1,c2,c3,c4);
assign c1 = g[0]|(p[0]&cin), c2 = g[1]|(p[1]&g[0])|(p[1]&p[0]&cin) , c3 = g[2]| (p[2]&g[1])|(p[2]&p[1]&g[0])|(p[2]&p[1]&p[0]&cin),  c4 = g[3]|(p[3]&g[2])| (p[3]&g[2]&g[1])|(p[3]&p[2]&p[1]&g[0])|(p[3]&p[2]&p[1]&p[0]&cin);
assign P0 = p[3] & p[2] & p[1] & p[0], G0 = g[3] | (p[3] &g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]); 
assign cout = c4;
endmodule

module CLA_4bit(
input [3:0]a,b,
input cin,
output [3:0]sum,
output cout);
wire [3:0]p,g;
wire c1,c2,c3,c4,P0,G0;
adder A1(.a(a[0]), .b(b[0]), .s(sum[0]),.p(p[0]), .g(g[0]), .c(cin));
adder A2(.a(a[1]), .b(b[1]), .s(sum[1]),.p(p[1]), .g(g[1]), .c(c1));
adder A3(.a(a[2]), .b(b[2]), .s(sum[2]),.p(p[2]), .g(g[2]), .c(c2));
adder A4(.a(a[3]), .b(b[3]), .s(sum[3]),.p(p[3]), .g(g[3]),.c(c3));
carry_gen A5(.p(p), .g(g), .c1(c1), .c2(c2),.c3(c3), .c4(cout), .P0(P0), .G0(G0), .cin(cin));
endmodule

module Block1(
    input  [3:0] A, B,
    input  cin,
    output [4:0] w1);   // combined {cout,sum}
    wire W1, W2;
    wire [3:0] SUM0, SUM1;
    CLA_4bit D1(.a(A), .b(B), .sum(SUM0), .cout(W1), .cin(1'b0));
    CLA_4bit D2(.a(A), .b(B), .sum(SUM1), .cout(W2), .cin(1'b1));
    mux_2x1 D3(.a({W1, SUM0}), .b({W2, SUM1}), .sel(cin), .y(w1));  
endmodule


module CSA_16Bit(
input [15:0]X,Y,
input CIN,
output [15:0]S,
output COUT);
wire W1,W2,W3,W4;
Block1 Z1(.A(X[3:0]), .B(Y[3:0]), .cin(CIN), .w1({W1, S[3:0]}));
Block1 Z2(.A(X[7:4]), .B(Y[7:4]), .cin(W1), .w1({W2, S[7:4]}));
Block1 Z3(.A(X[11:8]), .B(Y[11:8]), .cin(W2), .w1({W3, S[11:8]}));
Block1 Z4(.A(X[15:12]), .B(Y[15:12]), .cin(W3), .w1({COUT, S[15:12]}));
endmodule

// MAIN MODULE


module Wallace_tree_reduction_6bit(
input [5:0]A,B,
input CIN,
output [15:0]sum,
output carry,
output [16:0]result);
wire S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,S21,S22,S23,S24,S25;
wire C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C20,C21,C22,C23,C24,C25;
wire [35:0]Y;
PP_gen # (.N(5)) p0(.A(A), .B(B), .Y(Y));

// LEVEL - 1
Half_Adder a0(.a(Y[1]), .b(Y[6]), .SUM(S0), .CARRY(C0));
full_adder a1(.a(Y[2]), .b(Y[7]), .c(Y[12]), .sum(S1), .carry(C1));
full_adder a2(.a(Y[3]), .b(Y[8]), .c(Y[13]), .sum(S2), .carry(C2));
full_adder a3(.a(Y[4]), .b(Y[9]), .c(Y[14]), .sum(S3), .carry(C3));
full_adder a4(.a(Y[5]), .b(Y[10]), .c(Y[15]), .sum(S4), .carry(C4));
Half_Adder a5(.a(Y[11]), .b(Y[16]), .SUM(S5), .CARRY(C5));
Half_Adder a6(.a(Y[19]), .b(Y[24]), .SUM(S6), .CARRY(C6));
full_adder a7(.a(Y[20]), .b(Y[25]), .c(Y[30]), .sum(S7), .carry(C7));
full_adder a8(.a(Y[21]), .b(Y[26]), .c(Y[31]), .sum(S8), .carry(C8));
full_adder a9(.a(Y[22]), .b(Y[27]), .c(Y[32]), .sum(S9), .carry(C9));
full_adder a10(.a(Y[23]), .b(Y[28]), .c(Y[33]), .sum(S10), .carry(C10));
Half_Adder a11(.a(Y[29]), .b(Y[34]), .SUM(S11), .CARRY(C11));

// LEVEL - 2
Half_Adder a12(.a(C0), .b(S1), .SUM(S12), .CARRY(C12));
full_adder a13(.a(C1), .b(S2), .c(Y[18]), .sum(S13), .carry(C13));
full_adder a14(.a(C2), .b(S3), .c(S6), .sum(S14), .carry(C14));
full_adder a15(.a(C3), .b(S4), .c(S7), .sum(S15), .carry(C15));
full_adder a16(.a(C4), .b(S5), .c(S8), .sum(S16), .carry(C16));
full_adder a17(.a(C5), .b(S9), .c(Y[17]), .sum(S17), .carry(C17));

//LEVEL - 3
 Half_Adder a18(.a(C12), .b(S13), .SUM(S18), .CARRY(C18));
 Half_Adder a19(.a(C13), .b(S14), .SUM(S19), .CARRY(C19));
 full_adder a20(.a(C14), .b(S15), .c(C6), .sum(S20), .carry(C20));
 full_adder a21(.a(C15), .b(S16), .c(C7), .sum(S21), .carry(C21));
 full_adder a22(.a(C16), .b(S17), .c(C8), .sum(S22), .carry(C22));
 full_adder a23(.a(C17), .b(S10), .c(C9), .sum(S23), .carry(C23));
 Half_Adder a24(.a(C10), .b(S11), .SUM(S24), .CARRY(C24));
 Half_Adder a25(.a(C11), .b(Y[35]), .SUM(S25), .CARRY(C25));
 
 
 CSA_16Bit a26(.X({4'b0000,C25,C24,C23,C22,C21,C20,C19,C18,4'b0000}), .Y({5'b00000,S25,S24,S23,S22,S21,S20,S19,S18,S12,S0,Y[0]}), .CIN(CIN), .S(sum), .COUT(carry));
 assign result = {carry,sum};

endmodule


