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
            clock     : in std_logic;
            reset     : in std_logic;
            start     : in std_logic;
            sel_hex   : in std_logic;
            defused   : out std_logic;
            exploded  : out std_logic;
            db_clock  : out std_logic;
            db_estado : out std_logic_vector(3 downto 0);

            -- Genius
            botoes_gen : in std_logic_vector(3 downto 0);
            leds_gen   : out std_logic_vector(3 downto 0);
            pronto_gen : out std_logic;

            -- Memória
            botoes_mem  : in std_logic_vector(3 downto 0);
            estagio_mem : out std_logic_vector(4 downto 0);
            pronto_mem  : out std_logic;

            -- HEX
            hex0 : out std_logic_vector(6 downto 0);
            hex1 : out std_logic_vector(6 downto 0);
            hex2 : out std_logic_vector(6 downto 0);
            hex3 : out std_logic_vector(6 downto 0);
            hex4 : out std_logic_vector(6 downto 0);
            hex5 : out std_logic_vector(6 downto 0)
        );
    end component;

    ---- Declaracao de sinais de entrada para conectar o componente
    signal clk_in     : std_logic := '0';
    signal rst_in     : std_logic := '0';
    signal start_in   : std_logic := '0';
    signal sel_hex_in : std_logic := '0';

    ---- Declaracao dos sinais de saida
    signal defused_out  : std_logic                    := '0';
    signal exploded_out : std_logic                    := '0';
    signal clock_out    : std_logic                    := '0';
    signal estado_out   : std_logic_vector(3 downto 0) := "0000";

    -- Genius
    signal botoes_gen_in  : std_logic_vector(3 downto 0) := "0000";
    signal leds_gen_out   : std_logic_vector(3 downto 0) := "0000";
    signal pronto_gen_out : std_logic                    := '0';

    -- Memoria
    signal botoes_mem_in   : std_logic_vector(3 downto 0) := "0000";
    signal estagio_mem_out : std_logic_vector(4 downto 0) := "00000";
    signal pronto_mem_out  : std_logic                    := '0';

    -- Hex
    signal hex0_out, hex1_out, hex2_out, hex3_out, hex4_out, hex5_out : std_logic_vector(6 downto 0) := "0000000";

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
        clock     => clk_in,
        reset     => rst_in,
        start     => start_in,
        sel_hex   => sel_hex_in,
        defused   => defused_out,
        exploded  => exploded_out,
        db_clock  => clock_out,
        db_estado => estado_out,

        botoes_gen => botoes_gen_in,
        leds_gen   => leds_gen_out,
        pronto_gen => pronto_gen_out,

        botoes_mem  => botoes_mem_in,
        estagio_mem => estagio_mem_out,
        pronto_mem  => pronto_mem_out,

        hex0 => hex0_out,
        hex1 => hex1_out,
        hex2 => hex2_out,
        hex3 => hex3_out,
        hex4 => hex4_out,
        hex5 => hex5_out
    );

    ---- Gera sinais de estimulo para a simulacao
    -- Cenario de Teste
    process 
        type pattern_array is array (integer range <>) of std_logic_vector(3 downto 0);
        constant jogadas_gen : pattern_array (0 to 3) := (
        "0100", 
        "0010", 
        "1000", 
        "1000");

        constant jogadas_mem : pattern_array (0 to 4) := (
          "0010", 
          "0001", 
          "1000", 
          "0001",
          "1000");
    begin
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


        -- Ganha Genius
        loop_rodadas1 : for r in 0 to 3 loop
            loop_jogadas1 : for j in 0 to r loop
                botoes_gen_in <= jogadas_gen(j);
                wait for 10 * clockPeriod;
                botoes_gen_in <= "0000";
                wait for 2 * 1000 * clockPeriod;
            end loop loop_jogadas1;
            
            wait for 10 * 1000 * clockPeriod;
        
        end loop loop_rodadas1;
    
        wait for 30 * 1000 * clockPeriod;

        sel_hex_in <= '1';

        -- Ganha Memoria
        loop_estagios : for e in 0 to 4 loop
            report HT & "estagio: " & integer'image(e) & LF;
            botoes_mem_in <= jogadas_mem(e);
            wait for 10 * clockPeriod;
            botoes_mem_in <= "0000";
            wait for 10 * 1000 * clockPeriod;
        end loop loop_estagios;

        sel_hex_in <= '0';

        wait for 2 * 60 * 1000 * clockPeriod;

        wait until falling_edge(clk_in);

        wait for 10 * clockPeriod;

        ---- final do testbench
        report "EOF" severity note;
        keep_simulating <= '0';

        wait;
    end process;
end architecture;
