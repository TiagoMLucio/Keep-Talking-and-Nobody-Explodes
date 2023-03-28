library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-- entidade do testbench
entity modulo_memoria_tb is
end entity;

architecture tb of modulo_memoria_tb is

  -- Componente a ser testado (Device Under Test -- DUT)
  component modulo_memoria
  port (
    clock     : in std_logic;
    reset     : in std_logic;
    iniciar   : in std_logic;
    botoes    : in std_logic_vector (3 downto 0);
    pronto    : out std_logic;
    err       : out std_logic;
    estagio   : out std_logic_vector (2 downto 0);
    display   : out std_logic_vector (6 downto 0);
    num1      : out std_logic_vector (6 downto 0);
    num2      : out std_logic_vector (6 downto 0);
    num3      : out std_logic_vector (6 downto 0);
    num4      : out std_logic_vector (6 downto 0);
    db_estado : out std_logic_vector (6 downto 0)
);
  end component;

  ---- Declaracao de sinais de entrada para conectar o componente
  signal clk_in       : std_logic                     := '0';
  signal rst_in       : std_logic                     := '0';
  signal iniciar_in   : std_logic                     := '0';
  signal botoes_in    : std_logic_vector(3 downto 0)  := "0000";

  ---- Declaracao dos sinais de saida
  signal pronto_out   : std_logic                    := '0';
  signal errou_out    : std_logic                    := '0';
  signal estagio_out  : std_logic_vector(2 downto 0) := "000";
  signal display_out  : std_logic_vector(6 downto 0) := "0000000";
  signal num1_out     : std_logic_vector(6 downto 0) := "0000000";
  signal num2_out     : std_logic_vector(6 downto 0) := "0000000";
  signal num3_out     : std_logic_vector(6 downto 0) := "0000000";
  signal num4_out     : std_logic_vector(6 downto 0) := "0000000";
  signal estado_out   : std_logic_vector(6 downto 0) := "0000000";

  -- Configurações do clock
  signal keep_simulating : std_logic := '0';   -- delimita o tempo de geração do clock
  constant clockPeriod   : time      := 20 ns; -- frequencia 50MHz

begin
  -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período especificado. 
  -- Quando keep_simulating=0, clock é interrompido, bem como a simulação de eventos
  clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;

  ---- DUT para Simulacao
  dut : modulo_memoria
  port map
  (
    clock       => clk_in,
    reset       => rst_in,
    iniciar     => iniciar_in,
    botoes      => botoes_in,
    pronto      => pronto_out,
    err         => errou_out,
    estagio     => estagio_out,
    display     => display_out,
    num1        => num1_out,
    num2        => num2_out,
    num3        => num3_out,
    num4        => num4_out,
    db_estado   => estado_out
  );

  ---- Gera sinais de estimulo para a simulacao
  -- Cenario de Teste : jogo como vencedor
  process
    type pattern_array is array (integer range <>) of std_logic_vector(3 downto 0);
    constant jogadas : pattern_array (0 to 4) := (
      "0010", 
      "0010", 
      "0100", 
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
    wait for 5 * clockPeriod;
    wait until falling_edge(clk_in);

    -- Cenario de Teste - acerta todas as jogadas 

    loop_estagios : for e in 0 to 4 loop

      report HT & "estagio: " & integer'image(e) & LF;
      botoes_in <= jogadas(e);
      wait for 5 * clockPeriod;
      botoes_in <= "0000";
      wait for 5 * clockPeriod;

    end loop loop_estagios;

    wait for 5 * clockPeriod;

    ---- final do testbench
    report "EOF" severity note;
    keep_simulating <= '0';

    wait; -- fim da simulação: processo aguarda indefinidamente
  end process;
end architecture;
