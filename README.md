# 🃏 Blackjack FPGA — DE10-Lite

[![Verilog](https://img.shields.io/badge/HDL-Verilog-8A2BE2?style=for-the-badge)](https://www.intel.com/content/www/us/en/products/details/fpga.html)
[![FPGA](https://img.shields.io/badge/Board-DE10--Lite-00979D?style=for-the-badge)](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=1021)
[![Quartus](https://img.shields.io/badge/Quartus-18.0-blue?style=for-the-badge)](https://www.intel.com/content/www/us/en/software-kit/795187/intel-quartus-prime-lite-edition-design-software-version-18-0-for-linux.html)
[![UFAM](https://img.shields.io/badge/UFAM-DTEC-red?style=for-the-badge)](https://ufam.edu.br/)

Projeto desenvolvido em Verilog para implementação do jogo Blackjack (21) utilizando a FPGA DE10-Lite.

O sistema implementa um jogo entre jogador e banca utilizando máquina de estados finitos (FSM), displays de 7 segmentos, LEDs e botões da placa FPGA.

---

# 📋 Funcionalidades

- Baralho com 52 cartas
- Sistema de compra de cartas (HIT)
- Sistema de parada (STAND/STAY)
- Controle automático da banca
- Cálculo automático das mãos
- Tratamento do Ás como 1 ou 11
- Verificação de vitória, derrota e empate
- Exibição em displays HEX da DE10-Lite
- Controle por FSM
- Geração pseudoaleatória de cartas
- Integração completa entre módulos

---

# 🏗️ Estrutura do Projeto

### blackjack_top.v

Módulo principal do sistema.

Responsável por:
- Integrar todos os módulos
- Controlar displays
- Controlar LEDs
- Gerenciar entradas da placa
- Fazer conexão entre FSM, baralho e cálculo das mãos

---

### blackjack_fsm.v

Máquina de estados finitos do jogo.

Responsável por:
- Distribuição inicial das cartas
- Controle do turno do jogador
- Controle do turno da banca
- Verificação do resultado
- Finalização da partida

Estados principais:
- INIT
- PLAYER_TURN
- DEALER_TURN
- CHECK_RESULT

---

### card_deck.v

Implementação do baralho do jogo.

Responsável por:
- Armazenar as 52 cartas
- Distribuir cartas sem repetição
- Controlar cartas restantes
- Atualizar posições do baralho após cada compra

---

### random_index.v

Gerador pseudoaleatório utilizado para selecionar cartas do baralho.

Responsável por:
- Gerar índices aleatórios
- Auxiliar na seleção das cartas
- Variar as partidas do jogo

---

### hand_value.v

Módulo de cálculo das mãos.

Responsável por:
- Somar cartas
- Detectar bust (>21)
- Tratar Ás como 1 ou 11
- Atualizar valores do jogador e da banca

---

### seven_seg_decoder.v

Decodificador para displays de 7 segmentos.

Responsável por:
- Converter valores numéricos
- Gerar sinais para os displays HEX
- Exibir pontuações na FPGA

---

# 🎮 Displays e LEDs

## Displays HEX

| Display | Função |
|----------|---------|
| HEX3 HEX2 | Valor da mão do jogador |
| HEX1 HEX0 | Valor da mão da banca |

---

## LEDs

| LED | Função |
|-----|---------|
| WIN | Vitória |
| LOSE | Derrota |
| TIE | Empate |

---

# 🎛️ Controles

| Entrada | Função |
|----------|---------|
| KEY0 | Reset |
| KEY1 | Hit |
| SW0 | Stand / Stay |

---

# ⚙️ Funcionamento

1. O jogo inicia após reset.
2. O sistema distribui duas cartas para o jogador e duas para a banca.
3. O jogador pode:
   - Comprar cartas (HIT)
   - Parar (STAND)
4. Após o jogador parar, a banca joga automaticamente.
5. A banca compra cartas até atingir 17 pontos ou mais.
6. O resultado final é exibido nos LEDs e displays.

---

# 🖥️ Hardware Utilizado

- FPGA DE10-Lite
- Intel MAX 10 FPGA
- Displays de 7 segmentos
- LEDs integrados
- Chaves e botões da placa

---

# 🛠️ Requisitos

- Quartus Prime Lite 18.0
- FPGA DE10-Lite
- Verilog HDL

---

# 🚀 Compilação

1. Abrir o projeto no Quartus Prime
2. Adicionar todos os arquivos `.v`
3. Definir `blackjack_top` como Top-Level Entity
4. Configurar os pinos no Pin Planner
5. Compilar o projeto
6. Gravar na FPGA

---

# 📌 Observações

- Os displays HEX da DE10-Lite utilizam lógica active-low.
- Os botões KEY também utilizam lógica active-low.
- O sistema utiliza clock de 50 MHz da FPGA.
- O projeto utiliza arquitetura modular para facilitar manutenção e testes.
- A lógica do jogo é totalmente síncrona.

---

# 👨‍💻 Autor

Samy Mallmann

---

# 📚 Referência

Projeto desenvolvido para a disciplina de Eletrônica Digital II — UFAM.
