module axi_w #(parameter DATA_WIDTH=32
                     )(input  logic ACLK,
                      input logic ARESETn,
                      
                      //axi wrtie data
                       input logic[DATA_WIDTH-1:0] WDATA,
                       input logic[DATA_WIDTH/8-1:0] WSTRB,
                      input logic WLAST,
                      input logic WVALID,
                      output logic WREADY,
                      
                       output logic[DATA_WIDTH-1:0] write_data,
                       output logic[DATA_WIDTH/8-1:0] write_strb,
                       output logic write_last,
                       output logic write_data_valid);
  always_ff @(posedge ACLK)begin
    if(!ARESETn)begin
      WREADY<=1'b0;
      write_data<='0;
      write_strb<='0;
      write_last<=1'b0;
    end
    else begin
      WREADY<=1'b1;
      if(WVALID && WREADY)begin
        write_data<=WDATA;
        write_strb<=WSTRB;
        write_last<=WLAST;
        write_data_valid<=1'b1;
      end
      else begin
        write_data_valid<=1'b0;
      end
    end
  end
endmodule
