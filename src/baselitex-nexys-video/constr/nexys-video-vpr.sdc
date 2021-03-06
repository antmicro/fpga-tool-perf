create_clock -period 10 -waveform {0 5} VexRiscv.IBusCachedPlugin_cache.clk
create_clock -period 8 -waveform {0 4} eth_rx_clk
create_clock -period 8 -waveform {0 4} eth_tx_clk
create_clock -period 8 -waveform {2 6} eth_tx_delayed_clk
create_clock -period 5 -waveform {0 2.5} idelay_clk
create_clock -period 10 -waveform {0 5} main_crg_clkin
create_clock -period 10 -waveform {0 5} main_crg_clkout0
create_clock -period 2.5 -waveform {0 1.25} main_crg_clkout1
create_clock -period 2.5 -waveform {0.625 1.875} main_crg_clkout2
create_clock -period 5 -waveform {0 2.5} main_crg_clkout3
create_clock -period 2.5 -waveform {0 1.25} main_crg_clkout_buf1
create_clock -period 2.5 -waveform {0.625 1.875} main_crg_clkout_buf2
create_clock -period 8 -waveform {0 4} main_ethphy_clkout0
create_clock -period 8 -waveform {2 6} main_ethphy_clkout1
create_clock -period 8 -waveform {0 4} main_ethphy_eth_rx_clk_ibuf
