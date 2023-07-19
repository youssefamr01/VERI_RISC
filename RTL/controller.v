module controller #(parameter width=3)
(



input wire zero,clk,rst,
input wire [width-1:0] opcode,
input wire [width-1:0] phase,
output reg sel ,rd ,ld_ir ,inc_pc ,halt ,ld_pc ,data_e ,ld_ac ,wr 
 



    
);
reg HALT,ALU_OP,SK_ZER0,jmp,sto;
localparam  integer HLT=0 ,SKZ=1 ,ADD=2 ,AND=3 ,XOR=4 ,LDA=5 ,STO=6 ,JMP=7;
  
always @(*)
begin

    HALT = (opcode == HLT) ;
    ALU_OP = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA);
    SK_ZER0 = (opcode == SKZ && zero );
    jmp = (opcode == JMP  );
    sto = (opcode == STO);

    case(phase)
    0:   begin sel=1; rd=0; ld_ir=0; halt=0 ;inc_pc=0 ;ld_ac=0 ;ld_pc=0 ;wr=0; data_e=0  ; end //INST_ADDR

    1: begin sel=1 ;rd=1;ld_ir=0 ;halt=0 ;inc_pc=0 ;ld_ac=0 ;ld_pc=0 ; wr=0;data_e=0;  end   //INST_FETCH

    2: begin sel=1 ;rd=1;ld_ir=1 ;halt=0 ;inc_pc=0 ;ld_ac=0 ;ld_pc=0 ;wr=0;data_e=0 ; end //INST_LOAD

    3: begin sel=1 ;rd=1;ld_ir=1 ;halt=0 ;inc_pc=0 ;ld_ac=0 ;ld_pc=0 ;wr=0;data_e=0 ; end //IDLE

    4:  begin sel=0 ;rd=0;ld_ir=0 ;halt=HALT ;inc_pc=1 ;ld_ac=0 ;ld_pc=0 ;wr=0;data_e=0 ; end //OP_ADDR

    5:  begin sel=0 ;rd=ALU_OP ;ld_ir=0 ;halt=0 ;inc_pc=0 ;ld_ac=0 ;ld_pc=0 ;wr=0;data_e=0 ; end //OP_FETCH

    6:  begin sel=0 ;rd=ALU_OP ;ld_ir=0 ;halt=0 ;inc_pc=SK_ZER0 ;ld_ac=0 ;ld_pc=jmp ;wr=0;data_e=sto ; end  //ALU_OP

    7:  begin sel=0 ;rd=ALU_OP ;ld_ir=0 ;halt=0 ;inc_pc=0 ;ld_ac=ALU_OP ;ld_pc=jmp ;wr=sto;data_e=sto ; end  // store


    endcase
        
    end

endmodule //controller