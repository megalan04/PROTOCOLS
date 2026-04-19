`timescale 1ns/1ps
module spi_slave(
    input clk,
    input rst,
    input SS,
    input SCLK,
    input MOSI,
    output reg MISO
);

    reg[7:0]shift_reg;
    reg[2:0]bit_cnt;
    reg SCLK_d;
    wire rising_edge=(SCLK&~SCLK_d);
    always@(posedge clk or posedge rst)begin
        if(rst)
            SCLK_d<=0;
        else
            SCLK_d<=SCLK;
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            shift_reg<=8'hA5;
            MISO<=0;
            bit_cnt<=0;
        end
        else if(!SS)begin
            if(rising_edge)begin
                MISO<=shift_reg[7];
                shift_reg<={shift_reg[6:0],MOSI};
                bit_cnt<=bit_cnt+1;
            end
        end
    end

endmodule
