// ==========================================================
// MÓDULO: random_index
// FUNÇÃO:
// Gera um índice pseudoaleatório de 6 bits.
//
// Esse índice será usado pelo card_deck para escolher
// uma posição do baralho.
// ==========================================================

module random_index(
    input clk,
    input reset,

    output reg [5:0] index
);

    always @(posedge clk) begin
        if (reset) begin
            // Valor inicial diferente de zero
            index <= 6'b000001;
        end
        else begin
            // LFSR simples de 6 bits
            // Gera uma sequência pseudoaleatória
            index <= {index[4:0], index[5] ^ index[4]};
        end
    end

endmodule