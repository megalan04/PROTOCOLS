module topmodule_tb;
    reg pclk;
    reg prreset;
  reg [31:0] pwdata; 
    reg [7:0]paddr;
    reg transfer;
    reg pwrite;
    wire [31:0]prdata;
    wire pslverr;
    wire psel; 
  wire penable;
  apb_topmodule dut(.*);
  initial begin
    pclk=1;
    forever #5 pclk=~pclk;
  end
  initial begin
    prreset=1;
    #10 prreset=0;
    transfer=1;
    pwrite=1;
    pwdata=8'd8;
    paddr=8'b11001010;
    #10  pwdata=8'd8; paddr=8'b11100101;
    #10 pwdata=8'd1; paddr=8'b11100010;
    #10  pwdata=8'd2; paddr=8'b11000010;
    #10  pwdata=8'd3; paddr=8'b11001010;
    #10  pwdata=8'd4; paddr=8'b01111111;
    #10  pwrite=0;
    #10  pwdata=8'd8;paddr=8'b11100101;
    #10  pwdata=8'd1;paddr=8'b11100010;
    #10  pwdata=8'd2;paddr=8'b11000010;
    #10  pwdata=8'd3;paddr=8'b11001010;
    #10  pwdata=8'd4; paddr=8'b01111111;
    #10  pwdata=8'd7;paddr=8'b11111111;
    #10  pwdata=8'd1;paddr=8'b11101111;
    #10 $finish;
  end
  initial begin
    $monitor("time=%0t, INPUT VALUES: pclk=%b;prreset=%b;pwdata=%d;paddr=%d;transfer=%b;pwrite=%d, OUTPUT VALUES: prdata=%d;pslverr=%b;psel=%b;penable=%b",$time,pclk,prreset,pwdata,paddr,transfer,pwrite,prdata,pslverr,psel,penable);
    $dumpfile("apb_topmodule.vcd");
    $dumpvars;
  end
endmodule
