`include "spi_slave.sv"
`include "spi_master.sv"
`timescale 1ns/1ps
module top_module (
    input clk,
    input rst,
    input start,
    input[7:0]data_in,
    input cpol,
    input cpha,
    output[7:0]data_out,
    output done
);
    wire MOSI;
    wire MISO;
    wire SCLK;
    wire SS;
    spi_master master (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .MISO(MISO),
        .cpol(cpol),
        .cpha(cpha),
        .MOSI(MOSI),
        .SCLK(SCLK),
        .SS(SS),
        .data_out(data_out),
        .done(done)
    );
    spi_slave slave (
        .clk(clk),
        .rst(rst),
        .SS(SS),
        .SCLK(SCLK),
        .MOSI(MOSI),
        .MISO(MISO)
    );

endmodule
