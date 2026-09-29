module uart_rx(
    input clk,
    input reset,
    input rx,

    output reg [7:0] rx_data,
    output reg rx_valid
);


//Parameters
parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

reg [1:0] state;
reg [12:0] baud_counter;
reg [2:0] bit_index;

always@(posedge clk or posedge reset)
begin

    if(reset)
    begin
        
        state <= IDLE;
        baud_counter <= 13'd0;
        bit_index <= 3'd0;
        rx_data <= 8'd0;
        rx_valid <= 1'b0;

    end    

    else 
    begin
        
        rx_valid <= 1'b0;

        //IDLE
        if(state == IDLE)
        begin

            if(rx == 1'b0)
            begin
                state <= START;
                baud_counter <= 13'd0;
            end

        end


        //START
        else if(state == START)
        begin
            
            if(baud_counter == 13'd2604)
            begin
                
                if(rx == 1'b0)
                begin
                    state <= DATA;
                    baud_counter <= 13'd0;
                end

                else
                begin
                    state <= IDLE;
                    baud_counter <= 13'd0;
                end

            end

            else 
            begin
                baud_counter <= baud_counter + 1'b1;
            end

        end


        //DATA
        else if(state == DATA)
        begin
            
            if(baud_counter == 13'd5207)
            begin

                rx_data[bit_index] <= rx;
                baud_counter <= 13'd0;

                if(bit_index < 3'd7)
                begin
                    bit_index <= bit_index + 1'b1;
                end

                else
                begin
                    state <= STOP;
                    bit_index <= 3'd0;
                end

            end

            else
            begin
                baud_counter <= baud_counter + 1'b1;
            end
        end


        //STOP
        else if(state == STOP)
        begin
            
            if(baud_counter == 13'd5207)
            begin
                
                if(rx == 1'b1)
                begin
                    rx_valid <= 1'b1;
                end

                baud_counter <= 13'b0;
                state <= IDLE;
            end

            else
            begin
                baud_counter <= baud_counter + 1'b1;
            end

        end


        // //STOP - THIS IS ALSO VALID
        // else if(state == STOP)
        // begin
            
        //     if(baud_counter == 13'd5207)
        //     begin
                
        //         if(rx == 1'b1)
        //         begin
        //             rx_valid <= 1'b1;
        //             baud_counter <= 13'b0;
        //             state <= IDLE;
        //         end

        //         else
        //         begin
        //             baud_counter <= 13'b0;
        //             state <= IDLE;
        //         end
                
        //     end

        //     else
        //     begin
        //         baud_counter <= baud_counter + 1'b1;
        //     end
            
        // end
    end
end

endmodule