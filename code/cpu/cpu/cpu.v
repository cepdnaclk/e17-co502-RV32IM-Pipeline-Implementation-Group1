`include "alu/alu.v"
`include "reg_file/reg_file.v"

`include "immediate_generation_unit/immediate_generation_unit.v"
`include "control_unit/control_unit.v"
`include "branch_control_unit/branch_control_unit.v"

`include "pipeline_registers/pr_if_id.v"
`include "pipeline_registers/pr_id_ex.v"
`include "pipeline_registers/pr_ex_mem.v"
`include "pipeline_registers/pr_mem_wb.v"

`include "support_modules/plus_4_adder.v"
`include "support_modules/mux_4to1_32bit.v"
`include "support_modules/mux_2to1_32bit.v"

`timescale 1ns/100ps

module cpu (
    CLK, RESET, PC, INSTRUCTION, DATA_MEM_READ, DATA_MEM_WRITE,
    DATA_MEM_ADDR, DATA_MEM_WRITE_DATA, DATA_MEM_READ_DATA,
    DATA_MEM_BUSYWAIT, INSTR_MEM_BUSYWAIT
);

    input CLK, RESET;                               // Clock and reset pins
    input DATA_MEM_BUSYWAIT, INSTR_MEM_BUSYWAIT;    // Busywait signals
    input [31:0] INSTRUCTION;           // Instruction fetched from instruction memory
    input [31:0] DATA_MEM_READ_DATA;    // Data fetched from data memory

    output [2:0] DATA_MEM_WRITE;    // Write control signal for data memory
    output [3:0] DATA_MEM_READ;     // Read control signal for data memory
    output [31:0] DATA_MEM_ADDR, DATA_MEM_WRITE_DATA;   // Address line and data out to data memory
    output reg [31:0] PC;               // Program Counter

    /******************* Connection wires *******************/
    // IF
    wire [31:0] PC_PLUS_4, PC_NEXT;

    // ID
    wire [31:0] ID_PC, ID_INSTRUCTION, ID_REG_DATA1, ID_REG_DATA2, ID_IMMEDIATE;
    wire [4:0] ID_ALU_SELECT;
    wire [3:0] ID_DATA_MEM_READ, ID_BRANCH_CTRL;
    wire [2:0] ID_DATA_MEM_WRITE, ID_IMMEDIATE_SELECT;
    wire [1:0] ID_WB_VALUE_SELECT;
    wire ID_REG_WRITE_EN, ID_OPERAND1_SELECT, ID_OPERAND2_SELECT;

    // EX
    wire [31:0] EX_PC, EX_IMMEDIATE, EX_REG_DATA1, EX_REG_DATA2,
                EX_ALU_DATA1, EX_ALU_DATA2, EX_ALU_OUT;
    wire [4:0] EX_ALU_SELECT;
    wire [4:0] EX_REG_WRITE_ADDR;
    wire [3:0] EX_DATA_MEM_READ, EX_BRANCH_CTRL;
    wire [2:0] EX_DATA_MEM_WRITE;
    wire [1:0] EX_WB_VALUE_SELECT;
    wire EX_REG_WRITE_EN, EX_OPERAND1_SELECT, EX_OPERAND2_SELECT, EX_BJ_SIG;

    // MEM
    wire [31:0] MEM_PC, MEM_PC_PLUS_4, MEM_ALU_OUT, MEM_REG_DATA2;
    wire [4:0] MEM_REG_WRITE_ADDR;
    wire [3:0] MEM_DATA_MEM_READ;
    wire [2:0] MEM_DATA_MEM_WRITE;
    wire [1:0] MEM_WB_VALUE_SELECT;
    wire MEM_REG_WRITE_EN, MEM_WRITE_DATA_SEL;

    // WB
    wire [31:0] WB_PC, WB_ALU_OUT, WB_DATA_MEM_READ_DATA, WB_WRITEBACK_VALUE;
    wire [4:0] WB_REG_WRITE_ADDR; 
    wire [1:0] WB_WB_VALUE_SELECT;
    wire WB_REG_WRITE_EN;


    /****************************************** TODO: IF stage ******************************************/


    /****************************************** TODO: IF / ID ******************************************/


    /****************************************** TODO: ID stage ******************************************/


    /****************************************** TODO: ID / EX ******************************************/



    /****************************************** TODO: EX stage ******************************************/


    /****************************************** TODO: EX / MEM ******************************************/


    /****************************************** TODO: MEM stage ******************************************/



    /****************************************** TODO: MEM / WB ******************************************/


    /****************************************** TODO: WB stage ******************************************/




    // PC Update
    always @ (posedge CLK)
    begin
        if (RESET == 1'b1)      // Reset PC to zero if RESET is asserted
            PC <= #1 32'd0;
        else if (!INSTR_MEM_BUSYWAIT || !DATA_MEM_BUSYWAIT)     // Stall PC if BUSYWAIT is asserted
            PC <= #1 PC_NEXT;
    end

endmodule