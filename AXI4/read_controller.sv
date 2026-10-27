module axi_read_controller #(parameter ADDR_WIDTH=32,
                            parameter DATA_WIDTH=32,
                            parameter ID_WIDTH=4
                            )(
  input logic ACLK,
  input logic ARESETn,

  //from AR channel
  input logic[ID_WIDTH-1:0] ar_id,
  input logic[ADDR_WIDTH-1:0] ar_addr,
  input logic ar_valid,
  //to axi memory
  output logic read_en,
  output logic[ADDR_WIDTH-1:0] read_addr,
  input logic[DATA_WIDTH-1:0] read_data,
  //to READ channel
  output logic[ID_WIDTH-1:0] response_id,
  output logic [DATA_WIDTH-1:0] response_data,
  output logic[1:0] response_code,
  output logic response_last,
  output logic response_valid,
//from read channel
  input logic response_done);
  
  typedef enum logic[1:0]{
  IDLE,
    READ,
    SEND}state_t;
  state_t state;
  
  //store the transaction infromation
  logic[ID_WIDTH-1:0] stored_id;
  logic[ADDR_WIDTH-1:0] stored_addr;
  always_ff @(posedge ACLK)begin
    if(!ARESETn)begin
      state<=IDLE;
      stored_id<='0;
      stored_addr<='0;
      
      read_en<=1'b0;
      read_addr<='0;
      
      response_id<='0;
      response_data<='0;
      response_code<=2'b00;
      response_last<=1'b0;
      response_valid<=1'b0;
    end
    else begin
      read_en<=1'b0;//default
      case(state)
        //IDLE state
        IDLE: begin
          if(ar_valid)begin
            stored_id<=ar_id;
            stored_addr<=ar_addr;
            state<=READ;
          end
        end
        
        //READ state
        READ:begin
          read_en<=1'b1;
          read_addr<=stored_addr;
          state<=SEND;
        end
        
        //SEND state
        SEND:begin
          response_id<=stored_id;
          response_data<=read_data;
          response_valid<=1'b0;
          response_last<=1'b1;
          response_valid<=1'b1;
          
          if(response_done)begin
            response_valid<=1'b0;
            state<=IDLE;
          end
        end
        default:begin
          state<=IDLE;
        end
      endcase
    end
  end
endmodule
          
  
       
