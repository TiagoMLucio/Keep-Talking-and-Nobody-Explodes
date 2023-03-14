library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-- entidade do testbench
entity ktne_tb is
end entity;

architecture tb of ktne_tb is

    -- Componente a ser testado (Device Under Test -- DUT)
    component ktne
        port (
            clock            : in std_logic;
            reset            : in std_logic;
            start            : in std_logic;
            db_err           : in std_logic;
            minutes_hex      : out std_logic_vector(6 downto 0);
            seconds_ten_hex  : out std_logic_vector(6 downto 0);
            seconds_unit_hex : out std_logic_vector(6 downto 0);
            errors_hex       : out std_logic_vector(6 downto 0);
            serial1_hex      : out std_logic_vector(6 downto 0);
            serial2_hex      : out std_logic_vector(6 downto 0);
            exploded         : out std_logic;
            db_clock         : out std_logic;
            db_estado        : out std_logic_vector(3 downto 0)
        );
    end component;

    ---- Declaracao de sinais de entrada para conectar o componente
    signal clk_in   : std_logic := '0';
    signal rst_in   : std_logic := '0';
    signal start_in : std_logic := '0';
    signal err_in   : std_logic := '0';

    ---- Declaracao dos sinais de saida
    signal exploded_out : std_logic                    := '0';
    signal clock_out    : std_logic                    := '0';
    signal estado_out   : std_logic_vector(3 downto 0) := "0000";

    -- Configurações do clock
    signal keep_simulating : std_logic := '0';  -- delimita o tempo de geração do clock
    constant clockPeriod   : time      := 1 ns; -- frequencia 1kHz

begin
    -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período especificado. 
    -- Quando keep_simulating=0, clock é interrompido, bem como a simulação de eventos
    clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;

    ---- DUT para Simulacao
    dut : ktne
    port map
    (
        clock            => clk_in,
        reset            => rst_in,
        start            => start_in,
        db_err           => err_in,
        minutes_hex      => open,
        seconds_ten_hex  => open,
        seconds_unit_hex => open,
        errors_hex       => open,
        serial1_hex      => open,
        serial2_hex      => open,
        exploded         => exploded_out,
        db_clock         => clock_out,
        db_estado        => estado_out
    );

    ---- Gera sinais de estimulo para a simulacao
    -- Cenario de Teste
    process begin
        report "BOT" severity note;

        -- inicio da simulacao
        assert false report "inicio da simulacao" severity note;
        keep_simulating <= '1'; -- inicia geracao do sinal de clock

        -- gera pulso de reset (1 periodo de clock)
        rst_in <= '1';
        wait for clockPeriod;
        rst_in <= '0';

        -- get random serial numbers
        wait for 20 * clockPeriod;

        -- pulso do sinal de Iniciar (muda na borda de descida do clock)
        wait until falling_edge(clk_in);
        start_in <= '1';
        wait until falling_edge(clk_in);
        start_in <= '0';

        -- espera para inicio dos testes
        wait for 60 * 1000 * clockPeriod;

        wait until falling_edge(clk_in);
        err_in <= '1';
        wait until falling_edge(clk_in);
        err_in <= '0';

        wait for 60 * 1000 * clockPeriod;

        wait until falling_edge(clk_in);
        err_in <= '1';
        wait until falling_edge(clk_in);
        err_in <= '0';

        wait for 60 * 1000 * clockPeriod;

        wait until falling_edge(clk_in);
        err_in <= '1';
        wait until falling_edge(clk_in);
        err_in <= '0';

        wait for 2 * 60 * 1000 * clockPeriod;

        wait until falling_edge(clk_in);

        wait for 10 * clockPeriod;

        ---- final do testbench
        report "EOF" severity note;
        keep_simulating <= '0';

        wait;
    end process;
end architecture;
