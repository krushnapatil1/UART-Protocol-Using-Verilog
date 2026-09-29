`timescale 1ns/1ps

module tb_uart_tx;

reg clk;
reg reset;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;

uart_tx dut(
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);


always #10 clk = ~clk;

initial begin
    
    $monitor("Time = %0t | Reset = %b | start = %b | tx = %b | Busy = %b", $time, reset, tx_start, tx, tx_busy);

end

initial begin

    $dumpfile("uart_tx.vcd");
    $dumpvars(0, tb_uart_tx);


    //Initial Values
    clk = 0;
    reset = 1;
    tx_start = 0;
    tx_data = 8'd0;

    //Reset
    #100;
    reset = 0;

    //Given Data
    tx_data = 8'b10110101;

    //Start Transmission
    #20;
    tx_start = 1;

    //One Clock Pulse
    #20;
    tx_start = 0;


    //Wait for Complete Transmission
    #2000000;

    $finish;
end


endmodule