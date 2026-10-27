module axi_r #(parameter DATA_WIDTH=32,
               parameter ID_WIDTH=4)(
input logic ACLK,
input logic ARESETn,

//read response information
  input logic[ID_WIDTH-1:0] response_id,
  input logic [DATA_WIDTH-1:0] response_data,
  input logic[1:0] response_code,
  input logic response_last,
  input logic response_valid,

//AXI R 
  output logic[ID_WIDTH-1:0] RID,
  output logic [DATA_WIDTH-1:0] RDATA,
  output logic[1:0] RRESP,
  output logic RLAST,
  output logic RVALID,
  input logic RREADY);
  always_ff @(posedge ACLK)begin
    if(!ARESETn)begin
      RID<='0;
      RDATA<='0;
      RRESP<=2'b00;
      RLAST<=1'b0;
      RVALID<=1'b0;
    end
    else begin
      if(response_valid && !RVALID)begin
        RID<=response_id;
        RDATA<=response_data;
        RRESP<=response_code;
        RLAST<=response_last;
        
        RVALID<=1'b1;
      end
      //read handshake
      if(RVALID && RREADY)begin
        RVALID<=1'b0;
      end
    end
  end
endmodule
