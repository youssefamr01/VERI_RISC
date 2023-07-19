module counter #(parameter WIDTH=5)
(
    input wire [WIDTH-1:0]cnt_in,
    input wire enab, load ,clk,rst, 
    output reg [WIDTH-1:0] cnt_out

);
 reg [WIDTH-1:0] count;
always @(*) begin
    if (rst)
    cnt_out= 0;
    else if (load)
    count = cnt_in;
    else if(enab)
    count<=cnt_out +1;
    else
    count<=cnt_out;
    end
always @(posedge clk ) begin
    cnt_out <= count;  
end
 




endmodule //counter