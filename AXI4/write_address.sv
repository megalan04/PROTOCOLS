module axi_aw #(parameter ADDR_WIDTH=32,
                        parameter ID_WIDTH=4)(
input logic ACLK,
input logic ARESETn,
//axi write address
  input logic [ID_WIDTH-1:0] AWID,
  input logic [ADDR_WIDTH-1:0] AWADDR,
  input logic [7:0] AWLEN,
  input logic [2:0] AWSIZE,
  input logic [1:0] AWBURST,

input logic AWVALID,
output logic AWREADY,

//captured write address information
  output logic[ID_WIDTH-1:0] write_id,
  output logic [ADDR_WIDTH-1:0] write_addr,
  output logic[7:0] write_len,
  output logic [2:0] write_size,
  output logic[1:0] write_burst,
  output logic write_addr_valid);
  
  always_ff@(posedge ACLK)begin
    if(!ARESETn)begin
      AWREADY<=1'b0;
      write_id<='0;
      write_addr<='0;
      write_len<='0;
      write_size<='0;
      write_burst<='0;
      write_addr_valid<=1'b0;
    end
    else begin
      AWREADY<=1'b1;//subordinate ready to accept the address
      if(AWVALID && AWREADY)begin//handshake
        write_id<=AWID;
        write_addr<=AWADDR;
        write_len<=AWLEN;
        write_size<=AWSIZE;
        write_burst<=AWBURST;
        write_addr_valid<=1'b1;
      end
      else begin
        write_addr_valid<=1'b0;
      end
    end
  end
endmodule
        
