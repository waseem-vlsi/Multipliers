
module Wallace_tree_reduction_6bit_tb();
reg [5:0]A,B;
reg CIN;
wire [15:0]sum;
wire carry;
wire [16:0]result;
Wallace_tree_reduction_6bit dut(.A(A), .B(B), .CIN(CIN), .sum(sum), .carry(carry), .result(result));
initial 
begin 
A = 6'd27; B = 6'd46; CIN = 1'b0;
#10 A = 6'd27; B = 6'd10; CIN = 1'b0;
#10 $finish;
end
initial 
begin 
$display("$time = %0d | A = %d | B = %d", $time, A,B);
end
endmodule
