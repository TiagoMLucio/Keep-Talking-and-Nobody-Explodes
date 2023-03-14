library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is
    port (
        clock     : in std_logic;
        reset     : in std_logic;
        start     : in std_logic;
        endT      : in std_logic;
        countT    : out std_logic;
        resetT    : out std_logic;
        clearS    : out std_logic;
        registraS : out std_logic;
        exploded  : out std_logic;
        db_estado : out std_logic_vector(3 downto 0)
    );
end entity;

architecture fsm of unidade_controle is
    type t_estado is (initial, preparation, game, lost);
    signal Eatual, Eprox : t_estado;
begin

    -- memoria de estado
    process (clock, reset)
    begin
        if reset = '1' then
            Eatual <= initial;
        elsif clock'event and clock = '1' then
            Eatual <= Eprox;
        end if;
    end process;

    -- logica de proximo estado
    Eprox <=
        initial when reset = '1' else
        initial when Eatual = initial and start = '0' else
        preparation when Eatual = initial and start = '1' else
        game when Eatual = preparation else
        lost when Eatual = game and endT = '1' else
        initial when Eatual = lost and start = '1' else
        Eatual;

    -- logica de saída (maquina de Moore)
    with Eatual select
        countT <= '1' when game,
        '0' when others;

    with Eatual select
        resetT <= '1' when preparation,
        '0' when others;

    with Eatual select
        clearS <= '1' when initial,
        '0' when others;

    with Eatual select
        registraS <= '1' when preparation,
        '0' when others;

    with Eatual select
        exploded <= '1' when lost,
        '0' when others;

    -- saida de depuracao (db_estado)
    with Eatual select
        db_estado <= "0000" when initial, -- 0
        "0001" when preparation,          -- 1
        "0010" when game,                 -- 2
        "1110" when lost,                 -- E
        "1111" when others;               -- F

end architecture fsm;
