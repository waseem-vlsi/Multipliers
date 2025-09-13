
module carry_save_reduction_4bit_tb( );
reg [3:0]a0,a1,a2,a3;
wire [6:0]sum;
wire  c_final;

carry_save_reduction_4bit DUT(.a0(a0), .a1(a1), .a2(a2), .a3(a3), .sum(sum), .c_final(c_final));
initial 
begin 
a0 = 4'b1101; a1 = 4'b0000; a2 = 4'b0000; a3 = 4'b1101;
#5 $finish;
end
endmodule
