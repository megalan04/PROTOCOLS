module apb_protocol(input pclk,
    input prreset,
    input [31:0]prdata, 
    input pready,
    input transfer,
    input pslverr,
    input pwrite,
    input [31:0]pwdata,
    input [7:0]padrr,
                    output reg [7:0]addrreg ,               
    output reg psel,
                    output reg [31:0]datareg,
                    output reg en,                
    output reg penable);
    localparam [1:0] idle=2'b00,
                   setup=2'b01,
                   access=2'b10;
    reg[1:0] state,nxt_state;
  always @(posedge pclk or posedge prreset) begin
    if(prreset) 
      state<=idle;
    else
      state<=nxt_state;
  end
   always@(*) begin
     case(state)
       idle:begin
         if(transfer)
           nxt_state=setup;
         else
            nxt_state=idle;
         end
        setup :begin
          nxt_state=access;
        end
        access:begin
          if(pready) begin
             if(transfer)
               nxt_state=setup;
             else
               nxt_state=idle;
            end
           else
             nxt_state=access;
         end
        default:nxt_state=idle;
      endcase
    end
  always@(posedge pclk)begin
    case(state)
      idle:psel=1'b0;
        setup:begin
          addrreg<=padrr;
          datareg<=pwdata;
          en<=pwrite;
          penable<=1'b0;
          psel<=padrr[7];
        end
          access:begin
            addrreg<=addrreg;
             datareg<=datareg;
             en<=en;
            penable<=1'b1;
            psel<=padrr[7];
          end
    endcase
  end
endmodule
