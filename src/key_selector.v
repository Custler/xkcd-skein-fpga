`timescale 1ns / 1ps

module key_selector (
	input mode_i,
	input [1023:0] key_i,
	
	output [1023:0] key_o
    );

reg [1023:0] key;

assign key_o = key;

always @(*) begin
	if (mode_i) // Output Mode
	begin
		key[1023:0] = key_i[1023:0];
	end else begin // Message Mode
		key[63:0] =     64'hD593DA0741E72355;
		key[127:64] =   64'h15B5E511AC73E00C;
		key[191:128] =  64'h5180E5AEBAF2C4F0;
		key[255:192] =  64'h03BD41D3FCBCAFAF;
		key[319:256] =  64'h1CAEC6FD1983A898;
		key[383:320] =  64'h6E510B8BCDD0589F;
		key[447:384] =  64'h77E2BDFDC6394ADA;
		key[511:448] =  64'hC11E1DB524DCB0A3;
		key[575:512] =  64'hD6D14AF9C6329AB5;
		key[639:576] =  64'h6A9B0BFC6EB67E0D;
		key[703:640] =  64'h9243C60DCCFF1332;
		key[767:704] =  64'h1A1F1DDE743F02D4;
		key[831:768] =  64'h0996753C10ED0BB8;
		key[895:832] =  64'h6572DD22F2B4969A;
		key[959:896] =  64'h61FD3062D00A579A;
		key[1023:960] = 64'h1DE0536E8682E539;
	end
end

endmodule
