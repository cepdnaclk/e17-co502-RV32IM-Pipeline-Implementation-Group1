
`timescale 1ns/100ps

module pr_flush_unit (
    IF_ID_RES,
    IF_ID_HOLD,
    ID_EX_RES,
    LU_HAZ_SIG,
    BJ_SIG
);

input BJ_SIG, LU_HAZ_SIG;
output IF_ID_HOLD, IF_ID_RES, ID_EX_RES;


// If there is a branch/jumb, IF/ID PR must be reset
// If there is a load use hazard, IF/ID PR must hold its value
assign IF_ID_RES = BJ_SIG;
assign IF_ID_HOLD = !BJ_SIG && LU_HAZ_SIG;

// if there either a branch or jumb or load use hazard occurs.
// ID / EX must be reset
assign ID_EX_RES = BJ_SIG || LU_HAZ_SIG;

    
endmodule