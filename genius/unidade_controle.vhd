--------------------------------------------------------------------
-- Arquivo   : unidade_controle.vhd
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY unidade_controle IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        iniciar : IN STD_LOGIC;
        meioT : IN STD_LOGIC;
        fimT : IN STD_LOGIC;
        fimL : IN STD_LOGIC;
        jogada_feita : IN STD_LOGIC;
        enderecoIgualRodada : IN STD_LOGIC;
        jogada_correta : IN STD_LOGIC;
        leds_mem : OUT STD_LOGIC;
        contaE : OUT STD_LOGIC;
        contaT : OUT STD_LOGIC;
        contaCR : OUT STD_LOGIC;
        registraRC : OUT STD_LOGIC;
        zeraE : OUT STD_LOGIC;
        zeraT : OUT STD_LOGIC;
        zeraCR : OUT STD_LOGIC;
        limpaRC : OUT STD_LOGIC;
        pronto : OUT STD_LOGIC;
        errou : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE fsm OF unidade_controle IS
    TYPE t_estado IS (inicial, preparacao, espera_led, mostra_led, proximo_led,
        compara_led, inicio_rod, compara_jog, proxima_jog, espera_jog, registra,
        errou_jog, ultima_rod, proxima_rod, fim_acertou);

    SIGNAL Eatual, Eprox : t_estado;
BEGIN

    -- memoria de estado
    PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            Eatual <= inicial;
        ELSIF clock'event AND clock = '1' THEN
            Eatual <= Eprox;
        END IF;
    END PROCESS;

    -- logica de proximo estado
    Eprox <=
        inicial WHEN (reset = '1') OR
        (Eatual = inicial AND iniciar = '0') ELSE

        preparacao WHEN Eatual = inicial AND iniciar = '1' ELSE

        espera_led WHEN (Eatual = preparacao) OR
        (Eatual = compara_led AND enderecoIgualRodada = '1') OR
        (Eatual = errou_jog) OR
        (Eatual = proxima_rod) ELSE

        mostra_led WHEN (Eatual = espera_led AND fimT = '1') OR
        (Eatual = compara_led AND enderecoIgualRodada = '0') ELSE

        proximo_led WHEN (Eatual = mostra_led AND meioT = '1') ELSE

        compara_led WHEN (Eatual = proximo_led) ELSE

        inicio_rod WHEN (Eatual = espera_led OR Eatual = mostra_led OR
        Eatual = proximo_led OR Eatual = compara_led) AND jogada_feita = '1' ELSE

        compara_jog WHEN (Eatual = inicio_rod) OR
        (Eatual = registra) ELSE

        proxima_jog WHEN (Eatual = compara_jog AND jogada_correta = '1' AND
        enderecoIgualRodada = '0') ELSE

        espera_jog WHEN (Eatual = proxima_jog) ELSE

        registra WHEN (Eatual = espera_jog AND jogada_feita = '1') ELSE

        errou_jog WHEN (Eatual = compara_jog AND jogada_correta = '0') ELSE

        ultima_rod WHEN (Eatual = compara_jog AND jogada_correta = '1' AND
        enderecoIgualRodada = '1') ELSE

        proxima_rod WHEN (Eatual = ultima_rod AND fimL = '0') ELSE

        fim_acertou WHEN (Eatual = ultima_rod AND fimL = '1') ELSE

        Eatual;

    -- logica de saída (maquina de Moore)
    WITH Eatual SELECT
        zeraCR <= '1' WHEN preparacao,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        limpaRC <= '1' WHEN inicial,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        zeraE <= '1' WHEN espera_led | inicio_rod,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        zeraT <= '1' WHEN proximo_led,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        registraRC <= '1' WHEN inicio_rod | registra,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        contaT <= '1' WHEN espera_led | mostra_led,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        contaE <= '1' WHEN proximo_led | proxima_jog,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        contaCR <= '1' WHEN proxima_rod,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        leds_mem <= '1' WHEN mostra_led,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        errou <= '1' WHEN errou_jog,
        '0' WHEN OTHERS;

    -- saida de depuracao (db_estado)
    WITH Eatual SELECT
        db_estado <= "0000" WHEN inicial, -- 0
        "0001" WHEN preparacao, -- 1
        "0010" WHEN espera_led, -- 2
        "0011" WHEN mostra_led, -- 3
        "0100" WHEN proximo_led, -- 4
        "0101" WHEN compara_led, -- 5
        "0110" WHEN inicio_rod, -- 6
        "0111" WHEN compara_jog, -- 7
        "1000" WHEN proxima_jog, -- 8
        "1001" WHEN espera_jog, -- 9
        "1010" WHEN registra, -- A
        "1011" WHEN errou_jog, -- B
        "1100" WHEN ultima_rod, -- C
        "1101" WHEN proxima_rod, -- D
        "1110" WHEN fim_acertou, -- E
        "1111" WHEN OTHERS; -- F 

END ARCHITECTURE fsm;