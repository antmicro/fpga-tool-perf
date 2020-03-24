module prim_ram_2p (
	clk_a_i,
	clk_b_i,
	a_req_i,
	a_write_i,
	a_addr_i,
	a_wdata_i,
	a_rdata_o,
	b_req_i,
	b_write_i,
	b_addr_i,
	b_wdata_i,
	b_rdata_o
);
	localparam prim_pkg_ImplXilinx = 1;
	parameter signed [31:0] Width = 32;
	parameter signed [31:0] Depth = 128;
	localparam signed [31:0] Aw = $clog2(Depth);
	input clk_a_i;
	input clk_b_i;
	input a_req_i;
	input a_write_i;
	input [Aw - 1:0] a_addr_i;
	input [Width - 1:0] a_wdata_i;
	output wire [Width - 1:0] a_rdata_o;
	input b_req_i;
	input b_write_i;
	input [Aw - 1:0] b_addr_i;
	input [Width - 1:0] b_wdata_i;
	output wire [Width - 1:0] b_rdata_o;
	parameter integer Impl = prim_pkg_ImplXilinx;
	generate
		if (Impl == prim_pkg_ImplXilinx) begin : gen_xilinx
			prim_xilinx_ram_2p #(
				.Width(Width),
				.Depth(Depth)
			) u_impl_xilinx(
                                .clk_a_i(clk_a_i),
                                .clk_b_i(clk_b_i),
                                .a_req_i(a_req_i),
                                .a_write_i(a_write_i),
                                .a_addr_i(a_addr_i),
                                .a_wdata_i(a_wdata_i),
                                .a_rdata_o(a_rdata_o),
                                .b_req_i(b_req_i),
                                .b_write_i(b_write_i),
                                .b_addr_i(b_addr_i),
                                .b_wdata_i(b_wdata_i),
                                .b_rdata_o(b_rdata_o)
                        );
		end
		else begin : gen_generic
			prim_generic_ram_2p #(
				.Width(Width),
				.Depth(Depth)
			) u_impl_generic(
                                .clk_a_i(clk_a_i),
                                .clk_b_i(clk_b_i),
                                .a_req_i(a_req_i),
                                .a_write_i(a_write_i),
                                .a_addr_i(a_addr_i),
                                .a_wdata_i(a_wdata_i),
                                .a_rdata_o(a_rdata_o),
                                .b_req_i(b_req_i),
                                .b_write_i(b_write_i),
                                .b_addr_i(b_addr_i),
                                .b_wdata_i(b_wdata_i),
                                .b_rdata_o(b_rdata_o)
                        );
		end
	endgenerate
endmodule
