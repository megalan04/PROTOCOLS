`include "master.v"
`include "slave.v"
module apb_topmodule (input pclk,
    input prreset,
    input [31:0] pwdata, 
    input [7:0]paddr,
    input transfer,
    input pwrite,
    output [31:0]prdata,
    output pslverr,
    output psel ,
    output penable);  
  wire pready;
  wire [7:0]addrreg;
  wire [31:0]datareg;
  wire en;
  apb_protocol m1(.pclk(pclk),.prreset(prreset),.prdata(prdata),.pready(pready),.transfer(transfer),.pslverr(pslverr),.padrr(paddr),.psel(psel),.penable(penable),.pwrite(pwrite),.pwdata(pwdata),.addrreg(addrreg),.datareg(datareg),.en(en));
  slave  s1(.pclk(pclk),.prreset(prreset),.prdata(prdata),.pready(pready),.pslverr(pslverr),.padrr(addrreg),.psel(psel),.penable(penable),.pwrite(en),.pwdata(datareg));

endmodule
