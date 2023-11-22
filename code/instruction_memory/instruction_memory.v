`timescale 1ns/100ps

module instruction_memory (CLK, READ, ADDRESS, READDATA, BUSYWAIT);

// insutruction memory with 1024 bytes
// byte addressing
// serve data blocks of 16 bytes (4 words)
// 28 bit to address a block
// .bin file - 1024 bytes of instruction data
// 40 time units to simulate block fetching delay

    input CLK, READ;
    // input   [31:0]    ADDRESS;
    // output reg [31:0]   READDATA;
    input [27:0] ADDRESS; // 28 bit memory blocks
    output reg [127:0] READDATA; // 128 bit block size
    output reg BUSYWAIT;


    reg READ_ACCESS;

    // Declare memory array 1024 x 8 bits
    reg [7:0] memory_array [0:1023];
 
    initial
    begin
        $readmemb("../../build/test_prog.bin", memory_array);

        BUSYWAIT = 0;
        READ_ACCESS = 0; 
    end

    //Detecting an incoming memory access
    always @(READ)
    begin
        BUSYWAIT = (READ)? 1 : 0;
        READ_ACCESS = (READ)? 1 : 0;
    end
    
    //Reading
    always @(posedge CLK)
    begin
        if(READ_ACCESS)
        begin
            READDATA[7:0]     = #40 memory_array[{ADDRESS,4'b0000}];
            READDATA[15:8]    = #40 memory_array[{ADDRESS,4'b0001}];
            READDATA[23:16]   = #40 memory_array[{ADDRESS,4'b0010}];
            READDATA[31:24]   = #40 memory_array[{ADDRESS,4'b0011}];
            READDATA[39:32]   = #40 memory_array[{ADDRESS,4'b0100}];
            READDATA[47:40]   = #40 memory_array[{ADDRESS,4'b0101}];
            READDATA[55:48]   = #40 memory_array[{ADDRESS,4'b0110}];
            READDATA[63:56]   = #40 memory_array[{ADDRESS,4'b0111}];
            READDATA[71:64]   = #40 memory_array[{ADDRESS,4'b1000}];
            READDATA[79:72]   = #40 memory_array[{ADDRESS,4'b1001}];
            READDATA[87:80]   = #40 memory_array[{ADDRESS,4'b1010}];
            READDATA[95:88]   = #40 memory_array[{ADDRESS,4'b1011}];
            READDATA[103:96]  = #40 memory_array[{ADDRESS,4'b1100}];
            READDATA[111:104] = #40 memory_array[{ADDRESS,4'b1101}];
            READDATA[119:112] = #40 memory_array[{ADDRESS,4'b1110}];
            READDATA[127:120] = #40 memory_array[{ADDRESS,4'b1111}];
            BUSYWAIT = 0;
            READ_ACCESS = 0;
        end
    end
    

endmodule