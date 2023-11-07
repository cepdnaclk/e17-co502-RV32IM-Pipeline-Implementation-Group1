
`timescale 1ns/100ps

/* This module is to detect load-use data hazard (when a LOAD instruction followed by an 
instruction that uses the loaded value). This unit asserts the LU_HAZ_SIG line when the hazzard is detected
so that a NOP bubble can be added.

Eg. 
lw $t2, 4($t0)
add $t3, $t1, $t2

|
|

lw $t2, 4($t0)
NOP
add $t3, $t1, $t2

*/
module haz_detect_unit (
    ID_ADDR1,
    ID_ADDR2,
    EX_W_ADDR,
    EX_MEM_READ,
    ID_OP1_SEL,
    ID_OP2_SEL
);

    input[4:0]  ID_ADDR1, ID_ADDR2, EX_W_ADDR;
    input  ID_OP1_SEL, ID_OP2_SEL, EX_MEM_READ;

    output reg LU_HAZ_SIG;

    always @ (*)
    begin
        if (EX_MEM_READ)
            // set if the instruction in ID uses loaded value for op1 or op2
            LU_HAZ_SIG = ( !ID_OP1_SEL && (ID_ADDR1 === EX_W_ADDR)) || 
                    ( !ID_OP2_SEL && (ID_ADDR2 === EX_W_ADDR))
        else
            LU_HAZ_SIG = 1'b0;
    end
    
endmodule