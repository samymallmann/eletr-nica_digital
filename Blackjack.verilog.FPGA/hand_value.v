module hand_value(
    input clk,
    input reset,
    input enable,
    input [3:0] card,
    output reg [5:0] total,
    output reg bust
);

    reg ace_as_eleven;
    
    // Variáveis auxiliares declaradas FORA do always
    reg [5:0] temp_total;
    reg temp_ace;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            total <= 6'd0;
            bust <= 1'b0;
            ace_as_eleven <= 1'b0;
        end else if (enable) begin
            
            // Inicializa as variáveis temporárias com os valores atuais
            temp_total = total;
            temp_ace = ace_as_eleven;

            // 1. Lógica da carta nova (Soma)
            if (card == 4'd1) begin
                // Se for Ás e não estourar valendo 11
                if (temp_total + 6'd11 <= 6'd21) begin
                    temp_total = temp_total + 6'd11;
                    temp_ace = 1'b1;
                end else begin
                    temp_total = temp_total + 6'd1;
                end
            end else begin
                temp_total = temp_total + {2'b00, card};
            end

            // 2. Lógica de "Salvar" (se estourou mas tem Ás valendo 11)
            if (temp_total > 6'd21 && temp_ace) begin
                temp_total = temp_total - 6'd10;
                temp_ace = 1'b0;
            end

            // 3. Atualiza os registradores reais (Non-blocking)
            total <= temp_total;
            ace_as_eleven <= temp_ace;
            
            // O bust agora é calculado sobre o valor final processado
            if (temp_total > 6'd21)
                bust <= 1'b1;
            else
                bust <= 1'b0;
        end
    end

endmodule