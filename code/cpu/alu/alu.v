/*******************************/
/*  RV32IM Pipeline - Group 1  */
/*  ALU                        */
/*******************************/

`timescale 1ns/100ps

module alu (DATA1, DATA2, RESULT, SELECT);

    // Define Inputs & Outputs of the unit
    input [31:0] DATA1, DATA2;
    input [4:0] SELECT;
    output reg [31:0] RESULT;

    // Define Wires to hold intermediate calculations
    wire [31:0] ADD,
                SUB,
                AND,
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

    // 64-bit intermediates to hold results of multiplications
    wire [63:0] MULH64,
                MULHU64;
    reg  [63:0] MULHSU64;


    assign #1 FWD = DATA2; // Forward

    assign #2 ADD = DATA1 + DATA2; // Adding
    assign #2 SUB = DATA1 - DATA2; // subtract
    assign #1 AND = DATA1 & DATA2; // And
    assign #1 OR = DATA1 | DATA2; // Or
    assign #1 XOR = DATA1 ^ DATA2; // Xor

    // JTARGET (Target calculation for JALR instruction)
    assign JTARGET = {ADD[31:1], 1'b0};

    // Logical left shift on DATA1 by shift amount in DATA2
    assign #2 SLL = DATA1 << DATA2; 
    // Logical right shift on DATA1 by shift amount in DATA2
    assign #2 SRL = DATA1 >> DATA2; 

    // Arithmetic right shift on DATA1 by shift amount in DATA2
    assign #2 SRA = $signed(DATA1) >>> DATA2; 

    // Set RESULT to 1 if DATA1 < DATA2  (signed comparison)
    assign #1 SLT = $signed(DATA1) < $signed(DATA2) ? 32'd1 : 32'd0; // signed comparision
    // Set RESULT to 1 if DATA1 < DATA2 (unsigned comparison)
    assign #1 SLTU = $unsigned(DATA1) < $unsigned(DATA2) ? 32'd1 : 32'd0; // unsigned comparison

    // Multiply DATA1 by DATA2 and output lower 32 bits of the result
    assign #2 MUL = DATA1 * DATA2;

    // Multiply signed DATA1 by signed DATA2 and output the upper 32 bits of the result
    assign #2 MULH64 = $signed(DATA1) * $signed(DATA2); 
    assign MULH = MULH64[63:32];

    // Multiply signed DATA1 by unsigned DATA2 and output the upper 32 bits of the result
    always @ (*)
    begin
        #2
        case ({DATA1[31], DATA2[31]})
            2'b00, 2'b01:
                MULHSU64 = DATA1 * DATA2;       // Both operands are positive so no need to mark as signed
            2'b10:
                MULHSU64 = $signed(DATA1) * $signed(DATA2);     // Since second operand is positive anyway, consider as signed

            2'b11:
                MULHSU64 = ~($signed(DATA1) * $unsigned(DATA2)) + 1;    // Multiplication should be negative
        endcase
    end
    assign MULHSU = MULHSU64[63:32];

    // Multiply unsigned DATA1 by unsigned DATA2 and output the upper 32 bits of the result
    assign #2 MULHU64 = $unsigned(DATA1) * $unsigned(DATA2);
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
    always @ (*) 
    begin
        casez (SELECT)
            // RV32I
            5'b00000:
                RESULT = ADD;
            5'b10001:
                RESULT = JTARGET;
            5'b00001:
                RESULT = SLL;
            5'b00010:
                RESULT = SLT;
            5'b00011:
                RESULT = SLTU;
            5'b00100:
                RESULT = XOR;
            5'b00101:
                RESULT = SRL;
            5'b00110:
                RESULT = OR;
            5'b00111:
                RESULT = AND;
            5'b10000:
                RESULT = SUB;
            5'b10101:
                RESULT = SRA;
            5'b11???:
                RESULT = FWD;

            
            // RV32M
            5'b01000:
                RESULT = MUL;
            5'b01001:
                RESULT = MULH;
            5'b01010:
                RESULT = MULHSU;
            5'b01011:
                RESULT = MULHU;
            5'b01100:
                RESULT = DIV;
            5'b01101:
                RESULT = DIVU;
            5'b01110:
                RESULT = REM;
            5'b01111:
                RESULT = REMU;
            
            default: 
                RESULT = 0;
        endcase
    end
    
endmodule