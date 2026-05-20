`timescale 1ns/1ps

module blackjack_tb;

    reg MAX10_CLK1_50;
    reg [1:0] KEY;
    reg [9:0] SW;

    wire [9:0] LEDR;
    wire [6:0] HEX3, HEX2, HEX1, HEX0;

    blackjack_top uut (
        .MAX10_CLK1_50(MAX10_CLK1_50),
        .KEY(KEY),
        .SW(SW),
        .LEDR(LEDR),
        .HEX3(HEX3),
        .HEX2(HEX2),
        .HEX1(HEX1),
        .HEX0(HEX0)
    );

    // Clock 50 MHz: período de 20 ns
    always #10 MAX10_CLK1_50 = ~MAX10_CLK1_50;

    initial begin
        MAX10_CLK1_50 = 0;
        KEY = 2'b11;   // botões soltos
        SW  = 10'b0;

        // RESET
        #100 KEY[0] = 0;
        #100 KEY[0] = 1;

        // HIT 1
        #200 KEY[1] = 0;
        #60  KEY[1] = 1;

        // HIT 2
        #400 KEY[1] = 0;
        #60  KEY[1] = 1;

        // HIT 3
        #400 KEY[1] = 0;
        #60  KEY[1] = 1;

        // STAND
        #500 SW[0] = 1;
        #200 SW[0] = 0;

        // espera resultado
        #10000;

        $stop;
    end

endmodule