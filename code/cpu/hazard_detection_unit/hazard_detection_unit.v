/*******************************/
/*  RV32IM Pipeline - Group 1  */
/*  Hazard Detection Unit      */
/*******************************/

`timescale 1ns/100ps

/* Detects the existence of a load-use data hazard (Hazards
   that occur when a LOAD instruction is followed by an instruction
   that uses the loaded value). This unit asserts the LU_HAZ_SIG line
   when a hazard is detected so that a NOP bubble can be added.
*/
module hazard_detection_unit (
    ID_ADDR1, ID_ADDR2,
    ID_OPERAND1_SELECT, ID_OPERAND2_SELECT,
    EX_REG_WRITE_ADDR, EX_DATA_MEM_READ,
    LU_HAZ_SIG
);
    
    input [4:0] ID_ADDR1, ID_ADDR2, EX_REG_WRITE_ADDR;
    input ID_OPERAND1_SELECT, ID_OPERAND2_SELECT, EX_DATA_MEM_READ;
    output reg LU_HAZ_SIG;

    always @ (*)
    begin
        if (EX_DATA_MEM_READ)
            // Set if instruction in ID uses loaded value as OP1 or OP2
            LU_HAZ_SIG = (!ID_OPERAND1_SELECT && (ID_ADDR1 === EX_REG_WRITE_ADDR)) ||    
                            (!ID_OPERAND2_SELECT && (ID_ADDR2 === EX_REG_WRITE_ADDR));
    end

endmodule