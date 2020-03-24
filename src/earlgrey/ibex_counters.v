module ibex_counters (
	clk_i,
	rst_ni,
	counter_inc_i,
	counterh_we_i,
	counter_we_i,
	counter_val_i,
	counter_val_o
);
	parameter signed [31:0] MaxNumCounters = 29;
	parameter signed [31:0] NumCounters = 0;
	parameter signed [31:0] CounterWidth = 32;
	input clk_i;
	input rst_ni;
	input wire [MaxNumCounters - 1:0] counter_inc_i;
	input wire [MaxNumCounters - 1:0] counterh_we_i;
	input wire [MaxNumCounters - 1:0] counter_we_i;
	input wire [31:0] counter_val_i;
	output wire [(0 >= (MaxNumCounters - 1) ? ((2 - MaxNumCounters) * 64) + (((MaxNumCounters - 1) * 64) - 1) : (MaxNumCounters * 64) + -1):(0 >= (MaxNumCounters - 1) ? (MaxNumCounters - 1) * 64 : 0)] counter_val_o;
	wire [(0 >= (MaxNumCounters - 1) ? ((2 - MaxNumCounters) * 64) + (((MaxNumCounters - 1) * 64) - 1) : (MaxNumCounters * 64) + -1):(0 >= (MaxNumCounters - 1) ? (MaxNumCounters - 1) * 64 : 0)] counter;
	assign counter_val_o = counter;
	generate
		genvar i;
		for (i = 0; i < MaxNumCounters; i = i + 1) begin : g_counter
			if (i < NumCounters) begin : g_counter_exists
				reg [63:0] counter_upd;
				reg [63:0] counter_load;
				reg we;
				reg [CounterWidth - 1:0] counter_d;
				always @(*) begin
					we = counter_we_i[i] | counterh_we_i[i];
					counter_load[63:32] = counter[((0 >= (MaxNumCounters - 1) ? i : (MaxNumCounters - 1) - i) * 64) + 63-:32];
					counter_load[31:0] = counter_val_i;
					if (counterh_we_i[i]) begin
						counter_load[63:32] = counter_val_i;
						counter_load[31:0] = counter[((0 >= (MaxNumCounters - 1) ? i : (MaxNumCounters - 1) - i) * 64) + 31-:32];
					end
					counter_upd = counter[(0 >= (MaxNumCounters - 1) ? i : (MaxNumCounters - 1) - i) * 64+:64] + 64'h1;
					if (we)
						counter_d = counter_load[CounterWidth - 1:0];
					else if (counter_inc_i[i])
						counter_d = counter_upd[CounterWidth - 1:0];
					else
						counter_d = counter[((0 >= (MaxNumCounters - 1) ? i : (MaxNumCounters - 1) - i) * 64) + ((CounterWidth - 1) >= 0 ? CounterWidth - 1 : ((CounterWidth - 1) + ((CounterWidth - 1) >= 0 ? CounterWidth : 2 - CounterWidth)) - 1)-:((CounterWidth - 1) >= 0 ? CounterWidth : 2 - CounterWidth)];
				end
				reg [CounterWidth - 1:0] counter_q;
				always @(posedge clk_i or negedge rst_ni)
					if (!rst_ni)
						counter_q <= 1'sb0;
					else
						counter_q <= counter_d;
				if (CounterWidth < 64) begin : g_counter_narrow
					assign counter[((0 >= (MaxNumCounters - 1) ? i : (MaxNumCounters - 1) - i) * 64) + ((CounterWidth - 1) >= 0 ? CounterWidth - 1 : ((CounterWidth - 1) + ((CounterWidth - 1) >= 0 ? CounterWidth : 2 - CounterWidth)) - 1)-:((CounterWidth - 1) >= 0 ? CounterWidth : 2 - CounterWidth)] = counter_q;
					assign counter[((0 >= (MaxNumCounters - 1) ? i : (MaxNumCounters - 1) - i) * 64) + (63 >= CounterWidth ? 63 : (63 + (63 >= CounterWidth ? 64 - CounterWidth : (CounterWidth - 63) + 1)) - 1)-:(63 >= CounterWidth ? 64 - CounterWidth : (CounterWidth - 63) + 1)] = 1'sb0;
				end
				else begin : g_counter_full
					assign counter[(0 >= (MaxNumCounters - 1) ? i : (MaxNumCounters - 1) - i) * 64+:64] = counter_q;
				end
			end
			else begin : g_no_counter
				assign counter[(0 >= (MaxNumCounters - 1) ? i : (MaxNumCounters - 1) - i) * 64+:64] = 1'sb0;
			end
		end
	endgenerate
endmodule
