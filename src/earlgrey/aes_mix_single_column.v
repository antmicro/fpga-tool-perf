module aes_mix_single_column (
	op_i,
	data_i,
	data_o
);
	input wire [0:0] op_i;
	input wire [31:0] data_i;
	output wire [31:0] data_o;
	function automatic [7:0] aes_mul2;
		input reg [7:0] in;
		begin
			aes_mul2[7] = in[6];
			aes_mul2[6] = in[5];
			aes_mul2[5] = in[4];
			aes_mul2[4] = in[3] ^ in[7];
			aes_mul2[3] = in[2] ^ in[7];
			aes_mul2[2] = in[1];
			aes_mul2[1] = in[0] ^ in[7];
			aes_mul2[0] = in[7];
		end
	endfunction
	function automatic [7:0] aes_mul4;
		input reg [7:0] in;
		aes_mul4 = aes_mul2(aes_mul2(in));
	endfunction
	function automatic [7:0] aes_div2;
		input reg [7:0] in;
		begin
			aes_div2[7] = in[0];
			aes_div2[6] = in[7];
			aes_div2[5] = in[6];
			aes_div2[4] = in[5];
			aes_div2[3] = in[4] ^ in[0];
			aes_div2[2] = in[3] ^ in[0];
			aes_div2[1] = in[2];
			aes_div2[0] = in[1] ^ in[0];
		end
	endfunction
	function automatic [31:0] aes_circ_byte_shift;
		input reg [31:0] in;
		input integer shift;
		integer s;
		begin
			s = shift % 4;
			aes_circ_byte_shift = {in[8 * ((7 - s) % 4)+:8], in[8 * ((6 - s) % 4)+:8], in[8 * ((5 - s) % 4)+:8], in[8 * ((4 - s) % 4)+:8]};
		end
	endfunction
	function automatic [127:0] aes_transpose;
		input reg [127:0] in;
		reg [127:0] transpose;
		begin
			transpose = 1'sb0;
			begin : sv2v_autoblock_146
				reg signed [31:0] j;
				for (j = 0; j < 4; j = j + 1)
					begin : sv2v_autoblock_147
						reg signed [31:0] i;
						for (i = 0; i < 4; i = i + 1)
							transpose[((i * 4) + j) * 8+:8] = in[((j * 4) + i) * 8+:8];
					end
			end
			aes_transpose = transpose;
		end
	endfunction
	function automatic [31:0] aes_col_get;
		input reg [127:0] in;
		input reg signed [31:0] idx;
		begin : sv2v_autoblock_148
			reg signed [31:0] i;
			for (i = 0; i < 4; i = i + 1)
				aes_col_get[i * 8+:8] = in[((i * 4) + idx) * 8+:8];
		end
	endfunction
	function automatic [7:0] aes_mvm;
		input reg [7:0] vec_b;
		input reg [63:0] mat_a;
		reg [7:0] vec_c;
		begin
			vec_c = 1'sb0;
			begin : sv2v_autoblock_149
				reg signed [31:0] i;
				for (i = 0; i < 8; i = i + 1)
					begin : sv2v_autoblock_150
						reg signed [31:0] j;
						for (j = 0; j < 8; j = j + 1)
							vec_c[i] = vec_c[i] ^ (mat_a[((7 - j) * 8) + i] & vec_b[7 - j]);
					end
			end
			aes_mvm = vec_c;
		end
	endfunction
	localparam [0:0] ADD_SI_ZERO = 0;
	localparam [0:0] DIP_DATA_IN = 0;
	localparam [0:0] KEY_DEC_EXPAND = 0;
	localparam [0:0] KEY_INIT_INPUT = 0;
	localparam [0:0] ROUND_KEY_DIRECT = 0;
	localparam [0:0] SI_ZERO = 0;
	localparam [1:0] ADD_RK_INIT = 0;
	localparam [1:0] KEY_FULL_ENC_INIT = 0;
	localparam [1:0] KEY_WORDS_0123 = 0;
	localparam [1:0] STATE_INIT = 0;
	localparam [2:0] ADD_SO_ZERO = 0;
	localparam [2:0] IV_INPUT = 0;
	localparam [0:0] ADD_SI_IV = 1;
	localparam [0:0] DIP_CLEAR = 1;
	localparam [0:0] KEY_DEC_CLEAR = 1;
	localparam [0:0] KEY_INIT_CLEAR = 1;
	localparam [0:0] ROUND_KEY_MIXED = 1;
	localparam [0:0] SI_DATA = 1;
	localparam [1:0] ADD_RK_ROUND = 1;
	localparam [1:0] KEY_FULL_DEC_INIT = 1;
	localparam [1:0] KEY_WORDS_2345 = 1;
	localparam [1:0] STATE_ROUND = 1;
	localparam [2:0] ADD_SO_IV = 1;
	localparam [2:0] IV_DATA_OUT = 1;
	localparam [0:0] AES_ENC = 1'b0;
	localparam [0:0] CIPH_FWD = 1'b0;
	localparam [0:0] AES_DEC = 1'b1;
	localparam [0:0] CIPH_INV = 1'b1;
	localparam [1:0] ADD_RK_FINAL = 2;
	localparam [1:0] KEY_FULL_ROUND = 2;
	localparam [1:0] KEY_WORDS_4567 = 2;
	localparam [1:0] STATE_CLEAR = 2;
	localparam [2:0] ADD_SO_DIP = 2;
	localparam [2:0] IV_DATA_IN_PREV = 2;
	localparam [1:0] KEY_FULL_CLEAR = 3;
	localparam [1:0] KEY_WORDS_ZERO = 3;
	localparam [2:0] IV_CTR = 3;
	localparam [2:0] AES_128 = 3'b001;
	localparam [2:0] AES_ECB = 3'b001;
	localparam [2:0] AES_192 = 3'b010;
	localparam [2:0] AES_CBC = 3'b010;
	localparam [2:0] AES_256 = 3'b100;
	localparam [2:0] AES_CTR = 3'b100;
	localparam [2:0] IV_CLEAR = 4;
	wire [31:0] x;
	wire [15:0] y;
	wire [15:0] z;
	wire [31:0] x_mul2;
	wire [15:0] y_pre_mul4;
	wire [7:0] y2;
	wire [7:0] y2_pre_mul2;
	wire [15:0] z_muxed;
	assign x[0+:8] = data_i[0+:8] ^ data_i[24+:8];
	assign x[8+:8] = data_i[24+:8] ^ data_i[16+:8];
	assign x[16+:8] = data_i[16+:8] ^ data_i[8+:8];
	assign x[24+:8] = data_i[8+:8] ^ data_i[0+:8];
	generate
		genvar i;
		for (i = 0; i < 4; i = i + 1) begin : gen_x_mul2
			assign x_mul2[i * 8+:8] = aes_mul2(x[i * 8+:8]);
		end
	endgenerate
	assign y_pre_mul4[0+:8] = data_i[24+:8] ^ data_i[8+:8];
	assign y_pre_mul4[8+:8] = data_i[16+:8] ^ data_i[0+:8];
	generate
		for (i = 0; i < 2; i = i + 1) begin : gen_mul4
			assign y[i * 8+:8] = aes_mul4(y_pre_mul4[i * 8+:8]);
		end
	endgenerate
	assign y2_pre_mul2 = y[0+:8] ^ y[8+:8];
	assign y2 = aes_mul2(y2_pre_mul2);
	assign z[0+:8] = y2 ^ y[0+:8];
	assign z[8+:8] = y2 ^ y[8+:8];
	assign z_muxed[0+:8] = (op_i == CIPH_FWD ? 8'b0 : z[0+:8]);
	assign z_muxed[8+:8] = (op_i == CIPH_FWD ? 8'b0 : z[8+:8]);
	assign data_o[0+:8] = ((data_i[8+:8] ^ x_mul2[24+:8]) ^ x[8+:8]) ^ z_muxed[8+:8];
	assign data_o[8+:8] = ((data_i[0+:8] ^ x_mul2[16+:8]) ^ x[8+:8]) ^ z_muxed[0+:8];
	assign data_o[16+:8] = ((data_i[24+:8] ^ x_mul2[8+:8]) ^ x[24+:8]) ^ z_muxed[8+:8];
	assign data_o[24+:8] = ((data_i[16+:8] ^ x_mul2[0+:8]) ^ x[24+:8]) ^ z_muxed[0+:8];
endmodule
