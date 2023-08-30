/*******************************/
/*  RV32IM Pipeline - Group 1  */
/*  Branch Control Unit        */
/*******************************/

`timescale 1ns/100ps

module branch_control_unit (DATA1, DATA2, SELECT, PC_MUX_OUT);

    // Define Inputs & Outputs of the unit
    input [31:0] DATA1, DATA2;
    input [3:0] SELECT;
    output reg PC_MUX_OUT;

    // Define Wires to hold intermediate calculations
    wire BEQ, BNE, BLT, BGE, BLTU, BGEU;

    // Comparison calculations
    assign BEQ = DATA1 == DATA2;
    assign BNE = DATA1 != DATA2;
    assign BLT = $signed(DATA1) < $signed(DATA2);
    assign BGE = $signed(DATA1) >= $signed(DATA2);
    assign BLTU = $unsigned(DATA1) < $unsigned(DATA2);
    assign BGEU = $unsigned(DATA1) >= $unsigned(DATA2);

    always @ (*)
    begin
        #1  // delay of 1 time unit 
        if (SELECT[3])      // for branch/jump instruction
        begin
            case (SELECT[2:0])
                // for JAL and JALR
                3'b010:
                    PC_MUX_OUT = 1'b1; 
                // for BEQ
                3'b000:
                    PC_MUX_OUT = BEQ;
                // for BNE
                3'b001:
                    PC_MUX_OUT = BNE;
                // for BLT
                3'b100:
                    PC_MUX_OUT = BLT;
                // for BGE
                3'b101:
                    PC_MUX_OUT = BGE;
                // for BLTU
                3'b110:
                    PC_MUX_OUT = BLTU; 
                // for BGEU
                3'b111:
                    PC_MUX_OUT = BGEU; 
                default:
                    PC_MUX_OUT = 1'b0;
            endcase
        end
        else
        begin
            PC_MUX_OUT = 1'b0;
        end
    end
    
endmodule