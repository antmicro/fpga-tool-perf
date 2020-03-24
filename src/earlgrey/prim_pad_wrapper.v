module prim_pad_wrapper (
	inout_io,
	in_o,
	out_i,
	oe_i,
	attr_i
);
	localparam prim_pkg_ImplXilinx = 1;
	parameter [31:0] AttrDw = 6;
	inout wire inout_io;
	output wire in_o;
	input out_i;
	input oe_i;
	input [AttrDw - 1:0] attr_i;
	parameter integer Impl = prim_pkg_ImplXilinx;
	generate
		if (Impl == prim_pkg_ImplXilinx) begin : gen_xilinx
			prim_xilinx_pad_wrapper #(.AttrDw(AttrDw)) u_impl_xilinx(
                                .inout_io(inout_io),
                                .in_o(in_o),
                                .out_i(out_i),
                                .oe_i(oe_i),
                                .attr_i(attr_i)
                        );
		end
		else begin : gen_generic
			prim_generic_pad_wrapper #(.AttrDw(AttrDw)) u_impl_generic(
                                .inout_io(inout_io),
                                .in_o(in_o),
                                .out_i(out_i),
                                .oe_i(oe_i),
                                .attr_i(attr_i)
                        );
		end
	endgenerate
endmodule
