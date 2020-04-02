module prim_ram_1p (
	clk_i,
	rst_ni,
	req_i,
	write_i,
	addr_i,
	wdata_i,
	wmask_i,
	rvalid_o,
	rdata_o
);
	localparam prim_pkg_ImplXilinx = 1;
	parameter signed [31:0] Width = 32;
	parameter signed [31:0] Depth = 128;
	parameter signed [31:0] DataBitsPerMask = 1;
	parameter signed [31:0] Aw = $clog2(Depth);
	input clk_i;
	input rst_ni;
	input req_i;
	input write_i;
	input [Aw - 1:0] addr_i;
	input [Width - 1:0] wdata_i;
	input [Width - 1:0] wmask_i;
	output wire rvalid_o;
	output wire [Width - 1:0] rdata_o;
	parameter integer Impl = prim_pkg_ImplXilinx;
	generate
		begin : gen_generic
			prim_generic_ram_1p #(
				.DataBitsPerMask(DataBitsPerMask),
				.Width(Width),
				.Depth(Depth)
			) u_impl_generic (
				.clk_i,
				.rst_ni,
				.req_i,
				.write_i,
				.addr_i,
				.wdata_i,
				.wmask_i,
				.rvalid_o,
				.rdata_o
			);
		end
	endgenerate
endmodule
