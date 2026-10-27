module axi_memory #(parameter DATA_WIDTH=32,
                   parameter ADDR_WIDTH=32,
                   parameter MEM_DEPTH=256
                   )(
input logic ACLK,
input logic ARESETn,

//write interface
input logic write_en,
  input logic[ADDR_WIDTH-1:0] write_addr,
  input logic[DATA_WIDTH-1:0] write_data,
  input logic[DATA_WIDTH/8-1:0] write_strb,

//read interface
input logic read_en,
  input logic[ADDR_WIDTH-1:0] read_addr,
  output logic[DATA_WIDTH-1:0] read_data);
  logic[DATA_WIDTH-1:0] mem[0:MEM_DEPTH-1];
  integer i;
  always_ff @(posedge ACLK)begin
    if(!ARESETn)begin
      read_data<='0;
      for(i=0;i<MEM_DEPTH;i=i+1)
        mem[i]<='0;
    end
    else begin
       //write
            if(write_en)begin
                if(write_strb[0])
                    mem[write_addr[9:2]][7:0]<=write_data[7:0];
                if(write_strb[1])
                    mem[write_addr[9:2]][15:8]<=write_data[15:8];
                if(write_strb[2])
                    mem[write_addr[9:2]][23:16]<=write_data[23:16];
                if(write_strb[3])
                    mem[write_addr[9:2]][31:24]<=write_data[31:24];
            end

            //read
            if(read_en)begin
                read_data<=mem[read_addr[9:2]];
            end
    end
  end
endmodule
