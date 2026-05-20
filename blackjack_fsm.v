module blackjack_fsm(
    input clk,
    input reset,
    input hit,
    input stand,
    input bust_player,
    input bust_dealer,
    input [5:0] player_total, // Nova entrada para comparar no final
    input [5:0] dealer_total, // Nova entrada para a regra dos 17

    output reg player_turn,
    output reg dealer_turn,
    output reg game_over,
    output reg player_won,
    output reg dealer_won
);

    // Estados
    parameter INIT         = 3'd0;
    parameter PLAYER_TURN  = 3'd1;
    parameter DEALER_TURN  = 3'd2;
    parameter CHECK_RESULT = 3'd3;

    reg [2:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= INIT;
            player_turn <= 0;
            dealer_turn <= 0;
            game_over <= 0;
            player_won <= 0;
            dealer_won <= 0;
        end else begin
            case (state)

                INIT: begin
                    player_turn <= 1;
                    dealer_turn <= 0;
                    game_over <= 0;
                    player_won <= 0;
                    dealer_won <= 0;
                    state <= PLAYER_TURN;
                end

                PLAYER_TURN: begin
                    player_turn <= 1;
                    dealer_turn <= 0;

                    if (bust_player) begin
                        player_won <= 0;
                        dealer_won <= 1;
                        state <= CHECK_RESULT;
                    end else if (stand) begin
                        state <= DEALER_TURN;
                    end
                end

                DEALER_TURN: begin
                    player_turn <= 0;
                    dealer_turn <= 1;

                    if (bust_dealer) begin
                        state <= CHECK_RESULT;
                    end 
                    // REGRA: Dealer para apenas quando atinge 17 ou mais
                    else if (dealer_total >= 6'd17) begin
                        state <= CHECK_RESULT;
                    end 
                    else begin
                        // Se for menor que 17, continua aqui esperando o dealer_tick
                        state <= DEALER_TURN;
                    end
                end

                CHECK_RESULT: begin
                    player_turn <= 0;
                    dealer_turn <= 0;
                    game_over <= 1;

                    // Lógica de decisão de vitória
                    if (bust_player) begin
                        player_won <= 0;
                        dealer_won <= 1;
                    end else if (bust_dealer) begin
                        player_won <= 1;
                        dealer_won <= 0;
                    end else if (player_total > dealer_total) begin
                        player_won <= 1;
                        dealer_won <= 0;
                    end else if (dealer_total > player_total) begin
                        player_won <= 0;
                        dealer_won <= 1;
                    end else begin
                        // Empate real (ex: 19 vs 19)
                        player_won <= 0;
                        dealer_won <= 0;
                    end
                end

                default: state <= INIT;
            endcase
        end
    end

endmodule