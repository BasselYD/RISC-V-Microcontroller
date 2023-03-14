`timescale 1ns/1ps
module RV32I_tb();

reg     CLK_tb;
reg     RST_tb;

task    Empty_DataMEM;
    integer I;
    begin
        for (I = 0; I < 512; I = I + 1)
            begin
                Processor.DMEM.MEM[I] = 0;
            end
    end
endtask

initial 
    begin
        $dumpfile("RV32I.vcd");
        $dumpvars();

        CLK_tb = 0;

        Empty_DataMEM();

        //addi x1, x1, 27
        Processor.IMEM.MEM[0]   =   8'b0000_0001;
        Processor.IMEM.MEM[1]   =   8'b1011_0000;
        Processor.IMEM.MEM[2]   =   8'b1_000_0000;
        Processor.IMEM.MEM[3]   =   8'b1_00100_11;



        //addi x7, x7, 256
        Processor.IMEM.MEM[4]   =   8'b0001_0000;
        Processor.IMEM.MEM[5]   =   8'b0000_0011;
        Processor.IMEM.MEM[6]   =   8'b1_000_0011;
        Processor.IMEM.MEM[7]   =   8'b1_00100_11;
        

        //sw x1, 0(x7)
        Processor.IMEM.MEM[8]    =   8'b0000_0000;
        Processor.IMEM.MEM[9]    =   8'b0001_0011;
        Processor.IMEM.MEM[10]   =   8'b1010_0000;
        Processor.IMEM.MEM[11]   =   8'b0_01000_11;


        //lw x4, 0(x7)
        Processor.IMEM.MEM[12]   =   8'b0000_0000;
        Processor.IMEM.MEM[13]   =   8'b0000_0011;
        Processor.IMEM.MEM[14]   =   8'b1010_0010;
        Processor.IMEM.MEM[15]   =   8'b0_00000_11;


        //beq x4, x1, 32               
        Processor.IMEM.MEM[16]   =   8'b0000_0010;
        Processor.IMEM.MEM[17]   =   8'b0001_0010;
        Processor.IMEM.MEM[18]   =   8'b0000_0000;
        Processor.IMEM.MEM[19]   =   8'b0_11000_11;


        //addi x1, x0, 255
        Processor.IMEM.MEM[20]   =   8'b0000_1111;
        Processor.IMEM.MEM[21]   =   8'b1111_0000;
        Processor.IMEM.MEM[22]   =   8'b0_000_0000;
        Processor.IMEM.MEM[23]   =   8'b1_00100_11;


        //addi x1, x0, 42
        Processor.IMEM.MEM[48]   =   8'b0000_0010;
        Processor.IMEM.MEM[49]   =   8'b1010_0000;
        Processor.IMEM.MEM[50]   =   8'b0_000_0000;
        Processor.IMEM.MEM[51]   =   8'b1_00100_11;


        //lui x6, 0x10000
        Processor.IMEM.MEM[52]   =   8'b1000_0000;
        Processor.IMEM.MEM[53]   =   8'b0000_0000;
        Processor.IMEM.MEM[54]   =   8'b0000_0011;
        Processor.IMEM.MEM[55]   =   8'b0_01101_11;


        //slti x2, x6, 256
        Processor.IMEM.MEM[56]   =   8'b0001_0000;
        Processor.IMEM.MEM[57]   =   8'b0000_0011;
        Processor.IMEM.MEM[58]   =   8'b0010_0001;
        Processor.IMEM.MEM[59]   =   8'b0_00100_11;


        //sltiu x2, x6, 256
        Processor.IMEM.MEM[60]   =   8'b0001_0000;
        Processor.IMEM.MEM[61]   =   8'b0000_0011;
        Processor.IMEM.MEM[62]   =   8'b0011_0001;
        Processor.IMEM.MEM[63]   =   8'b0_00100_11;

                                     
        //xori x2, x1, 51            011001
        Processor.IMEM.MEM[64]   =   8'b0000_0011;
        Processor.IMEM.MEM[65]   =   8'b0011_0000;
        Processor.IMEM.MEM[66]   =   8'b1100_0001;
        Processor.IMEM.MEM[67]   =   8'b0_00100_11;


        //ori x2, x2, 56             111001
        Processor.IMEM.MEM[68]   =   8'b0000_0011;
        Processor.IMEM.MEM[69]   =   8'b1000_0001;
        Processor.IMEM.MEM[70]   =   8'b0110_0001;
        Processor.IMEM.MEM[71]   =   8'b0_00100_11;


        //ori x0, x2, 56             
        Processor.IMEM.MEM[72]   =   8'b0000_0011;
        Processor.IMEM.MEM[73]   =   8'b1000_0001;
        Processor.IMEM.MEM[74]   =   8'b0110_0000;
        Processor.IMEM.MEM[75]   =   8'b0_00100_11;


        //andi x2, x2, 7             000001
        Processor.IMEM.MEM[76]   =   8'b0000_0000;
        Processor.IMEM.MEM[77]   =   8'b0111_0001;
        Processor.IMEM.MEM[78]   =   8'b0111_0001;
        Processor.IMEM.MEM[79]   =   8'b0_00100_11;


        //slli x5, x2, 31            
        Processor.IMEM.MEM[80]   =   8'b0000_0001;
        Processor.IMEM.MEM[81]   =   8'b1111_0001;
        Processor.IMEM.MEM[82]   =   8'b0001_0010;
        Processor.IMEM.MEM[83]   =   8'b1_00100_11;


        //srli x4, x5, 31             
        Processor.IMEM.MEM[84]   =   8'b0000_0001;
        Processor.IMEM.MEM[85]   =   8'b1111_0010;
        Processor.IMEM.MEM[86]   =   8'b1101_0100;
        Processor.IMEM.MEM[87]   =   8'b0_00100_11;


        //srai x2, x5, 31             
        Processor.IMEM.MEM[88]   =   8'b0100_0001;
        Processor.IMEM.MEM[89]   =   8'b1110_0010;
        Processor.IMEM.MEM[90]   =   8'b1101_0001;
        Processor.IMEM.MEM[91]   =   8'b0_00100_11;


        //add x2, x1, x4
        Processor.IMEM.MEM[92]   =   8'b0000_0000;
        Processor.IMEM.MEM[93]   =   8'b0100_0000;
        Processor.IMEM.MEM[94]   =   8'b1_000_0001;
        Processor.IMEM.MEM[95]   =   8'b0_01100_11;


        //sub x2, x1, x4
        Processor.IMEM.MEM[96]   =   8'b0100_0000;
        Processor.IMEM.MEM[97]   =   8'b0100_0000;
        Processor.IMEM.MEM[98]   =   8'b1_000_0001;
        Processor.IMEM.MEM[99]   =   8'b0_01100_11;


        //sll x8, x8, x2            
        Processor.IMEM.MEM[100]   =   8'b0000_0000;
        Processor.IMEM.MEM[101]   =   8'b0010_0100;
        Processor.IMEM.MEM[102]   =   8'b0001_0100;
        Processor.IMEM.MEM[103]   =   8'b0_01100_11;


        //slt x5, x6, x7            
        Processor.IMEM.MEM[104]   =   8'b0000_0000;
        Processor.IMEM.MEM[105]   =   8'b0111_0011;
        Processor.IMEM.MEM[106]   =   8'b0010_0010;
        Processor.IMEM.MEM[107]   =   8'b1_01100_11;


        //sltu x5, x6, x7            
        Processor.IMEM.MEM[108]   =   8'b0000_0000;
        Processor.IMEM.MEM[109]   =   8'b0111_0011;
        Processor.IMEM.MEM[110]   =   8'b0011_0010;
        Processor.IMEM.MEM[111]   =   8'b1_01100_11;


        //xor x5, x1, x2            
        Processor.IMEM.MEM[112]   =   8'b0000_0000;
        Processor.IMEM.MEM[113]   =   8'b0010_0000;
        Processor.IMEM.MEM[114]   =   8'b1100_0010;
        Processor.IMEM.MEM[115]   =   8'b1_01100_11;


        //srl x3, x8, x2            
        Processor.IMEM.MEM[116]   =   8'b0000_0000;
        Processor.IMEM.MEM[117]   =   8'b0010_0100;
        Processor.IMEM.MEM[118]   =   8'b0101_0001;
        Processor.IMEM.MEM[119]   =   8'b1_01100_11;


        //sra x3, x8, x2            
        Processor.IMEM.MEM[120]   =   8'b0100_0000;
        Processor.IMEM.MEM[121]   =   8'b0010_0011;
        Processor.IMEM.MEM[122]   =   8'b0101_0001;
        Processor.IMEM.MEM[123]   =   8'b1_01100_11;


        //sra x3, x8, x2            
        Processor.IMEM.MEM[120]   =   8'b0100_0000;
        Processor.IMEM.MEM[121]   =   8'b0010_0011;
        Processor.IMEM.MEM[122]   =   8'b0101_0001;
        Processor.IMEM.MEM[123]   =   8'b1_01100_11;


        //or x3, x1, x4            
        Processor.IMEM.MEM[124]   =   8'b0000_0000;
        Processor.IMEM.MEM[125]   =   8'b0100_0000;
        Processor.IMEM.MEM[126]   =   8'b1110_0001;
        Processor.IMEM.MEM[127]   =   8'b1_01100_11;


        //and x3, x1, x4            
        Processor.IMEM.MEM[128]   =   8'b0000_0000;
        Processor.IMEM.MEM[129]   =   8'b0100_0000;
        Processor.IMEM.MEM[130]   =   8'b1111_0001;
        Processor.IMEM.MEM[131]   =   8'b1_01100_11;


        //addi x1, x0, 255
        Processor.IMEM.MEM[132]   =   8'b0000_1111;
        Processor.IMEM.MEM[133]   =   8'b1111_0000;
        Processor.IMEM.MEM[134]   =   8'b0_000_0000;
        Processor.IMEM.MEM[135]   =   8'b1_00100_11;


        //sb x1, 4(x7)           
        Processor.IMEM.MEM[136]   =   8'b0000_0000;
        Processor.IMEM.MEM[137]   =   8'b0001_0011;
        Processor.IMEM.MEM[138]   =   8'b1000_0010;
        Processor.IMEM.MEM[139]   =   8'b0_01000_11;


        //add x2, x2, x7
        Processor.IMEM.MEM[140]   =   8'b0000_0000;
        Processor.IMEM.MEM[141]   =   8'b0111_0001;
        Processor.IMEM.MEM[142]   =   8'b0_000_0001;
        Processor.IMEM.MEM[143]   =   8'b0_01100_11;


        //sh x2, 8(x7)              
        Processor.IMEM.MEM[144]   =   8'b0000_0000;
        Processor.IMEM.MEM[145]   =   8'b0010_0011;
        Processor.IMEM.MEM[146]   =   8'b1001_0100;
        Processor.IMEM.MEM[147]   =   8'b0_01000_11;


        //lb x2, 4(x7)              
        Processor.IMEM.MEM[148]   =   8'b0000_0000;
        Processor.IMEM.MEM[149]   =   8'b0100_0011;
        Processor.IMEM.MEM[150]   =   8'b1000_0001;
        Processor.IMEM.MEM[151]   =   8'b0_00000_11;


        //lh x2, 8(x7)              
        Processor.IMEM.MEM[152]   =   8'b0000_0000;
        Processor.IMEM.MEM[153]   =   8'b1000_0011;
        Processor.IMEM.MEM[154]   =   8'b1001_0001;
        Processor.IMEM.MEM[155]   =   8'b0_00000_11;


        //lbu x2, 4(x7)              
        Processor.IMEM.MEM[156]   =   8'b0000_0000;
        Processor.IMEM.MEM[157]   =   8'b0100_0011;
        Processor.IMEM.MEM[158]   =   8'b1100_0001;
        Processor.IMEM.MEM[159]   =   8'b0_00000_11;


        //lhu x2, 8(x7)              
        Processor.IMEM.MEM[160]   =   8'b0000_0000;
        Processor.IMEM.MEM[161]   =   8'b1000_0011;
        Processor.IMEM.MEM[162]   =   8'b1101_0001;
        Processor.IMEM.MEM[163]   =   8'b0_00000_11;


        //jal x2, 40              
        Processor.IMEM.MEM[164]   =   8'b0000_0010;
        Processor.IMEM.MEM[165]   =   8'b1000_0000;
        Processor.IMEM.MEM[166]   =   8'b0000_0001;
        Processor.IMEM.MEM[167]   =   8'b0_11011_11;


        //jalr x2, x2, 4             
        Processor.IMEM.MEM[204]   =   8'b0000_0000;
        Processor.IMEM.MEM[205]   =   8'b0100_0001;
        Processor.IMEM.MEM[206]   =   8'b0000_0001;
        Processor.IMEM.MEM[207]   =   8'b0_11001_11;


        //bne x4, x7, 36              
        Processor.IMEM.MEM[172]   =   8'b0000_0010;
        Processor.IMEM.MEM[173]   =   8'b0111_0010;
        Processor.IMEM.MEM[174]   =   8'b0001_0010;
        Processor.IMEM.MEM[175]   =   8'b0_11000_11;


         //beq x4, x7, 36              
        Processor.IMEM.MEM[208]   =   8'b0000_0010;
        Processor.IMEM.MEM[209]   =   8'b0111_0010;
        Processor.IMEM.MEM[210]   =   8'b0000_0010;
        Processor.IMEM.MEM[211]   =   8'b0_11000_11;


        //blt x6, x7, 40              
        Processor.IMEM.MEM[212]   =   8'b0000_0010;
        Processor.IMEM.MEM[213]   =   8'b0111_0011;
        Processor.IMEM.MEM[214]   =   8'b0100_0100;
        Processor.IMEM.MEM[215]   =   8'b0_11000_11;


        //addi x1, x0, 240
        Processor.IMEM.MEM[216]   =   8'b0000_1111;
        Processor.IMEM.MEM[217]   =   8'b0000_0000;
        Processor.IMEM.MEM[218]   =   8'b0_000_0000;
        Processor.IMEM.MEM[219]   =   8'b1_00100_11;


        //addi x1, x0, 42
        Processor.IMEM.MEM[252]   =   8'b0000_0010;
        Processor.IMEM.MEM[253]   =   8'b1010_0000;
        Processor.IMEM.MEM[254]   =   8'b0_000_0000;
        Processor.IMEM.MEM[255]   =   8'b1_00100_11;


        //bge x7, x6, -36              
        Processor.IMEM.MEM[256]   =   8'b1111_1100;
        Processor.IMEM.MEM[257]   =   8'b0110_0011;
        Processor.IMEM.MEM[258]   =   8'b1101_1110;
        Processor.IMEM.MEM[259]   =   8'b1_11000_11;


        //addi x1, x0, 240
        Processor.IMEM.MEM[260]   =   8'b0000_1111;
        Processor.IMEM.MEM[261]   =   8'b0000_0000;
        Processor.IMEM.MEM[262]   =   8'b0_000_0000;
        Processor.IMEM.MEM[263]   =   8'b1_00100_11;


        //addi x1, x0, -1
        Processor.IMEM.MEM[220]   =   8'b1111_1111;
        Processor.IMEM.MEM[221]   =   8'b1111_0000;
        Processor.IMEM.MEM[222]   =   8'b0_000_0000;
        Processor.IMEM.MEM[223]   =   8'b1_00100_11;


        //bltu x7, x6, 120              
        Processor.IMEM.MEM[224]   =   8'b0000_0110;
        Processor.IMEM.MEM[225]   =   8'b0110_0011;
        Processor.IMEM.MEM[226]   =   8'b1110_1100;
        Processor.IMEM.MEM[227]   =   8'b0_11000_11;


        //addi x1, x0, 240
        Processor.IMEM.MEM[228]   =   8'b0000_1111;
        Processor.IMEM.MEM[229]   =   8'b0000_0000;
        Processor.IMEM.MEM[230]   =   8'b0_000_0000;
        Processor.IMEM.MEM[231]   =   8'b1_00100_11;


        //addi x1, x0, 42
        Processor.IMEM.MEM[344]   =   8'b0000_0010;
        Processor.IMEM.MEM[345]   =   8'b1010_0000;
        Processor.IMEM.MEM[346]   =   8'b0_000_0000;
        Processor.IMEM.MEM[347]   =   8'b1_00100_11;


        //bgeu x6, x7, 52           
        Processor.IMEM.MEM[348]   =   8'b0000_0010;
        Processor.IMEM.MEM[349]   =   8'b0111_0011;
        Processor.IMEM.MEM[350]   =   8'b0111_1010;
        Processor.IMEM.MEM[351]   =   8'b0_11000_11;


        //addi x1, x0, 240
        Processor.IMEM.MEM[352]   =   8'b0000_1111;
        Processor.IMEM.MEM[353]   =   8'b0000_0000;
        Processor.IMEM.MEM[354]   =   8'b0_000_0000;
        Processor.IMEM.MEM[355]   =   8'b1_00100_11;


        //addi x1, x0, -1
        Processor.IMEM.MEM[400]   =   8'b1111_1111;
        Processor.IMEM.MEM[401]   =   8'b1111_0000;
        Processor.IMEM.MEM[402]   =   8'b0_000_0000;
        Processor.IMEM.MEM[403]   =   8'b1_00100_11;
        

        //auipc x9, 0x80000
        Processor.IMEM.MEM[404]   =   8'b1000_0000;
        Processor.IMEM.MEM[405]   =   8'b0000_0000;
        Processor.IMEM.MEM[406]   =   8'b0000_0100;
        Processor.IMEM.MEM[407]   =   8'b1_00101_11;


        //addi x9, x9, 240
        Processor.IMEM.MEM[408]   =   8'b0000_1111;
        Processor.IMEM.MEM[409]   =   8'b0000_0100;
        Processor.IMEM.MEM[410]   =   8'b1_000_0100;
        Processor.IMEM.MEM[411]   =   8'b1_00100_11;


        RST_tb = 0;
        #40;
        RST_tb = 1;
        #40;

        #7000


        $stop;
    end

always #50 CLK_tb = ~CLK_tb;

RV32I Processor (
    .CLK(CLK_tb),
    .RST(RST_tb)
);

endmodule
