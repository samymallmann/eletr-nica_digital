# Sistema Bancário Concorrente

Projeto desenvolvido em C para simulação de problemas clássicos de concorrência utilizando threads POSIX (`pthread`), mutexes e semáforos.

O sistema implementa cenários de acesso simultâneo a recursos compartilhados, demonstrando problemas como leitura suja (*dirty read*), condições de corrida (*race conditions*) e inconsistências em buffers compartilhados.

## Funcionalidades

- Simulação do problema Leitores × Escritores
- Simulação do problema Produtores × Consumidores
- Controle de concorrência com semáforos
- Controle de concorrência com mutex
- Demonstração prática de race conditions
- Demonstração de leitura suja
- Buffer circular compartilhado
- Prioridade para escritores
- Múltiplas threads concorrentes
- Interface interativa via terminal

---

# Estrutura do Projeto

### banco_concorrente.c

Arquivo principal do sistema.

Responsável por:
- Exibir menus
- Criar threads
- Inicializar semáforos
- Controlar os módulos de concorrência
- Executar as simulações

---

# Leitores × Escritores

Neste módulo, múltiplas threads acessam simultaneamente uma conta bancária compartilhada.

## Conta Compartilhada

A estrutura da conta contém:

- Número da conta
- Nome do titular
- Saldo
- Quantidade de transações

---

## Versão 1 — Sem prioridade

Implementação com sincronização parcial.

Características:
- Leitores acessam simultaneamente
- Escritores não possuem exclusão total
- Pode ocorrer leitura suja

Demonstra:
- acesso inconsistente ao saldo;
- leitura de dados durante escrita;
- falha de sincronização parcial.

Exemplo:

```txt
Leitor 3 leu saldo: R$ 1000.00  *** LEITURA SUJA! ***
```

---

## Versão 2 — Escritores com prioridade

Implementação completa utilizando:
- semáforos;
- mutexes;
- controle de fila;
- exclusão mútua.

Características:
- escritores possuem prioridade;
- leitores aguardam enquanto escritores acessam a conta;
- não ocorre leitura suja.

Semáforos utilizados:

```c
static sem_t v2_mutex_rc;
static sem_t v2_mutex_wc;
static sem_t v2_db;
static sem_t v2_fila;
```

---

## Versão 3 — Sem controle de concorrência

Implementação propositalmente sem sincronização.

Características:
- múltiplos escritores modificam o saldo simultaneamente;
- não existe exclusão mútua;
- ocorre race condition.

Demonstra:
- atualização perdida;
- sobrescrita de dados;
- inconsistência do saldo final.

Exemplo:

```txt
Saldo esperado: R$ 2000.00
Saldo final:    R$ 1100.00
```

---

# Produtores × Consumidores

Neste módulo, produtores geram transações bancárias e consumidores processam essas transações através de um buffer circular compartilhado.

---

## Buffer Circular

O buffer armazena:
- depósitos;
- saques;
- transferências.

Estrutura:

```c
typedef struct {
    Transacao dados[BUFFER_MAX];
    int in;
    int out;
    int count;
} BufferCircular;
```

---

## Controle do Buffer

O sistema utiliza três semáforos principais:

```c
static sem_t pc_empty;
static sem_t pc_full;
static sem_t pc_mutex;
```

### pc_empty
Controla posições vazias no buffer.

### pc_full
Controla posições ocupadas disponíveis para consumo.

### pc_mutex
Garante exclusão mútua no acesso ao buffer.

---

## Versão 1 — Vários produtores e 1 consumidor

Características:
- múltiplos produtores inserem transações;
- apenas um consumidor processa os dados;
- sincronização completa do buffer.

---

## Versão 2 — Vários produtores e vários consumidores

Características:
- múltiplas threads produzindo simultaneamente;
- múltiplas threads consumindo simultaneamente;
- acesso concorrente totalmente sincronizado.

---

## Versão 3 — Sem controle

Implementação sem sincronização.

Características:
- produtores escrevem simultaneamente;
- consumidores acessam posições inválidas;
- o buffer pode ser corrompido.

Demonstra:
- race conditions;
- corrupção de memória lógica;
- perda de transações.

---

# Funcionamento Geral

O sistema apresenta um menu interativo no terminal:

```txt
1. Leitores × Escritores
2. Produtores × Consumidores
0. Sair
```

Cada módulo possui diferentes versões para demonstrar comportamentos distintos relacionados à concorrência.

---

# Requisitos

- GCC
- Linux ou WSL
- POSIX Threads (`pthread`)
- Biblioteca de semáforos POSIX

---

# Compilação

Abra o terminal na pasta do projeto e execute:

```bash
gcc banco_concorrente.c -o banco -lpthread -lm
```

---

# Execução

Após compilar:

```bash
./banco
```

---

# Observações

- O sistema utiliza delays artificiais (`sleep` e `nanosleep`) para aumentar a concorrência entre as threads.
- Os resultados podem variar a cada execução devido ao escalonamento do sistema operacional.
- Algumas implementações foram propositalmente desenvolvidas sem sincronização para demonstrar problemas clássicos de concorrência.

---

# Autor

Samy Mallmann

---

# Referência

Projeto desenvolvido para a disciplina de Sistemas Operacionais — UFAM.
