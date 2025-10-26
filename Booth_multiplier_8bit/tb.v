
module Booth_multiplier_8bit_tb();
reg [7:0]A,B;
reg CIN;
wire [15:0]S111;
Booth_multiplier_8bit dut(.A(A), .B(B), .CIN(CIN), .S111(S111));
initial 
begin 
A = 8'd5; B = 8'd10; CIN = 1'b0;
#10 A = -8'd5; B = -8'd1; CIN = 1'b0;
#10 A = -8'd5; B = 8'd10; CIN = 1'b0;
#10 A = 8'd5; B = -8'd10; CIN = 1'b0;

#10 $finish;
end  
endmodule
