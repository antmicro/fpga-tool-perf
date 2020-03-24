module aes_ctr (
	clk_i,
	rst_ni,
	incr_i,
	ready_o,
	ctr_i,
	ctr_o,
	ctr_we_o
);
	localparam [0:0] IDLE = 0;
	localparam [0:0] INCR = 1;
	input wire clk_i;
	input wire rst_ni;
	input wire incr_i;
	output reg ready_o;
	input wire [127:0] ctr_i;
	output wire [127:0] ctr_o;
	output wire [7:0] ctr_we_o;
	function automatic [127:0] aes_rev_order_byte;
		input reg [127:0] in;
		begin : sv2v_autoblock_147
			reg signed [31:0] i;
			for (i = 0; i < 16; i = i + 1)
				aes_rev_order_byte[i * 8+:8] = in[(15 - i) * 8+:8];
		end
	endfunction
	function automatic [7:0] aes_rev_order_bit;
		input reg [7:0] in;
		begin : sv2v_autoblock_148
			reg signed [31:0] i;
			for (i = 0; i < 8; i = i + 1)
				aes_rev_order_bit[i] = in[7 - i];
		end
	endfunction
	reg [0:0] aes_ctr_ns;
	reg [0:0] aes_ctr_cs;
	reg [2:0] ctr_slice_idx_d;
	reg [2:0] ctr_slice_idx_q;
	reg ctr_carry_d;
	reg ctr_carry_q;
	wire [127:0] ctr_i_rev;
	reg [127:0] ctr_o_rev;
	reg [7:0] ctr_we_o_rev;
	reg ctr_we;
	wire [15:0] ctr_i_slice;
	wire [15:0] ctr_o_slice;
	wire [16:0] ctr_value;
	assign ctr_i_rev = aes_rev_order_byte(ctr_i);
	assign ctr_i_slice = ctr_i_rev[ctr_slice_idx_q * 16+:16];
	assign ctr_value = ctr_i_slice + {15'b0, ctr_carry_q};
	assign ctr_o_slice = ctr_value[15:0];
	always @(*) begin : aes_ctr_fsm
		ready_o = 1'b0;
		ctr_we = 1'b0;
		aes_ctr_ns = aes_ctr_cs;
		ctr_slice_idx_d = ctr_slice_idx_q;
		ctr_carry_d = ctr_carry_q;
		case (aes_ctr_cs)
			IDLE: begin
				ready_o = 1'b1;
				if (incr_i) begin
					ctr_slice_idx_d = 1'sb0;
					ctr_carry_d = 1'b1;
					aes_ctr_ns = INCR;
				end
			end
			INCR: begin
				ctr_slice_idx_d = ctr_slice_idx_q + 3'b1;
				ctr_carry_d = ctr_value[16];
				ctr_we = 1'b1;
				if (ctr_slice_idx_q == 3'b111)
					aes_ctr_ns = IDLE;
			end
			default: aes_ctr_ns = IDLE;
		endcase
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			aes_ctr_cs <= IDLE;
			ctr_slice_idx_q <= 1'sb0;
			ctr_carry_q <= 1'sb0;
		end
		else begin
			aes_ctr_cs <= aes_ctr_ns;
			ctr_slice_idx_q <= ctr_slice_idx_d;
			ctr_carry_q <= ctr_carry_d;
		end
	always @(*) begin
		ctr_o_rev = ctr_i_rev;
		ctr_o_rev[ctr_slice_idx_q * 16+:16] = ctr_o_slice;
	end
	always @(*) begin
		ctr_we_o_rev = 1'sb0;
		ctr_we_o_rev[ctr_slice_idx_q] = ctr_we;
	end
	assign ctr_o = aes_rev_order_byte(ctr_o_rev);
	assign ctr_we_o = aes_rev_order_bit(ctr_we_o_rev);
endmodule
