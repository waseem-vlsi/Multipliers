`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT JAMMU
// Engineer: WASEEM
// 
// Create Date: 13.09.2025 20:13:32
// Design Name: 
// Module Name: carry_save_reduction_4bit
// Project Name: MULTIPLIERS

//////////////////////////////////////////////////////////////////////////////////
// HA
module half_adder(
input a,b,
output c,s);
 assign c = a&b;
 assign s = a^b; 
endmodule

//FA
module full_adder(
input a,b,cin,
output c,s);
assign c = (a&b) | (b&cin) | (cin&a) ;
assign s = a^b^cin; 
endmodule



//CLA 
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

// MAIN MODULE
module carry_save_reduction_4bit(
input [3:0]a0,a1,a2,a3,
output [7:0]sum,
output c_final);
wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,c0;
wire [3:0]s0;
half_adder A1(.a(a0[1]), .b(a1[0]), .s(w1), .c(w2));
full_adder A2(.a(a0[2]), .b(a2[0]), .cin(a1[1]),.s(w3), .c(w4));
full_adder A3(.a(a0[3]), .b(a1[2]), .cin(a2[1]),.s(w5), .c(w6));
half_adder A4(.a(a1[3]), .b(a2[2]), .s(w7), .c(w8));

half_adder A5(.a(w2), .b(w3), .s(w10), .c(w9));
full_adder A6(.a(w4), .b(w5), .cin(a3[0]),.s(w12), .c(w11));
full_adder A7(.a(w6), .b(w7), .cin(a3[1]),.s(w13), .c(w14));
full_adder A8(.a(a2[3]), .b(w8), .cin(a3[2]),.s(w16), .c(w15));

CLA_4bit A9(.a({a3[3],w16,w13,w12}), .b({w15,w14,w11,w9}),.cin(1'b0), .sum(sum[6:3]), .cout(c_final));
assign sum[0] = a0[0];
assign sum[1] = w1;
assign sum[2] = w10;

endmodule
