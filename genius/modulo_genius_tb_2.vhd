library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-- entidade do testbench
entity modulo_genius_tb_2 is
end entity;

architecture tb of modulo_genius_tb_2 is

  -- Componente a ser testado (Device Under Test -- DUT)
  component modulo_genius
  port (
    clock       : in std_logic;
    reset       : in std_logic;
    iniciar     : in std_logic;
    botoes      : in std_logic_vector (3 downto 0);
    tem_vogal   : in std_logic;
    erros       : in std_logic_vector(1 downto 0);

    pronto      : out std_logic;
    errou       : out std_logic;
    leds        : out std_logic_vector (3 downto 0);
    db_clock    : out std_logic;
    db_igual    : out std_logic;
    db_contagem : out std_logic_vector (6 downto 0);
    db_memoria  : out std_logic_vector (6 downto 0);
    db_jogada   : out std_logic_vector (6 downto 0);
    db_rodada   : out std_logic_vector (6 downto 0);
    db_estado   : out std_logic_vector (6 downto 0)
);
  end component;

  ---- Declaracao de sinais de entrada para conectar o componente
  signal clk_in       : std_logic                     := '0';
  signal rst_in       : std_logic                     := '0';
  signal iniciar_in   : std_logic                     := '0';
  signal botoes_in    : std_logic_vector(3 downto 0)  := "0000";
  signal tem_vogal_in : std_logic                     := '0';
  signal erros_in     : std_logic_vector(1 downto 0)  := "00";

  ---- Declaracao dos sinais de saida
  signal pronto_out   : std_logic                    := '0';
  signal errou_out    : std_logic                    := '0';
  signal leds_out     : std_logic_vector(3 downto 0) := "0000";
  signal clock_out    : std_logic                    := '0';
  signal igual_out    : std_logic                    := '0';
  signal contagem_out : std_logic_vector(6 downto 0) := "0000000";
  signal memoria_out  : std_logic_vector(6 downto 0) := "0000000";
  signal jogada_out   : std_logic_vector(6 downto 0) := "0000000";
  signal rodada_out   : std_logic_vector(6 downto 0) := "0000000";
  signal estado_out   : std_logic_vector(6 downto 0) := "0000000";

  -- Configurações do clock
  signal keep_simulating : std_logic := '0';   -- delimita o tempo de geração do clock
  constant clockPeriod   : time      := 20 ns; -- frequencia 50MHz

begin
  -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período especificado. 
  -- Quando keep_simulating=0, clock é interrompido, bem como a simulação de eventos
  clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;

  ---- DUT para Simulacao
  dut : modulo_genius
  port map
  (
    clock       => clk_in,
    reset       => rst_in,
    iniciar     => iniciar_in,
    botoes      => botoes_in,
    tem_vogal   => tem_vogal_in,
    erros       => erros_in,
    pronto      => pronto_out,
    errou       => errou_out,
    leds        => leds_out,
    db_clock    => clock_out,
    db_igual    => igual_out,
    db_contagem => contagem_out,
    db_memoria  => memoria_out,
    db_jogada   => jogada_out,
    db_rodada   => rodada_out,
    db_estado   => estado_out
  );

  ---- Gera sinais de estimulo para a simulacao
  -- Cenario de Teste : jogo como vencedor
  process
    type pattern_array is array (integer range <>) of std_logic_vector(3 downto 0);
    constant jogadas : pattern_array (0 to 3) := (
    "0010",
    "1000",
    "0010",
    "0001");

  begin
    report "BOT" severity note;

    -- inicio da simulacao
    assert false report "inicio da simulacao" severity note;
    keep_simulating <= '1'; -- inicia geracao do sinal de clock

    -- gera pulso de reset (1 periodo de clock)
    rst_in <= '1';
    wait for clockPeriod;
    rst_in <= '0';
    -- pulso do sinal de Iniciar (muda na borda de descida do clock)
    wait until falling_edge(clk_in);
    iniciar_in <= '1';
    wait until falling_edge(clk_in);
    iniciar_in <= '0';

    -- espera para inicio dos testes
    wait for 1000 * clockPeriod;
    wait until falling_edge(clk_in);

    -- Cenario de Teste - acerta todas as jogadas de todas as rodadas por dois jogos consecutivos
    
    -- Primeiro Jogo
    loop_rodadas1 : for r in 0 to 2 loop

      loop_jogadas1 : for j in 0 to r loop
	      report HT & "indices (j/r): " & integer'image(j) & "/" & integer'image(r) & LF;
        report "memoria: " & integer'image(to_integer(unsigned(jogadas(j)))) & LF;
        botoes_in <= jogadas(j);
        wait for 10 * clockPeriod;
        botoes_in <= "0000";
 	      wait for 10 * clockPeriod;
      end loop loop_jogadas1;

      wait for 3000 * clockPeriod;

    end loop loop_rodadas1;


    loop_jogadas2 : for j in 0 to 2 loop
      report HT & "indices (j/r): " & integer'image(j) & "/" & integer'image(2) & LF;
      report "memoria: " & integer'image(to_integer(unsigned(jogadas(j)))) & LF;
      botoes_in <= jogadas(j);
      wait for 10 * clockPeriod;
      botoes_in <= "0000";
       wait for 10 * clockPeriod;
    end loop loop_jogadas2;

    wait for 3000 * clockPeriod;

    wait for 10 * clockPeriod;

    ---- final do testbench
    report "EOF" severity note;
    keep_simulating <= '0';

    wait; -- fim da simulação: processo aguarda indefinidamente
  end process;
end architecture;
