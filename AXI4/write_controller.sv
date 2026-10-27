module axi_write_controller #(parameter ADDR_WIDTH=32,
                             parameter DATA_WIDTH=32,
                             parameter ID_WIDTH=4
                             )(input logic ACLK,
                              input logic ARESETn,
                              
                              //from aw channel
                               input logic[ID_WIDTH-1:0] aw_id,
                               input logic[ADDR_WIDTH-1:0] aw_addr,
                               input logic aw_valid,
                              
                              //from write channel
                               input logic[DATA_WIDTH-1:0] w_data,
                               input logic[DATA_WIDTH/8-1:0] w_strb,
                               input logic w_last,
                               input logic w_valid,
                               
                               //axi memory
                               output logic write_en,
                               output logic[ADDR_WIDTH-1:0] write_addr,
                               output logic[DATA_WIDTH-1:0] write_data,
                               output logic[DATA_WIDTH/8-1:0] write_strb,
                               
                               //response(B) channel
                               output logic[ID_WIDTH-1:0] response_id,
                               output logic[1:0] response_code,
                               output logic response_valid,
                               
                               input logic response_done);
  logic addr_received;
  logic data_received;
  
  logic[ID_WIDTH-1:0] stored_aw_id;
  logic[ADDR_WIDTH-1:0] stored_aw_addr;
  
  logic[DATA_WIDTH-1:0] stored_w_data;
  logic[DATA_WIDTH/8-1:0] stored_w_strb;
  
    always_ff @(posedge ACLK)begin
        if(!ARESETn)begin
            addr_received<=1'b0;
            data_received<=1'b0;
            stored_aw_id<='0;
            stored_aw_addr<='0;
            stored_w_data<='0;
            stored_w_strb<='0;
            write_en<=1'b0;
            response_id<='0;
            response_code<=2'b00;
            response_valid<=1'b0;
        end
        else begin

            // default:write will enable for only one clk cycle
            write_en<=1'b0;
            // Capture write address
            if(aw_valid && !addr_received)begin
                stored_aw_id<=aw_id;
                stored_aw_addr<=aw_addr;
                addr_received<=1'b1;
            end
            // Capture write data
            if(w_valid && !data_received)begin
                stored_w_data<=w_data;
                stored_w_strb<=w_strb;
                data_received<=1'b1;
            end
            // When both address and data are available
            if (addr_received && data_received && !response_valid)begin
                write_addr<=stored_aw_addr;
                write_data<=stored_w_data;
                write_strb<=stored_w_strb;
                write_en<=1'b1;
                response_id<=stored_aw_id;
                response_code<=2'b00; // 00=OKAY
                response_valid<=1'b1;
                addr_received<=1'b0;
                data_received<=1'b0;
            end
            // B response accepted
            if(response_valid && response_done)begin
                response_valid<=1'b0;
            end
        end
    end
endmodule
