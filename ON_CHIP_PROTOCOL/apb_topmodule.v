module apb_topmodule (input pclk,
    input prreset,
    input [8:0] pwdata, 
    input [16:0]paddr,
    input transfer,
    input pwrite,
    output [31:0]prdata,
    output pslverr,
  output [2:0]psel );  
  wire penable;
  wire pready;
  master_apb(.pclk(pclk),.prrset(prrset),.prdata(prdata),.pready(pready),.transfer(transfer),.pslverr(pslverr),.paddr(paddr),.psel(psel),.penable(penable),.pwrite(pwrite),.pwdata(pwdata));
  slave_apb(.pclk(pclk),.prreset(prreset),.prdata(prdata),.pready(pready),.pslverr(pslverr),.paddr(paddr),.psel(psel),.penable(penable),.pwrite(pwrite),.pwdata(pwdata));

endmodule
