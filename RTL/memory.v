module memory #(
parameter AWIDTH =5,
parameter DWIDTH=8)
(


input   wire [AWIDTH-1:0] addr ,
input wire clk,wr ,rd,
inout wire [DWIDTH-1:0] data
    
);
reg [DWIDTH-1:0] array[0:2**AWIDTH-1];
reg [DWIDTH-1:0]temp;

always @(posedge clk ) begin
    if (wr)
        array[addr]= data;
  
end
    
assign data= rd? array[addr]:'bz;

endmodule //memory