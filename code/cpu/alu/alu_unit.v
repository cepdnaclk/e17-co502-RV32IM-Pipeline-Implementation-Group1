/********************************************/
/*  RV32IM Pipeline - Group 1               */
/*  ALU Unit Module              */
/********************************************/

`timescale 1ns/100ps

module alu_unit (DATA1, DATA2, SELECT, RESULT);

    // Define Inputs & Outputs of the unit
    input [31:0] DATA1, DATA2;
    input [4:0] SELECT;
    output [31:0] RESULT;

    // Define Wires to hold intermediate calculations
    wire [31:0] ADD,
                SUB,
                AND
                OR,
                XOR,
                SLL,
                SRL,
                SRA,
                SLT,
                SLTU,
                MUL,
                MULH,
                MULHSU,
                MULHU,
                DIV,
                DIVU,
                REM,
                REMU,
                FWD,
                JTARGET;

    wire [63:0] MULH64,
                MULHSU64;

    reg  [63:0] MULHSU64;


    assign FWD = DATA2; // Forward

    assign #2 JTARGET = DATA1 + DATA2; // JTarget
    assign JTARGET[0] = 0'b0;


    assign #2 ADD = DATA1 + DATA2; // Adding
    assign #2 SUB = DATA1 - DATA2; // subtract
    assign #1 AND = DATA1 & DATA2; // And
    assign #1 OR = DATA1 | DATA2; // Or
    assign #1 XOR = DATA1 ^ DATA2; // Xor

    // Logical left shift on DATA1 by shift amount in DATA2
    assign #2 SLL = DATA1 << DATA2; 
    // Logical right shift on DATA1 by shift amount in DATA2
    assign #2 SRL = DATA1 >> DATA2; 

    // Arithmetic right shift on DATA1 by shift amount in DATA2
    assign #2 SRA = $signed(DATA1) >>> DATA2; 

    // Set RESULT to 1 if DATA1 < DATA2  (signed comparison)
    assign #1 SLT = $signed(DATA1) < $signed(DATA2) ? 1'b1 : 1'b0; // signed comparision
    // Set RESULT to 1 if DATA1 < DATA2 (unsigned comparison)
    assign #1 SLTU = DATA1 < DATA2 ? 1'b1 : 1'b0; // unsigned comparision

    // Multiply DATA1 by DATA2 and output lower 32 bits of the result
    assign #2 MUL = DATA1 * DATA2;

    // Multiply signed DATA1 by signed DATA2 and output the upper 32 bits of the result
    assign #2 MULH64 = $signed(DATA1) * $signed(DATA2); 
    assign MULH = MULH64[63:32];

    // Multiply unsigned DATA1 by unsign
code/cpu/alu/alu_unit.v
ed DATA2 and output the upper 32 bits of the result
    always @ (*)
    begin
        #2
        case ({DATA1[31], DATA2[31]})
            2'b00, 2'b01:
                MULHSU64 = DATA1 * DATA2;
            2'b10:
                MULHSU64 = $signed(DATA1) * $signed(DATA2);

            2'b11:
                MULHSU64 = ~($signed(DATA1) * $unsigned(DATA2)) + 1; // multiplication should be negative
        endcase
    end
    assign MULHSU = MULHSU64[63:32];

    // Multiply unsigned DATA1 by unsigned DATA2 and output the upper 32 bits of the result
    assign #2 MULHU64 = DATA1 * DATA2;
    assign MULHU = MULHU64[63:32];

    // Signed integer division of DATA1 by DATA2
    assign #3 DIV = $signed(DATA1) / $signed(DATA2);

    // Unsigned integer division of DATA1 by DATA2
    assign #3 DIVU = $unsigned(DATA1) / $unsigned(DATA2);

    // Provide remainder of 32 bits by 32 bits signed integer division of DATA1 by DATA2
    assign #3 REM = $signed(DATA1) % $signed(DATA2);

    // Provide remainder of 32 bits by 32 bits unsigned integer division of DATA1 by DATA2
    assign #3 REMU = $unsigned(DATA1) % $unsigned(DATA2);




    /* Send out correct result based on SELECT */
    always @(*) 
    begin
        casez (SELECT)
            // RV32I
            6'b000000:
                RESULT = ADD;
            6'b100001:
                RESULT = JTARGET;
            6'b000001:
                RESULT = SLL;
            6'b000010:
                RESULT = SLT;
            6'b000011:
                RESULT = SLTU;
            6'b000100:
                RESULT = XOR;
            6'b000101:
                RESULT = SRL;
            6'b000110:
                RESULT = OR;
            6'b000111:
                RESULT = AND;
            6'b010000:
                RESULT = SUB;
            6'b010101:
                RESULT = SRA;
            6'b011???:
                RESULT = FWD;

            

            // RV32M
            6'b001000:
                RESULT = MUL;
            6'b001001:
                RESULT = MULH;
            6'b001010:
                RESULT = MULHSU;
            6'b001011:
                RESULT = MULHU;
            6'b001100:
                RESULT = DIV;
            6'b001101:
                RESULT = DIVU;
            6'b001110:
                RESULT = REM;
            6'b001111:
                RESULT = REMU;
            
            default: 
                RESULT = 0;
        endcase
    end
    
endmodule