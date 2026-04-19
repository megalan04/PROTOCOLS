`timescale 1ns/1ps
module spi_master (
    input clk,
    input rst,
    input start,
    input [7:0]data_in,
    input MISO,
    input cpol,
    input cpha,
    output reg MOSI,
    output reg SCLK,
    output reg SS,
    output reg[7:0]data_out,
    output reg done
);

    localparam IDLE=2'b00,
               LOAD=2'b01,
               TRANSFER=2'b10,
               DONE=2'b11;

    reg [1:0]state;
    reg [7:0]shift_reg;
    reg [2:0]bit_cnt;
    reg [1:0]clk_div;
    reg SCLK_d;
    wire rising_edge=(SCLK& ~SCLK_d);
    wire falling_edge=(~SCLK & SCLK_d);
    wire sample_edge=rising_edge;

    wire shift_edge=(cpha==0)?(cpol?rising_edge:falling_edge):(cpol?falling_edge:rising_edge);

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            SCLK<=0;
            clk_div<=0;
        end
        else if(state == TRANSFER) begin
            clk_div <= clk_div + 1;
            if (clk_div == 2'b01) begin
                SCLK <= ~SCLK;
                clk_div <= 0;
            end
        end
        else begin
            SCLK <= cpol;
            clk_div <= 0;
        end
    end

    
    always@(posedge clk or posedge rst)begin
        if(rst)
            SCLK_d<=0;
        else
            SCLK_d<=SCLK;
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state<=IDLE;
            SS<=1'b1;
            done<=1'b0;
            MOSI<=0;
            data_out<=0;
            shift_reg<=0;
            bit_cnt<=0;
        end 
        else begin
            case(state)

            IDLE:begin
                SS<=1'b1;
                done<=1'b0;
                if(start)
                    state<=LOAD;
            end

            LOAD: begin
                SS<=1'b0;
                shift_reg<=data_in;
                bit_cnt<=0;
                data_out<=0;

                MOSI<=data_in[7]; // first bit
                state<=TRANSFER;
            end

            TRANSFER:begin
                if(shift_edge)begin
                    shift_reg<={shift_reg[6:0],1'b0};
                    MOSI<=shift_reg[6];
                end
                if(sample_edge)begin
                    data_out<={data_out[6:0], MISO};

                    bit_cnt<=bit_cnt + 1;
                    if(bit_cnt==3'd7)
                        state<=DONE;
                end
            end

            DONE:begin
                SS<=1'b1;
                done<=1'b1;
                state<=IDLE;
            end

            endcase
        end
    end

endmodule
