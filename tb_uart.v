`timescale 1ns/1ps

module tb_uart;

reg clk;
reg reset;
reg [7:0] tx_data;
reg tx_start;

wire tx;
wire tx_busy;

wire [7:0] rx_data;
wire rx_valid;


//DUT FOR UART TRANSMITTER
uart_tx transmitter(
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);


//DUT FOR UART RECIEVER
uart_rx reciever(
    .clk(clk),
    .reset(reset),
    .rx(tx),                //Transmitter Output is connected to Reciever Input
    .rx_data(rx_data),
    .rx_valid(rx_valid)
);


always #10 clk = ~clk;



//DISPLAY

always @(posedge rx_valid)
begin

    $display("Time = %0t | Clk = %b | Reset = %b | Start = %b | TX = %b | TX_BUSY = %b | RX_DATA = %b | RX_VALID = %b", $time, clk, reset, tx_start, tx, tx_busy, rx_data, rx_valid);

end

// initial 
// begin
    
//     $monitor("Time = %0t | Clk = %b | Reset = %b | Start = %b | TX = %b | TX_BUSY = %b | RX_DATA = %b | RX_VALID = %b", $time, clk, reset, tx_start, tx, tx_busy, rx_data, rx_valid);

// end



initial begin
    
    $dumpfile("uart.vcd");
    $dumpvars(0, tb_uart);



    //STIMULUS

    //Initial Values
    clk = 0;
    reset = 1;
    tx_start = 0;
    tx_data = 8'd0;

    #100;
    reset = 0;


    //Data 1
    tx_data = 8'b11110000;

    #20;
    tx_start = 1;

    #20;
    tx_start = 0;

    //wait for transmission
    #1200000;




    //Data 2
    tx_data = 8'b10011101;

    #20;
    tx_start = 1;

    #20;
    tx_start = 0;

    //wait for transmission
    #1200000;




    //Data 3
    tx_data = 8'b11100010;

    #20;
    tx_start = 1;

    #20;
    tx_start = 0;

    //wait for transmission
    #1200000;




    //Data 4
    tx_data = 8'b00011011;

    #20;
    tx_start = 1;

    #20;
    tx_start = 0;

    //wait for transmission
    #1200000;


    $finish;

end

endmodule