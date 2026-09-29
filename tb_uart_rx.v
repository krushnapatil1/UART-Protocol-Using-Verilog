`timescale 1ns/1ps

module tb_uart_rx;

reg clk;
reg reset;
reg rx;

wire [7:0] rx_data;
wire rx_valid;


uart_rx dut(
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .rx_data(rx_data),
    .rx_valid(rx_valid)
);


always #10 clk = ~clk;

initial begin
    
    $monitor("Time = %0t | Clk = %b | Reset = %b | RX = %b | RX_DATA = %b | RX_VALID = %b", $time, clk, reset, rx, rx_data, rx_valid);
end

// always @(posedge rx_valid)
// begin
//     $display("Time = %0t | Clk = %b | Reset = %b | Rx = %b | RX_DATA = %b | RX_VALID = %b",$time, clk, reset, rx, rx_data, rx_valid);
// end


//Stimulus
initial begin
    
    $dumpfile("uart_rx.vcd");
    $dumpvars(0, tb_uart_rx);


    clk = 0;
    reset = 1;
    rx = 1;

    #100;
    reset = 0;

    //Start Bit
    rx = 0;
    #104160;          // 5208 clk cycles * 20ns


    //Data Bits (LSB First) - 10110101

    rx = 1;         //Bit 0
    #104160;

    rx = 0;         //Bit 1
    #104160;
    
    rx = 1;         //Bit 2
    #104160;

    rx = 0;         //Bit 3
    #104160;

    rx = 1;         //Bit 4
    #104160;

    rx = 1;         //Bit 5
    #104160;

    rx = 0;         //Bit 6
    #104160;

    rx = 1;         //Bit 7
    #104160;
    


    //Stop Bit
    rx = 1;
    #104160;



    #10000;
    $finish;
    

end


endmodule