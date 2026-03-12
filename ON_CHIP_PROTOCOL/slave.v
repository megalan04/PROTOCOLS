module slave(input pclk,
    input prreset,
    output reg [31:0]prdata, 
    output reg pready,
    output reg pslverr,
    input pwrite,
    input [31:0]pwdata,
    input [7:0]padrr,
    input psel,
    input penable);
    reg[31:0]mem[127:0];
  always@(posedge pclk)begin
    if(prreset)begin
      pready=1'b1;
      pslverr=1'b0; 
    end
      else begin
        if(penable && psel && pwrite)begin
          mem[padrr[6:0]]<=pwdata;
          pready=1'b1;
      end
    else if(penable && psel && !pwrite)begin
      prdata<=mem[padrr[6:0]];
          pready=1'b1;
    end
        else
          pready=1'b1;
      end
  end
    always@(posedge pclk)begin
      if(penable && psel && pwrite||!pwrite)begin
        if (padrr[6:0]>127)  
          pslverr=1'b1;
      end
    end
endmodule
