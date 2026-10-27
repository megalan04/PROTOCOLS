module axi_b #(parameter ID_WIDTH=4
                      )(input logic ACLK,
                       input logic ARESETn,
                       
                       //write control logic
                        input logic[ID_WIDTH-1:0] response_id,
                        input logic[1:0] response_code,
                       input logic response_valid,
                       
                        //axi response(b) 
                        output logic [ID_WIDTH-1:0] BID,
                        output logic[1:0] BRESP,
                       output logic BVALID,
                        input BREADY);
  always_ff @(posedge ACLK)begin
    if(!ARESETn)begin
      BID<='0;
      BRESP<=2'b00;
      BVALID<=1'b0;
    end
    else begin
      if(response_valid && !BVALID)begin
        BID<=response_id;
        BRESP<=response_code;
        BVALID<=1'b1;
      end
      if(BVALID && BREADY)begin
        BVALID<=1'b0;
      end
    end
  end
  
endmodule
