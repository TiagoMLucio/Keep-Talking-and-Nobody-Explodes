--------------------------------------------------------------------------
-- Arquivo   : circuito_contador_m_tb.vhd
-- Projeto   :Experiencia 4 - Desenvolvimento de Projeto de 
--                            Circuitos Digitais em FPGA
--------------------------------------------------------------------------
-- Descricao : testbench para contador_m (contador modulo m)
--
--             instancia contador para M=5000 com clock=1KHz
-- 
--------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     31/01/2020  1.0     Edson Midorikawa  criacao
--     31/08/2022  2.0     Edson Midorikawa  revisao do codigo
--     27/01/2023  2.1     Edson Midorikawa  revisao do codigo
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

-- entidade do testbench
entity contador_m_tb is
end entity;

architecture tb of contador_m_tb is

  -- Componente a ser testado (Device Under Test -- DUT)
  component contador_m is
    generic (
        constant M : integer
    );
    port (
        clock   : in  std_logic;
        zera_as : in  std_logic;
        zera_s  : in  std_logic;
        conta   : in  std_logic;
        Q       : out std_logic_vector(natural(ceil(log2(real(M))))-1 downto 0);
        fim     : out std_logic;
        meio    : out std_logic
      );
  end component;
  
  ---- Declaracao de sinais de entrada para conectar o componente
  signal clock_in   : std_logic := '0';
  signal zera_as_in : std_logic := '0';
  signal zera_s_in  : std_logic := '0';
  signal conta_in   : std_logic := '0';

  ---- Declaracao dos sinais de saida
  signal q_out      : std_logic_vector(12 downto 0) := (others => '0'); -- log2(5000)=12,3
  signal fim_out    : std_logic := '0';
  signal meio_out   : std_logic := '0';

  -- Configurações do clock
  signal keep_simulating : std_logic := '0'; -- delimita o tempo de geração do clock
  constant clockPeriod   : time := 1 ms;      -- frequencia 1KHz
  
  -- Casos de teste
  signal caso       : integer := 0;

begin
  -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período especificado. 
  -- Quando keep_simulating=0, clock é interrompido, bem como a simulação de eventos
  clock_in <= (not clock_in) and keep_simulating after clockPeriod/2;
  
  ---- DUT para Caso de Teste 1
  dut: contador_m
       generic map
       (
            M => 5000
       )
       port map
       (
            clock    =>  clock_in,
            zera_as  =>  zera_as_in,
            zera_s   =>  zera_s_in,
            conta    =>  conta_in,
            Q        =>  q_out,
            fim      =>  fim_out,
            meio     =>  meio_out
       );
 
  ---- Gera sinais de estimulo para a simulacao
  stimulus: process is
  begin

    -- inicio da simulacao
    assert false report "inicio da simulacao" severity note;
    keep_simulating <= '1';  -- inicia geracao do sinal de clock

    -- gera pulso de clear assincrono (1 periodo de clock)
    caso       <= 1;
    zera_as_in <= '1';
    wait for clockPeriod;
    zera_as_in <= '0';

    -- espera por 10 periodos de clock sem habilitacao de contagem
    caso <= 2;
    wait for 10*clockPeriod;
    wait until falling_edge(clock_in);

    -- habilita contagem por 20 periodos de clock
    caso <= 3;
    conta_in <= '1';
    wait for 20*clockPeriod;
    conta_in <= '0';
    wait until falling_edge(clock_in);

    -- clear assincrono     
    caso <= 4;
    zera_as_in <= '1';
    wait for clockPeriod;
    zera_as_in <= '0';
    wait until falling_edge(clock_in);

    -- habilita contagem por 100 periodos de clock com intervalo de 10 periodos de clock
    caso <= 5;
    conta_in <= '1';
    wait for 40*clockPeriod;
    conta_in <= '0';
    wait for 10*clockPeriod;
    conta_in <= '1';
    wait for 60*clockPeriod;
    conta_in <= '0';
    wait until falling_edge(clock_in);
    conta_in <= '0';

    -- clear sincrono     
    caso <= 6;
    zera_s_in <= '1';
    wait for 3*clockPeriod;
    zera_s_in <= '0';
    wait until falling_edge(clock_in);

    -- habilita contagem por 5010 periodos de clock
    caso <= 7;
    conta_in <= '1';
    wait for 5010*clockPeriod;
    wait until falling_edge(clock_in);
    conta_in <= '0';

    wait for 20*clockPeriod;  
 
    ---- final do testbench
    assert false report "fim da simulacao" severity note;
    keep_simulating <= '0';
    
    wait; -- fim da simulação: processo aguarda indefinidamente
  end process;


end architecture;
