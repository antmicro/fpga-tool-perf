module top_earlgrey_nexysvideo (
	IO_CLK,
	IO_RST_N,
	IO_DPS0,
	IO_DPS3,
	IO_DPS1,
	IO_DPS4,
	IO_DPS5,
	IO_DPS2,
	IO_DPS6,
	IO_DPS7,
	IO_URX,
	IO_UTX,
	IO_USB_DP0,
	IO_USB_DN0,
	IO_USB_SENSE0,
	IO_USB_PULLUP0,
	IO_GP0,
	IO_GP1,
	IO_GP2,
	IO_GP3,
	IO_GP4,
	IO_GP5,
	IO_GP6,
	IO_GP7,
	IO_GP8,
	IO_GP9,
	IO_GP10,
	IO_GP11,
	IO_GP12,
	IO_GP13,
	IO_GP14,
	IO_GP15
);
	input IO_CLK;
	input IO_RST_N;
	input IO_DPS0;
	input IO_DPS3;
	input IO_DPS1;
	input IO_DPS4;
	input IO_DPS5;
	output IO_DPS2;
	input IO_DPS6;
	input IO_DPS7;
	input IO_URX;
	output IO_UTX;
	inout IO_USB_DP0;
	inout IO_USB_DN0;
	input IO_USB_SENSE0;
	output IO_USB_PULLUP0;
	inout IO_GP0;
	inout IO_GP1;
	inout IO_GP2;
	inout IO_GP3;
	inout IO_GP4;
	inout IO_GP5;
	inout IO_GP6;
	inout IO_GP7;
	inout IO_GP8;
	inout IO_GP9;
	inout IO_GP10;
	inout IO_GP11;
	inout IO_GP12;
	inout IO_GP13;
	inout IO_GP14;
	inout IO_GP15;
	wire clk_sys;
	wire clk_48mhz;
	wire rst_sys_n;
	wire [31:0] cio_gpio_p2d;
	wire [31:0] cio_gpio_d2p;
	wire [31:0] cio_gpio_en_d2p;
	wire cio_uart_rx_p2d;
	wire cio_uart_tx_d2p;
	wire cio_uart_tx_en_d2p;
	wire cio_spi_device_sck_p2d;
	wire cio_spi_device_csb_p2d;
	wire cio_spi_device_mosi_p2d;
	wire cio_spi_device_miso_d2p;
	wire cio_spi_device_miso_en_d2p;
	wire cio_jtag_tck_p2d;
	wire cio_jtag_tms_p2d;
	wire cio_jtag_tdi_p2d;
	wire cio_jtag_tdo_d2p;
	wire cio_jtag_trst_n_p2d;
	wire cio_jtag_srst_n_p2d;
	wire cio_usbdev_sense_p2d;
	wire cio_usbdev_se0_d2p;
	wire cio_usbdev_se0_en_d2p;
	wire cio_usbdev_pullup_d2p;
	wire cio_usbdev_pullup_en_d2p;
	wire cio_usbdev_tx_mode_se_d2p;
	wire cio_usbdev_tx_mode_se_en_d2p;
	wire cio_usbdev_supsend_d2p;
	wire cio_usbdev_supsend_en_d2p;
	wire cio_usbdev_d_p2d;
	wire cio_usbdev_d_d2p;
	wire cio_usbdev_d_en_d2p;
	wire cio_usbdev_dp_p2d;
	wire cio_usbdev_dp_d2p;
	wire cio_usbdev_dp_en_d2p;
	wire cio_usbdev_dn_p2d;
	wire cio_usbdev_dn_d2p;
	wire cio_usbdev_dn_en_d2p;
	top_earlgrey #(.IbexPipeLine(1)) top_earlgrey(
		.clk_i(clk_sys),
		.rst_ni(rst_sys_n),
		.clk_usb_48mhz_i(clk_48mhz),
		.jtag_tck_i(cio_jtag_tck_p2d),
		.jtag_tms_i(cio_jtag_tms_p2d),
		.jtag_trst_ni(cio_jtag_trst_n_p2d),
		.jtag_td_i(cio_jtag_tdi_p2d),
		.jtag_td_o(cio_jtag_tdo_d2p),
		.mio_in_i(cio_gpio_p2d),
		.mio_out_o(cio_gpio_d2p),
		.mio_oe_o(cio_gpio_en_d2p),
		.dio_uart_rx_i(cio_uart_rx_p2d),
		.dio_uart_tx_o(cio_uart_tx_d2p),
		.dio_uart_tx_en_o(cio_uart_tx_en_d2p),
		.dio_spi_device_sck_i(cio_spi_device_sck_p2d),
		.dio_spi_device_csb_i(cio_spi_device_csb_p2d),
		.dio_spi_device_mosi_i(cio_spi_device_mosi_p2d),
		.dio_spi_device_miso_o(cio_spi_device_miso_d2p),
		.dio_spi_device_miso_en_o(cio_spi_device_miso_en_d2p),
		.dio_usbdev_sense_i(cio_usbdev_sense_p2d),
		.dio_usbdev_se0_o(cio_usbdev_se0_d2p),
		.dio_usbdev_se0_en_o(cio_usbdev_se0_en_d2p),
		.dio_usbdev_pullup_o(cio_usbdev_pullup_d2p),
		.dio_usbdev_pullup_en_o(cio_usbdev_pullup_en_d2p),
		.dio_usbdev_tx_mode_se_o(cio_usbdev_tx_mode_se_d2p),
		.dio_usbdev_tx_mode_se_en_o(cio_usbdev_tx_mode_se_en_d2p),
		.dio_usbdev_suspend_o(cio_usbdev_suspend_d2p),
		.dio_usbdev_suspend_en_o(cio_usbdev_suspend_en_d2p),
		.dio_usbdev_d_i(cio_usbdev_d_p2d),
		.dio_usbdev_d_o(cio_usbdev_d_d2p),
		.dio_usbdev_d_en_o(cio_usbdev_d_en_d2p),
		.dio_usbdev_dp_i(cio_usbdev_dp_p2d),
		.dio_usbdev_dp_o(cio_usbdev_dp_d2p),
		.dio_usbdev_dp_en_o(cio_usbdev_dp_en_d2p),
		.dio_usbdev_dn_i(cio_usbdev_dn_p2d),
		.dio_usbdev_dn_o(cio_usbdev_dn_d2p),
		.dio_usbdev_dn_en_o(cio_usbdev_dn_en_d2p),
		.scanmode_i(1'b0)
	);
	clkgen_xil7series clkgen(
		.IO_CLK(IO_CLK),
		.IO_RST_N(IO_RST_N & cio_jtag_srst_n_p2d),
		.clk_sys(clk_sys),
		.clk_48MHz(clk_48mhz),
		.rst_sys_n(rst_sys_n)
	);
	padctl padctl(
		.cio_uart_rx_p2d(cio_uart_rx_p2d),
		.cio_uart_tx_d2p(cio_uart_tx_d2p),
		.cio_uart_tx_en_d2p(cio_uart_tx_en_d2p),
		.cio_usbdev_sense_p2d(cio_usbdev_sense_p2d),
		.cio_usbdev_se0_d2p(cio_usbdev_se0_d2p),
		.cio_usbdev_se0_en_d2p(cio_usbdev_se0_en_d2p),
		.cio_usbdev_pullup_d2p(cio_usbdev_pullup_d2p),
		.cio_usbdev_pullup_en_d2p(cio_usbdev_pullup_en_d2p),
		.cio_usbdev_tx_mode_se_d2p(cio_usbdev_tx_mode_se_d2p),
		.cio_usbdev_tx_mode_se_en_d2p(cio_usbdev_tx_mode_se_en_d2p),
		.cio_usbdev_suspend_d2p(cio_usbdev_suspend_d2p),
		.cio_usbdev_suspend_en_d2p(cio_usbdev_suspend_en_d2p),
		.cio_usbdev_d_p2d(cio_usbdev_d_p2d),
		.cio_usbdev_d_d2p(cio_usbdev_d_d2p),
		.cio_usbdev_d_en_d2p(cio_usbdev_d_en_d2p),
		.cio_usbdev_dp_p2d(cio_usbdev_dp_p2d),
		.cio_usbdev_dp_d2p(cio_usbdev_dp_d2p),
		.cio_usbdev_dp_en_d2p(cio_usbdev_dp_en_d2p),
		.cio_usbdev_dn_p2d(cio_usbdev_dn_p2d),
		.cio_usbdev_dn_d2p(cio_usbdev_dn_d2p),
		.cio_usbdev_dn_en_d2p(cio_usbdev_dn_en_d2p),
		.cio_gpio_p2d(cio_gpio_p2d),
		.cio_gpio_d2p(cio_gpio_d2p),
		.cio_gpio_en_d2p(cio_gpio_en_d2p),
		.IO_URX(IO_URX),
		.IO_UTX(IO_UTX),
		.IO_USB_DP0(IO_USB_DP0),
		.IO_USB_DN0(IO_USB_DN0),
		.IO_USB_SENSE0(IO_USB_SENSE0),
		.IO_USB_PULLUP0(IO_USB_PULLUP0),
		.IO_GP0(IO_GP0),
		.IO_GP1(IO_GP1),
		.IO_GP2(IO_GP2),
		.IO_GP3(IO_GP3),
		.IO_GP4(IO_GP4),
		.IO_GP5(IO_GP5),
		.IO_GP6(IO_GP6),
		.IO_GP7(IO_GP7),
		.IO_GP8(IO_GP8),
		.IO_GP9(IO_GP9),
		.IO_GP10(IO_GP10),
		.IO_GP11(IO_GP11),
		.IO_GP12(IO_GP12),
		.IO_GP13(IO_GP13),
		.IO_GP14(IO_GP14),
		.IO_GP15(IO_GP15),
		.cio_spi_device_sck_p2d(cio_spi_device_sck_p2d),
		.cio_spi_device_csb_p2d(cio_spi_device_csb_p2d),
		.cio_spi_device_mosi_p2d(cio_spi_device_mosi_p2d),
		.cio_spi_device_miso_d2p(cio_spi_device_miso_d2p),
		.cio_spi_device_miso_en_d2p(cio_spi_device_miso_en_d2p),
		.cio_jtag_tck_p2d(cio_jtag_tck_p2d),
		.cio_jtag_tms_p2d(cio_jtag_tms_p2d),
		.cio_jtag_trst_n_p2d(cio_jtag_trst_n_p2d),
		.cio_jtag_srst_n_p2d(cio_jtag_srst_n_p2d),
		.cio_jtag_tdi_p2d(cio_jtag_tdi_p2d),
		.cio_jtag_tdo_d2p(cio_jtag_tdo_d2p),
		.IO_DPS0(IO_DPS0),
		.IO_DPS1(IO_DPS1),
		.IO_DPS2(IO_DPS2),
		.IO_DPS3(IO_DPS3),
		.IO_DPS4(IO_DPS4),
		.IO_DPS5(IO_DPS5),
		.IO_DPS6(IO_DPS6),
		.IO_DPS7(IO_DPS7)
	);
endmodule
