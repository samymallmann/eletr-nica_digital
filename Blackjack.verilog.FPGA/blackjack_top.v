module blackjack_top(
    input  wire         MAX10_CLK1_50,   // Clock da DE10-Lite 50 MHz
    input  wire [1:0]   KEY,              // KEY[0] e KEY[1] ativos em 0
    input  wire [9:0]   SW,               // Switches

    output wire [9:0]   LEDR,             // LEDs
    output wire [6:0]   HEX3,             // Dezena jogador
    output wire [6:0]   HEX2,             // Unidade jogador
    output wire [6:0]   HEX1,             // Dezena dealer
    output wire [6:0]   HEX0              // Unidade dealer
);

    // =====================================================
    // 1. Clock e botões da DE10-Lite
    // =====================================================
    wire clk = MAX10_CLK1_50;
    wire reset_btn = ~KEY[0]; // KEY0 = RESET
    wire hit_btn   = ~KEY[1]; // KEY1 = HIT
    wire stand     = SW[0];   // SW0  = STAND

    // =====================================================
    // 2. Pulso do HIT (Debounce simples)
    // =====================================================
    reg hit_d;
    always @(posedge clk or posedge reset_btn) begin
        if (reset_btn) hit_d <= 1'b0;
        else hit_d <= hit_btn;
    end
    wire hit_pulse = hit_btn & ~hit_d;

    // =====================================================
    // 3. Sinais internos
    // =====================================================
    wire [5:0] card_index;
    wire [3:0] card_value;
    wire card_valid;
    wire bust_player;
    wire bust_dealer;
    wire player_turn;
    wire dealer_turn;
    wire game_over;
    wire player_won;
    wire dealer_won;

    // =====================================================
    // 4. Randomizador
    // =====================================================
    random_index randomizer(
        .clk(clk),
        .reset(reset_btn),
        .index(card_index)
    );

    // =====================================================
    // 5. Timer do Dealer (0,5 segundos entre cartas)
    // =====================================================
    reg [24:0] dealer_counter;
    reg dealer_tick;

    always @(posedge clk or posedge reset_btn) begin
        if (reset_btn) begin
            dealer_counter <= 25'd0;
            dealer_tick    <= 1'b0;
        end else if (dealer_turn && !game_over) begin
            if (dealer_counter == 25'd20) begin
                dealer_counter <= 25'd0;
                dealer_tick    <= 1'b1;
            end else begin
                dealer_counter <= dealer_counter + 25'd1;
                dealer_tick    <= 1'b0;
            end
        end else begin
            dealer_counter <= 25'd0;
            dealer_tick    <= 1'b0;
        end
    end

    wire draw_card = (player_turn & hit_pulse) | (dealer_turn & dealer_tick);

    // =====================================================
    // 6. Baralho
    // =====================================================
    card_deck deck(
        .clk(clk),
        .reset(reset_btn),
        .draw(draw_card),
        .index(card_index),
        .card(card_value),
        .valid(card_valid),
        .cards_left()
    );

    // =====================================================
    // 7. Sincronismo do card_valid
    // =====================================================
    reg valid_d;
    always @(posedge clk or posedge reset_btn) begin
        if (reset_btn) valid_d <= 1'b0;
        else valid_d <= card_valid;
    end
    wire valid_pulse = card_valid & ~valid_d;

    // =====================================================
    // 8. Mão do jogador e Mão do dealer
    // =====================================================
    wire [5:0] player_total;
    hand_value player_hand(
        .clk(clk), .reset(reset_btn),
        .enable(valid_pulse & player_turn),
        .card(card_value), .total(player_total), .bust(bust_player)
    );

    wire [5:0] dealer_total;
    hand_value dealer_hand(
        .clk(clk), .reset(reset_btn),
        .enable(valid_pulse & dealer_turn),
        .card(card_value), .total(dealer_total), .bust(bust_dealer)
    );

    // =====================================================
    // 10. FSM do jogo (Controle de estados)
    // =====================================================
    blackjack_fsm fsm(
        .clk(clk), .reset(reset_btn),
        .hit(hit_pulse), .stand(stand),
        .bust_player(bust_player), .bust_dealer(bust_dealer),
        .player_total(player_total), .dealer_total(dealer_total),
        .player_turn(player_turn), .dealer_turn(dealer_turn),
        .game_over(game_over), .player_won(player_won), .dealer_won(dealer_won)
    );

    // =====================================================
    // 11. LEDs de Status
    // =====================================================
    assign LEDR[0] = player_won;                       // VITÓRIA
    assign LEDR[1] = dealer_won;                       // DERROTA
    assign LEDR[2] = game_over & ~player_won & ~dealer_won; // EMPATE
    assign LEDR[9:3] = 7'b0000000;

    // =====================================================
    // 12. Cálculos de Decimal (Básico)
    // =====================================================
    wire [3:0] p_tens = (player_total >= 6'd20) ? 4'd2 : (player_total >= 6'd10) ? 4'd1 : 4'd0;
    wire [3:0] p_units = player_total - ({2'b00, p_tens} * 6'd10);

    wire [3:0] d_tens = (dealer_total >= 6'd20) ? 4'd2 : (dealer_total >= 6'd10) ? 4'd1 : 4'd0;
    wire [3:0] d_units = dealer_total - ({2'b00, d_tens} * 6'd10);

    // =====================================================
    // 13. Lógica dos Displays do JOGADOR (HEX3-HEX2)
    // =====================================================
    wire [3:0] hex3_val = (bust_player) ? 4'd14 : p_tens;  // 14 = "E"
    wire [3:0] hex2_val = (bust_player) ? 4'd14 : p_units;

    seven_seg_decoder dec_p_tens(.value(hex3_val), .segments(HEX3));
    seven_seg_decoder dec_p_units(.value(hex2_val), .segments(HEX2));

    // =====================================================
    // 14. Lógica dos Displays do DEALER (HEX1-HEX0)
    // =====================================================
    // Prioridade: 1º Escondido se não acabou, 2º Erro se estourou, 3º Valor real
    wire [3:0] hex1_val = (!game_over)  ? 4'd15 : (bust_dealer) ? 4'd14 : d_tens;
    wire [3:0] hex0_val = (!game_over)  ? 4'd15 : (bust_dealer) ? 4'd14 : d_units;

    seven_seg_decoder dec_d_tens(.value(hex1_val), .segments(HEX1));
    seven_seg_decoder dec_d_units(.value(hex0_val), .segments(HEX0));

endmodule