module axi_ar #(parameter ADDR_WIDTH=32,
               parameter ID_WIDTH=4
               )(input logic ACLK,
                input logic ARESETn,
                
                //axi read addr
                 input logic[ID_WIDTH-1:0] ARID,
                 input logic[ADDR_WIDTH-1:0] ARADDR,
                 input logic[7:0] ARLEN,
                 input logic[2:0] ARSIZE,
                 input logic[1:0] ARBURST,
                
                input logic ARVALID,
                output logic ARREADY,
                
                //capture read information
                 output logic[ID_WIDTH-1:0] read_id,
                 output logic[ADDR_WIDTH-1:0] read_addr,
                 output logic[7:0] read_len,
                 output logic[2:0] read_size,
                 output logic[1:0] read_burst,
                 output logic read_addr_valid);
  always_ff @(posedge ACLK)begin
    if(!ARESETn)begin
      ARREADY<=1'b0;
      read_id<='0;
      read_addr<='0;
      read_len<='0;
      read_size<='0;
      read_burst<='0;
    end
    else begin
      ARREADY<=1'b1;
      //AR handshake
      if(ARVALID && ARREADY)begin
        read_id<=ARID;
        read_addr<=ARADDR;
        read_len<=ARLEN;
        read_size<=ARSIZE;
        read_burst<=ARBURST;
        
        read_addr_valid<=1'b1;
      end
      else begin
        read_addr_valid<=1'b0;
      end
    end
  end
endmodule
