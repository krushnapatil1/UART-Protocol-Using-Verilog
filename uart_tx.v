module uart_tx(
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data,
    
    output reg tx,
    output reg tx_busy
);

//PARAMETERS
parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;


//INTERNAL SIGNALS
reg [1:0] state;

reg [12:0] baud_counter;
reg baud_tick;

reg [2:0] bit_index;
reg [7:0] data_reg;


//BAUD RATE GENERATOR
always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        baud_counter <= 13'd0;
        baud_tick <= 1'b0;
    end
    else
    begin
        if(state == IDLE)
        begin
            baud_counter <= 13'd0;
            baud_tick <= 1'b0;
        end
        else
        begin
            if(baud_counter == 13'd5207)
            begin
                baud_counter <= 13'd0;
                baud_tick <= 1'b1;
            end
            else
            begin
                baud_counter <= baud_counter + 1'b1;
                baud_tick <= 1'b0;
            end
        end
    end
end


//UART TRANSMITTER FSM

always@(posedge clk or posedge reset) begin
    
    if(reset)
    begin
        state <= IDLE;
        bit_index <= 3'd0;
        data_reg <= 8'd0;

        tx <= 1'b1;
        tx_busy <= 1'b0;
    end

    else 
    begin
        
        //IDLE STATE
        if(state == IDLE)
        begin
            tx <= 1'b1;
            tx_busy <= 1'b0;

            if(tx_start)
            begin
                data_reg <= tx_data;
                bit_index <= 3'd0;
                state <= START;
                tx <= 1'b0;
                tx_busy <= 1'b1;

                baud_counter <= 13'd0;
            end
        end


        //START STATE
        else if(state == START)
        begin
            tx <= 1'b0;
            tx_busy <= 1'b1;

            if(baud_tick)
            begin
                state <= DATA;
                bit_index <= 3'd0;
                tx <= data_reg[0];
            end
        end


        //DATA STATE
        else if(state == DATA)
        begin
            tx <= data_reg[bit_index];
            tx_busy <= 1'b1;

            if(baud_tick)
            begin

                if(bit_index < 3'd7)
                begin
                    bit_index <= bit_index + 1'b1;
                    tx <= data_reg[bit_index + 1'b1];
                end

                else
                begin
                    state <= STOP;
                    tx <= 1'b1;
                end

            end
        end 


        //STOP STATE
        else if(state == STOP)
        begin
            tx <= 1'b1;
            tx_busy <= 1'b1;

            if(baud_tick)
            begin
                state <= IDLE;
                tx <= 1'b1;
                tx_busy <= 1'b0;
            end
        end

    end
end


endmodule