/*******************************/
/*  RV32IM Pipeline - Group 1  */
/*  Control Unit Module        */
/*******************************/

`timescale 1ns/100ps


module control_unit (
    INSTRUCTION, MEM_READ, MEM_WRITE, REG_WRITE_EN, 
    WB_VALUE_SELECT, ALU_SELECT, OP1_SEL, OP2_SEL, 
    BRANCH_CTRL, IMM_SELECT
);

    // Define input/output ports
    input [31:0] INSTRUCTION;
    output [4:0] ALU_SELECT;
    output [3:0] MEM_READ, BRANCH_CTRL;
    output [2:0] MEM_WRITE, IMM_SELECT;
    output [1:0] WB_VALUE_SELECT;
    output REG_WRITE_EN, OP1_SEL, OP2_SEL;

    // Instruction control segments
    wire [6:0] OPCODE, FUNCT7;
    wire [2:0] FUNCT3;

    // Extract the control segments
    assign OPCODE = INSTRUCTION[6:0];
    assign FUNCT3 = INSTRUCTION[14:12];
    assign FUNCT7 = INSTRUCTION[31:25];


    /**************************** Register write enable signal ****************************/
    // Set for all instructions other than BRANCH and STORE
    assign #1 REG_WRITE_EN = ~(
        (OPCODE === 7'b1100011) |   // BRANCH
        (OPCODE === 7'b0100011)     // STORE
    );


    /**************************** Immediate select signal ****************************/
    assign #1 IMM_SELECT = 
        (OPCODE === 7'b0110111) ? 3'b000 :      // LUI (U-type)
        (OPCODE === 7'b0010111) ? 3'b000 :      // AUIPC (U-type)
        (OPCODE === 7'b1101111) ? 3'b001 :      // JAL (J-type)
        (OPCODE === 7'b1100111) ? 3'b010 :      // JALR (I-type)
        (OPCODE === 7'b0000011) ? 3'b010 :      // LOAD (I-type)
        (OPCODE === 7'b1100011) ? 3'b011 :      // BRANCH (B-type)
        (OPCODE === 7'b0100011) ? 3'b100 :      // STORE (S-type)
        (OPCODE === 7'b0010011) ? 3'b010 : 3'bxxx;     // All other I-type (ADDI, ANDI, ORI, etc...)


    /**************************** OPERAND MUX select signals ****************************/
    // Set OPERAND1 to PC for these instructions
    assign #1 OP1_SEL =
        (OPCODE === 7'b0010111) |   // AUIPC
        (OPCODE === 7'b1101111) |   // JAL
        (OPCODE === 7'b1100011);    // BRANCH

    // Set OPERAND2 to IMMEDIATE for these instructions
    assign #1 OP2_SEL = 
        (OPCODE === 7'b0110111) |   // LUI
        (OPCODE === 7'b0010111) |   // AUIPC
        (OPCODE === 7'b1101111) |   // JAL
        (OPCODE === 7'b1100111) |   // JALR
        (OPCODE === 7'b0000011) |   // LOAD
        (OPCODE === 7'b1100011) |   // BRANCH
        (OPCODE === 7'b0100011) |   // STORE
        (OPCODE === 7'b0010011);    // All other I-type (ADDI, ANDI, ORI, etc...) 

    /**************************** ALU function  select signal ****************************/
    assign #1 ALU_SELECT[2:0] = 
        (
            // Force selection of ADD function
            (OPCODE === 7'b0110111) |   // LUI
            (OPCODE === 7'b0010111) |   // AUIPC
            (OPCODE === 7'b1101111) |   // JAL
            (OPCODE === 7'b1100011) |   // BRANCH
            (OPCODE === 7'b0000011) |   // LOAD
            (OPCODE === 7'b0100011)     // STORE
        ) ? 3'b000 :
        (OPCODE === 7'b1100111) ? // JALR (Force selection of JTARGET function)
            3'b001 : FUNCT3;    // All other instructions use funct3 as is

    assign #1 ALU_SELECT[3] =
        (OPCODE === 7'b0110111) |       // LUI
        (OPCODE === 7'b1100111) |       // JALR
        ({OPCODE, FUNCT7} === {7'b0110011, 7'b0000001});    // RV32M

    assign #1 ALU_SELECT[4] =
        (OPCODE === 7'b0110111) |       // LUI
        ({OPCODE, FUNCT3, FUNCT7} === {7'b0110011, 3'b000, 7'b0100000}) |   // SUB
        ({OPCODE, FUNCT3, FUNCT7} === {7'b0110011, 3'b101, 7'b0100000}) |   // SRA
        ({OPCODE, FUNCT3, FUNCT7} === {7'b0010011, 3'b101, 7'b0100000});    // SRAI

    
    /**************************** Branch Control Unit select signal ****************************/
    // MSB of BRANCH_CTRL must be set for branch/jump instructions
    assign #1 BRANCH_CTRL[3] = 
        (OPCODE === 7'b1101111) |   // JAL
        (OPCODE === 7'b1100111) |   // JALR
        (OPCODE === 7'b1100011);    // BRANCH

    // Lower bits are set to 010 for JUMP instructions
    // and FUNCT3 for other instructions
    assign #1 BRANCH_CTRL[2:0] = 
        ((OPCODE === 7'b1101111) || (OPCODE === 7'b1100111)) ?      // JAL, JALR
            3'b010 : FUNCT3;


    /**************************** Data memory control signals ****************************/
    // Data memory read signal
    assign #1 MEM_WRITE[2] = (OPCODE === 7'b0100011);   // Set MSB for STORE instructions
    assign #1 MEM_WRITE[1:0] = FUNCT3[1:0];     // Lower bits are derived from FUNCT3

    // Data memory write signal
    assign #1 MEM_READ[3] = (OPCODE === 7'b0000011);    // Set MSB for LOAD instructions
    assign #1 MEM_READ[2:0] = FUNCT3;   // Lower bits are derived from FUNCT3


    /**************************** Writeback value select signal ****************************/
    assign #1 WB_VALUE_SELECT = 
        ((OPCODE == 7'b1101111) | (OPCODE == 7'b1100111)) ? 2'b00 :   // JAL, JALR (PC)
        (OPCODE == 7'b0000011) ? 2'b01 :        // LOAD (Mem output)
        2'b10;      // Everything else (ALU output)


endmodule