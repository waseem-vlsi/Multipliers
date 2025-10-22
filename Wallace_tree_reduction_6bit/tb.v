
module Carry_save_reduction_multiplier_6bit_tb();
reg [5:0]A,B;
reg CIN;
wire [15:0]sum;
wire carry;
wire [16:0]result;
Carry_save_reduction_multiplier_6bit DUT(.A(A), .B(B), .CIN(CIN), .sum(sum), .carry(carry), .result(result));
initial 
begin 
A = 6'd5; B = 6'd10; CIN = 1'b0;
#10 A = 6'd10; B = 6'd27; CIN = 1'b0;
#10 A = 6'd11; B = 6'd21; CIN = 1'b0;
#10 A = 6'd37; B = 6'b111111; CIN = 1'b0;
#10 A = 6'd27; B = 6'd46; CIN = 1'b0;
#10 $finish;
end 

initial
begin 
$display(" time = %0t | A = %d | B = %d", $time,A,B);
end

endmodule
