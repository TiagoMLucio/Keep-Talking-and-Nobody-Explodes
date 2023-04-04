--------------------------------------------------------------------
-- Arquivo   : unidade_controle_gen.vhd
-- Projeto   : Keep Talking and Nobody Explodes (Módulo Gênius)
--------------------------------------------------------------------
-- Descricao : unidade de controle 
--
--             1) codificação VHDL (maquina de Moore)
--
--             2) definicao de valor da saida de depuracao
--                db_estado
-- 
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_gen is
    port (
        clock               : in std_logic;
        reset               : in std_logic;
        iniciar             : in std_logic;
        meioT               : in std_logic;
        fimT                : in std_logic;
        fimL                : in std_logic;
        jogada_feita        : in std_logic;
        enderecoIgualRodada : in std_logic;
        jogada_correta      : in std_logic;
        leds_mem            : out std_logic;
        contaE              : out std_logic;
        contaT              : out std_logic;
        contaCR             : out std_logic;
        registraRN          : out std_logic;
        registraRC          : out std_logic;
        zeraE               : out std_logic;
        zeraT               : out std_logic;
        zeraCR              : out std_logic;
        limpaRC             : out std_logic;
        pronto              : out std_logic;
        errou               : out std_logic;
        db_estado           : out std_logic_vector(3 downto 0)
    );
end entity;

architecture fsm of unidade_controle_gen is
    type t_estado is (inicial, preparacao, espera_led, mostra_led, proximo_led,
        compara_led, espera_led2, inicio_rod, compara_jog, proxima_jog, espera_jog, 
        registra, errou_jog, ultima_rod, proxima_rod, fim_acertou);

    signal Eatual, Eprox : t_estado;
begin

    -- memoria de estado
    process (clock, reset)
    begin
        if reset = '1' then
            Eatual <= inicial;
        elsif clock'event and clock = '1' then
            Eatual <= Eprox;
        end if;
    end process;

    -- logica de proximo estado
    Eprox <=
        inicial when (reset = '1') or
        (Eatual = inicial and iniciar = '0') else

        preparacao when Eatual = inicial and iniciar = '1' else

        espera_led when (Eatual = preparacao) or
        (Eatual = compara_led and enderecoIgualRodada = '1') or
        (Eatual = errou_jog) or
        (Eatual = proxima_rod) else

        mostra_led when (Eatual = espera_led and fimT = '1') or
        (Eatual = proximo_led) else

        espera_led2 when (Eatual = compara_led and enderecoIgualRodada = '0') else

        proximo_led when (Eatual = espera_led2 and meioT = '1') else

        compara_led when (Eatual = mostra_led and meioT = '1') else

        inicio_rod when (Eatual = espera_led or Eatual = mostra_led or
        Eatual = proximo_led or Eatual = compara_led) and jogada_feita = '1' else

        compara_jog when (Eatual = inicio_rod) or
        (Eatual = registra) else

        proxima_jog when (Eatual = compara_jog and jogada_correta = '1' and
        enderecoIgualRodada = '0') else

        espera_jog when (Eatual = proxima_jog) else

        registra when (Eatual = espera_jog and jogada_feita = '1') else

        errou_jog when (Eatual = compara_jog and jogada_correta = '0') else

        ultima_rod when (Eatual = compara_jog and jogada_correta = '1' and
        enderecoIgualRodada = '1') else

        proxima_rod when (Eatual = ultima_rod and fimL = '0') else

        fim_acertou when (Eatual = ultima_rod and fimL = '1') else

        Eatual;

    -- logica de saída (maquina de Moore)
    with Eatual select
        zeraCR <= '1' when preparacao,
        '0' when others;

    with Eatual select
        limpaRC <= '1' when inicial,
        '0' when others;

    with Eatual select
        zeraE <= '1' when espera_led | inicio_rod,
        '0' when others;

    with Eatual select
        zeraT <= '1' when proximo_led | compara_led,
        '0' when others;

    with Eatual select
        registraRN <= '1' when preparacao,
        '0' when others;

    with Eatual select
        registraRC <= '1' when inicio_rod | registra,
        '0' when others;

    with Eatual select
        contaT <= '1' when espera_led | mostra_led | espera_led2,
        '0' when others;

    with Eatual select
        contaE <= '1' when proximo_led | proxima_jog,
        '0' when others;

    with Eatual select
        contaCR <= '1' when proxima_rod,
        '0' when others;

    with Eatual select
        leds_mem <= '1' when mostra_led,
        '0' when others;

    with Eatual select
        errou <= '1' when errou_jog,
        '0' when others;

    with Eatual select
        pronto <= '1' when fim_acertou,
        '0' when others;

    -- saida de depuracao (db_estado)
    with Eatual select
        db_estado <= "0000" when inicial, -- 0
        "0001" when preparacao,           -- 1
        "0010" when espera_led,           -- 2
        "0011" when mostra_led,           -- 3
        "0100" when proximo_led,          -- 4
        "0101" when compara_led,          -- 5
        "0110" when inicio_rod,           -- 6
        "0111" when compara_jog,          -- 7
        "1000" when proxima_jog,          -- 8
        "1001" when espera_jog,           -- 9
        "1010" when registra,             -- A
        "1011" when errou_jog,            -- B
        "1100" when ultima_rod,           -- C
        "1101" when proxima_rod,          -- D
        "1110" when fim_acertou,          -- E
        "1111" when others;               -- F 

end architecture fsm;
