/*******************************/
/*  RV32IM Pipeline - Group 1  */
/*  Register File Module       */
/*******************************/

`timescale 1ns/100ps

module reg_file (DATA_IN, DATA_OUT1, DATA_OUT2, IN_ADDR, OUT1_ADDR, OUT2_ADDR, WRITE_EN, CLK, RESET);

    // Define input/output ports
    input WRITE_EN, CLK, RESET;
    input [4:0] IN_ADDR, OUT1_ADDR, OUT2_ADDR;
    input [31:0] DATA_IN;
    output [31:0] DATA_OUT1, DATA_OUT2;

    // Define 32x32-bit registers
    reg [31:0] REGISTERS [31:0];

    // Reads must happen asynchronously
    assign #2 DATA_OUT1 = REGISTERS[OUT1_ADDR];
    assign #2 DATA_OUT2 = REGISTERS[OUT2_ADDR];

    // Writes must happen on the negative clock edge
    integer i;
    always @ (negedge CLK) 
    begin
        if (RESET)
            for (i = 0; i < 32; i = i + 1)
                REGISTERS[i] <= #1 0;       // Write zero to all the registers
        else
            if (WRITE_EN && (IN_ADDR !== 5'd0))     // Register x0 cannot be written to
                REGISTERS[IN_ADDR] <= #1 DATA_IN;
    end

endmodule