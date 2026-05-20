# Blackjack FPGA — DE10-Lite

Projeto desenvolvido em Verilog para implementação do jogo Blackjack (21) utilizando a FPGA DE10-Lite.

O sistema implementa um jogo entre jogador e banca, utilizando máquina de estados finitos (FSM), displays de 7 segmentos e LEDs da placa.

## Funcionalidades

- Baralho com 52 cartas
- Sistema de compra de cartas (HIT)
- Sistema de parada (STAND/STAY)
- Controle automático da banca
- Cálculo automático das mãos
- Tratamento do Ás como 1 ou 11
- Verificação de vitória, derrota e empate
- Exibição em displays HEX da DE10-Lite

## Estrutura do Projeto

### blackjack_top.v
Módulo principal do sistema.

Responsável por:
- Integrar todos os módulos
- Controlar displays
- Controlar LEDs
- Fazer conexão entre FSM, baralho e cálculo das mãos

### blackjack_fsm.v
Máquina de estados finitos do jogo.

Controla:
- Distribuição inicial das cartas
- Turno do jogador
- Turno da banca
- Verificação de resultado
- Finalização da partida

### card_deck.v
Implementação do baralho.

Responsável por:
- Armazenar as 52 cartas
- Entregar cartas sem repetição
- Controle de cartas restantes

### random_index.v
Geração de índice pseudoaleatório utilizado na seleção das cartas.

### hand_value.v
Cálculo do valor das mãos.

Responsável por:
- Somar cartas
- Detectar bust (>21)
- Tratar Ás como 1 ou 11

### seven_seg_decoder.v
Decodificador para displays de 7 segmentos.

Converte valores numéricos em sinais para os displays HEX da DE10-Lite.

## Displays e LEDs

### Displays HEX

| Display | Função |
|----------|---------|
| HEX3 HEX2 | Valor da mão do jogador |
| HEX1 HEX0 | Valor da mão da banca (apenas no final) |

### LEDs

| LED | Função |
|-----|---------|
| WIN | Vitória |
| LOSE | Derrota |
| TIE | Empate |

## Controles

| Entrada | Função |
|----------|---------|
| KEY0 | Reset |
| KEY1 | Hit |
| SW0 | Stand / Stay |

## Funcionamento

1. O jogo inicia após reset.
2. A banca distribui duas cartas para o jogador e duas para si mesma.
3. O jogador pode:
   - Pedir cartas (HIT)
   - Parar (STAND)
4. Após o jogador parar, a banca joga automaticamente.
5. A banca compra cartas até atingir 17 ou mais.
6. O resultado final é exibido nos LEDs e displays.

## Requisitos

- Quartus Prime Lite 18.0
- FPGA DE10-Lite
- Verilog HDL

## Compilação

1. Abrir o projeto no Quartus
2. Adicionar todos os arquivos `.v`
3. Definir `blackjack_top` como Top-Level Entity
4. Configurar os pinos no Pin Planner
5. Compilar o projeto
6. Gravar na FPGA

## Observações

- Os displays HEX da DE10-Lite utilizam lógica active-low.
- Os botões KEY também são active-low.
- O projeto utiliza lógica síncrona baseada na borda de subida do clock.

## Autor

Samy Mallmann

## Referência

Projeto desenvolvido para a disciplina de Eletrônica Digital II — UFAM.
