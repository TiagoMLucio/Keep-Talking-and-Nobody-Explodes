--------------------------------------------------------------------
-- Arquivo   : unidade_controle_mem.vhd
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

entity unidade_controle_mem is
    port (
        clock          : in std_logic;
        reset          : in std_logic;
        iniciar        : in std_logic;
        fimE           : in std_logic;
        jogada_feita   : in std_logic;
        jogada_correta : in std_logic;
        exploded       : in std_logic;
        zeraE          : out std_logic;
        contaE         : out std_logic;
        limpaJ         : out std_logic;
        registraN      : out std_logic;
        registraJ      : out std_logic;
        escreve        : out std_logic;
        sel_addr       : out std_logic;
        err            : out std_logic;
        pronto         : out std_logic;
        db_estado      : out std_logic_vector(3 downto 0)
    );
end entity;

architecture fsm of unidade_controle_mem is
    type t_estado is (inicial, preparacao, inicio_est, espera, registra, salva, compara, ultimo, proximo, errou, fim_acertou);

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
        inicial when (reset = '1' or exploded = '1') or
        (Eatual = inicial and iniciar = '0') else

        preparacao when Eatual = inicial and iniciar = '1' else

        inicio_est when (Eatual = preparacao) or
        (Eatual = errou) or
        (Eatual = proximo) else

        espera when Eatual = inicio_est else

        registra when (Eatual = espera and jogada_feita = '1') else

        salva when (Eatual = registra) else

        compara when (Eatual = salva) else

        proximo when (Eatual = ultimo and fimE = '0') else

        ultimo when (Eatual = compara and jogada_correta = '1') else

        errou when (Eatual = compara and jogada_correta = '0') else

        fim_acertou when (Eatual = ultimo and fimE = '1') else

        Eatual;

    -- logica de saída (maquina de Moore)
    with Eatual select
        limpaJ <= '1' when inicial,
        '0' when others;

    with Eatual select
        zeraE <= '1' when preparacao | errou,
        '0' when others;

    with Eatual select
        registraN <= '1' when inicio_est,
        '0' when others;

    with Eatual select
        registraJ <= '1' when registra,
        '0' when others;

    with Eatual select
        escreve <= '1' when salva,
        '0' when others;

    with Eatual select
        sel_addr <= '1' when salva,
        '0' when others;

    with Eatual select
        contaE <= '1' when proximo,
        '0' when others;

    with Eatual select
        err <= '1' when errou,
        '0' when others;

    with Eatual select
        pronto <= '1' when fim_acertou,
        '0' when others;

    -- saida de depuracao (db_estado)
    with Eatual select
        db_estado <= "0000" when inicial, -- 0
        "0001" when preparacao,           -- 1
        "0010" when inicio_est,           -- 2
        "0011" when espera,               -- 3
        "0100" when registra,             -- 4
        "0101" when salva,                -- 5
        "0110" when compara,              -- 6
        "0111" when ultimo,               -- 7
        "1000" when proximo,              -- 8
        "1101" when errou,                -- D
        "1110" when fim_acertou,          -- E
        "1111" when others;               -- F 

end architecture fsm;
