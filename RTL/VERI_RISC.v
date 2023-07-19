
`include "alu.v"
`include "counter.v"
`include "memory.v"
`include "multiplexor.v"
`include "register.v"
`include "tristate_buffer.v"
`include "controller.v"

//default_nettype none
module VERI_RISC 
(
 input wire clk,
 input wire rst,
 output wire halt
);

localparam integer AWIDTH =5 ,DWIDTH =8;

wire [2:0] phase;
wire [2:0] opcode ;
wire [AWIDTH-1:0] ir_addr,pc_addr;
wire [AWIDTH-1:0] addr;
wire [DWIDTH-1:0] data;
wire [DWIDTH-1:0] alu_out,acc_out;





//wire [2:0] opcode ;
//////////////////////// controller    //////////////////
controller controller_inst
( 
    .opcode(opcode),
    .phase(phase),
    .zero(zero),
    .sel(sel),
    .rd(rd),
    .ld_ir(ld_ir),
    .inc_pc(inc_pc),
    .halt(halt),
    .ld_pc(ld_pc),
    .data_e(data_e),
    .ld_ac(ld_ac),
    .wr(wr)
);

/////////////////////////    counter ///////////////////
//wire [AWIDTH-1:0] ir_addr,pc_addr;

counter
 #(.WIDTH (AWIDTH) )
counter_pc(
    .clk(clk),
    .rst (rst ),
    .load (ld_pc),
    .enab (inc_pc),
    .cnt_in (ir_addr),
    .cnt_out(pc_addr)
    
);

////////////////// multiplexor //////////////
//wire [AWIDTH-1:0] addr;

multiplexor
 #( .WIDTH(AWIDTH))
address_mux (
    .sel (sel),
    .in0 (ir_addr),
    .in1 (pc_addr),
    .mux_out(addr)
);



/////////////////////// memory //////////////
//wire [DWIDTH-1:0] data;
memory
 #(
    .AWIDTH( AWIDTH ),
    .DWIDTH( DWIDTH )
    )
memory_inst(
    .clk(clk),
    .wr(wr),
    .rd(rd),
    .addr(addr),
    .data(data)
);

////////////////////////    register_ir /////////

register
 #(.WIDTH(DWIDTH))
register_ir (
    .clk(clk),
    .rst(rst),
    .load(ld_ir),
    .data_in(data),
    .data_out({opcode,ir_addr})
);




/////////////////////////   alu     / ///////////////////////////////
//wire [DWIDTH-1:0] alu_out,acc_out;

alu 
#(.WIDTH (DWIDTH) )
alu_inst(
    .opcode (opcode ),
    .in_a (acc_out),
    .in_b (data),
    .a_is_zero (zero),
    .alu_out (alu_out)
    );







///////////////////////   register_ac ////////////

register
 #(.WIDTH(DWIDTH))
register_ac (
    .clk(clk),
    .rst(rst),
    .load(ld_ac),
    .data_in(alu_out),
    .data_out(acc_out)
);


 ///////////////////////////////  trisate_buffer ////////
tristate_buffer #( .WIDTH(DWIDTH))
driver_inst (
    .data_en(data_e),
    .data_in(alu_out),
    .data_out(data)
);



//wire [2:0] phase;
//////////////////////clk counter/////////
counter
 #(
    .WIDTH(3)
    
   )

 counter_clk( 
    .clk(clk),
    .rst(rst),
    .load(1'b0),
    .enab(!halt),
    .cnt_in(3'b0),
    .cnt_out(phase)
);





endmodule //VERI_RISC