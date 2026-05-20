// ==========================================================
// MÓDULO: card_deck
// FUNÇÃO:
// Simula um baralho de 52 cartas sem repetição.
//
// COMO FUNCIONA:
// - No reset, o baralho é recriado com 52 cartas.
// - Quando draw = 1, uma carta é comprada.
// - A carta comprada é removida do baralho usando troca com a última.
// - Assim, a mesma carta não pode sair novamente.
// ==========================================================

module card_deck(
    input clk,                  // Clock da FPGA
    input reset,                // Reinicia o baralho
    input draw,                 // Sinal para comprar carta
    input [5:0] index,          // Índice pseudoaleatório

    output reg [3:0] card,      // Carta sorteada
    output reg valid,           // 1 quando a carta é válida
    output reg [5:0] cards_left // Quantidade restante
);

    // Baralho com 52 posições
    reg [3:0] deck [0:51];

    // Índice real dentro da quantidade de cartas disponíveis
    wire [5:0] draw_index;

    // Evita divisão por zero
    assign draw_index = (cards_left > 0) ? (index % cards_left) : 6'd0;

    always @(posedge clk) begin

        // ==================================================
        // RESET: recria o baralho completo
        // ==================================================
        if (reset) begin
            cards_left <= 6'd52;
            card <= 4'd0;
            valid <= 1'b0;

            // Naipe 1
            deck[0]  <= 4'd1;   // Ás
            deck[1]  <= 4'd2;
            deck[2]  <= 4'd3;
            deck[3]  <= 4'd4;
            deck[4]  <= 4'd5;
            deck[5]  <= 4'd6;
            deck[6]  <= 4'd7;
            deck[7]  <= 4'd8;
            deck[8]  <= 4'd9;
            deck[9]  <= 4'd10;
            deck[10] <= 4'd10;  // J
            deck[11] <= 4'd10;  // Q
            deck[12] <= 4'd10;  // K

            // Naipe 2
            deck[13] <= 4'd1;
            deck[14] <= 4'd2;
            deck[15] <= 4'd3;
            deck[16] <= 4'd4;
            deck[17] <= 4'd5;
            deck[18] <= 4'd6;
            deck[19] <= 4'd7;
            deck[20] <= 4'd8;
            deck[21] <= 4'd9;
            deck[22] <= 4'd10;
            deck[23] <= 4'd10;
            deck[24] <= 4'd10;
            deck[25] <= 4'd10;

            // Naipe 3
            deck[26] <= 4'd1;
            deck[27] <= 4'd2;
            deck[28] <= 4'd3;
            deck[29] <= 4'd4;
            deck[30] <= 4'd5;
            deck[31] <= 4'd6;
            deck[32] <= 4'd7;
            deck[33] <= 4'd8;
            deck[34] <= 4'd9;
            deck[35] <= 4'd10;
            deck[36] <= 4'd10;
            deck[37] <= 4'd10;
            deck[38] <= 4'd10;

            // Naipe 4
            deck[39] <= 4'd1;
            deck[40] <= 4'd2;
            deck[41] <= 4'd3;
            deck[42] <= 4'd4;
            deck[43] <= 4'd5;
            deck[44] <= 4'd6;
            deck[45] <= 4'd7;
            deck[46] <= 4'd8;
            deck[47] <= 4'd9;
            deck[48] <= 4'd10;
            deck[49] <= 4'd10;
            deck[50] <= 4'd10;
            deck[51] <= 4'd10;
        end

        // ==================================================
        // OPERAÇÃO NORMAL
        // ==================================================
        else begin

            // Por padrão, nenhuma carta nova saiu
            valid <= 1'b0;

            // Compra carta apenas se solicitado
            // e ainda houver cartas disponíveis
            if (draw && cards_left > 0) begin

                // Entrega a carta sorteada
                card <= deck[draw_index];

                // Remove a carta:
                // substitui pela última disponível
                deck[draw_index] <= deck[cards_left - 1];

                // Reduz quantidade restante
                cards_left <= cards_left - 1'b1;

                // Marca saída como válida
                valid <= 1'b1;
            end
        end
    end

endmodule