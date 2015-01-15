module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy // AVR Rx buffer full
    );

wire [7:0] tx_data;
wire tx_new;
wire tx_busy;

wire rst = ~rst_n; // make reset active high
wire rx_new;
wire [7:0] rx_data;
wire ready_w;
wire [1023:0] hash_w;

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign spi_channel = 4'bzzzz;
assign led[7:0] = hash_w[7:0];

avr_interface avr_interface1 (
    .clk(clk),
    .rst(rst),
    .cclk(cclk),
	 
	 // Serial AVR Interface
    .tx(avr_rx),
    .rx(avr_tx),
	 
    // Serial TX User Interface
    .tx_data(tx_data),
    .new_tx_data(tx_new),
    .tx_busy(tx_busy),
    .tx_block(),

    // Serial RX User Interface
    .rx_data(rx_data),
    .new_rx_data(rx_new)
);

transmitter transmitter1 (
	.clk_i(clk),
	.rst_i(rst),
	.tx_data_o(tx_data),
	.tx_new_o(tx_new),
	.tx_busy_i(tx_busy),
	.word_i(hash_w[63:0]),
	.ready_i(ready_w)
);

chip_top chip_top (
	.clk_i(clk),
	.rst_i(rst),
	.hash_o(hash_w),
	.ready_o(ready_w)
);

endmodule