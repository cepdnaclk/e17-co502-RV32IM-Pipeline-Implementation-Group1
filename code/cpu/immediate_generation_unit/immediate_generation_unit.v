/********************************************/
/*  RV32IM Pipeline - Group 1               */
/*  Immediate Generation Unit Module        */
/********************************************/

`timescale 1ns/100ps

module immediate_generation_unit (INSTRUCTION, SELECT, OUT);

    // Define input/output ports
    input [31:0] INSTRUCTION;
    input [2:0] SELECT;
    output reg [31:0] OUT;

    wire [31:0] U_IMM, J_IMM, I_IMM, B_IMM, S_IMM;

    // Construct the immediate based on the instruction
    assign U_IMM = {INSTRUCTION[31:12], 12'b0};
    assign J_IMM = {{12{INSTRUCTION[31]}}, INSTRUCTION[19:12], INSTRUCTION[20], INSTRUCTION[30:21], 1'b0};
    assign I_IMM = {{21{INSTRUCTION[31]}}, INSTRUCTION[30:20]};
    assign B_IMM = {{20{INSTRUCTION[31]}}, INSTRUCTION[7], INSTRUCTION[30:25], INSTRUCTION[11:8], 1'b0};
    assign S_IMM = {{21{INSTRUCTION[31]}}, INSTRUCTION[30:25], INSTRUCTION[11:7]};

    // Assign to output
    always @ (*)
    begin
        case (SELECT)
            3'b000:
                OUT = U_IMM;
            3'b001:
                OUT = J_IMM;
            3'b010:
                OUT = I_IMM;
            3'b011:
                OUT = B_IMM;
            3'b100:
                OUT = S_IMM;
            default:
                OUT = 32'b0;
        endcase
    end

endmodule