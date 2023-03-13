library ieee;
use ieee.std_logic_1164.all;

entity ktne is
    port (
        clock            : in std_logic;
        reset            : in std_logic;
        start            : in std_logic;
        minutes_hex      : out std_logic_vector(6 downto 0);
        seconds_unit_hex : out std_logic_vector(6 downto 0);
        seconds_ten_hex  : out std_logic_vector(6 downto 0);
        -- numero_serie1   : out std_logic_vector(6 downto 0);
        -- numero_serie2   : out std_logic_vector(6 downto 0);
        -- vidas           : out std_logic_vector(6 downto 0);
        exploded  : out std_logic;
        db_clock  : out std_logic;
        db_estado : out std_logic_vector(3 downto 0)
    );
end entity;

architecture structural of ktne is

    signal countT, resetT, endT : std_logic;

    component fluxo_dados
        port (
            clock        : in std_logic;
            countT       : in std_logic;
            resetT       : in std_logic;
            endT         : out std_logic;
            minutes      : out integer;
            seconds_ten  : out integer;
            seconds_unit : out integer
        );
    end component;

    component unidade_controle is
        port (
            clock     : in std_logic;
            reset     : in std_logic;
            start     : in std_logic;
            endT      : in std_logic;
            countT    : out std_logic;
            resetT    : out std_logic;
            exploded  : out std_logic;
            db_estado : out std_logic_vector(3 downto 0)
        );
    end component;

    component hexa7seg is
        port (
            hexa : in std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;

begin

    fd : fluxo_dados
    port map(
        clock  => clock,
        countT => countT,
        resetT => resetT,
        endT   => endT
    );

    uc : unidade_controle
    port map(
        clock     => clock,
        reset     => reset,
        start     => start,
        countT    => countT,
        resetT    => resetT,
        endT      => endT,
        exploded  => exploded,
        db_estado => db_estado
    );

    hex5 : hexa7seg
    port map(
        hexa => std_logic_vector(to_unsigned(minutes, 7)),
        sseg => minutes_hex
    );

    hex4 : hexa7seg
    port map(
        hexa => std_logic_vector(to_unsigned(seconds_unit, 7)),
        sseg => seconds_unit_hex
    );

    hex3 : hexa7seg
    port map(
        hexa => std_logic_vector(to_unsigned(seconds_ten, 7)),
        sseg => seconds_ten_hex
    );

    db_clock <= clock;

end architecture structural;
