module prim_rom (
	clk_i,
	rst_ni,
	addr_i,
	cs_i,
	dout_o,
	dvalid_o
);
	localparam prim_pkg_ImplXilinx = 1;
	parameter signed [31:0] Width = 32;
	parameter signed [31:0] Depth = 2048;
	parameter signed [31:0] Aw = $clog2(Depth);
	input clk_i;
	input rst_ni;
	input [Aw - 1:0] addr_i;
	input cs_i;
	output wire [Width - 1:0] dout_o;
	output wire dvalid_o;
	parameter integer Impl = prim_pkg_ImplXilinx;
	generate
		if (Impl == prim_pkg_ImplXilinx) begin : gen_xilinx
			prim_xilinx_rom #(
				.Aw(Aw),
				.Depth(Depth),
				.Width(Width)
			) u_impl_xilinx(
                                .clk_i(clk_i),
                                //.rst_ni(rst_ni),
                                .addr_i(addr_i),
                                .cs_i(cs_i),
                                .dout_o(dout_o),
                                .dvalid_o(dvalid_o)
                        );
		end
		else begin : gen_generic
			prim_generic_rom #(
				.Aw(Aw),
				.Depth(Depth),
				.Width(Width)
			) u_impl_generic(
                                .clk_i(clk_i),
                                .addr_i(addr_i),
                                .cs_i(cs_i),
                                .dout_o(dout_o),
                                .dvalid_o(dvalid_o)
                        );
		end
	endgenerate
endmodule
