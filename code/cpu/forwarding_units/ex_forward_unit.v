`timescale 1ns/100ps

module ex_forward_unit(
    ADDR1, ADDR2,
    MEM_ADDR, MEM_W_EN,
    WB_ADDR, WB_W_EN,
    OP1_FWD_SEL, OP2_FWD_SEL
);
    input MEM_W_EN, WB_W_EN;
    input [4:0] ADDR1, ADDR2, MEM_ADDR, WB_ADDR;
    output [1:0] OP1_FWD_SEL, OP2_FWD_SEL;

    always @ (*)
    begin
        // Forwarding for operand 1 of the ALU
        if (MEM_W_EN && ADDR1 === MEM_ADDR)
            OP1_FWD_SEL = 2'b01;    // Get value from MEM stage
        else if (WB_W_EN && ADDR1 === WB_ADDR)
            OP1_FWD_SEL = 2'b10;    // Get value from WB stage
        else
            OP1_FWD_SEL = 2'b00;    // No forwarding
        
        // Forwarding for operand 2 of the ALU
        if (MEM_W_EN && ADDR2 === MEM_ADDR)
            OP2_FWD_SEL = 2'b01;    // Get value from MEM stage
        else if (WB_W_EN && ADDR2 === WB_ADDR)
            OP2_FWD_SEL = 2'b10;    // Get value from WB stage
        else
            OP2_FWD_SEL = 2'b00;    // No forwarding

    end

endmodule