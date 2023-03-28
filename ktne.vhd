library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ktne is
    port (
        clock            : in std_logic;
        reset            : in std_logic;
        start            : in std_logic;
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
end entity;

architecture structural of ktne is

    signal countT, resetT, endT, clearS, registerS, endE, resetE                : std_logic;
    signal minutes, seconds_ten, seconds_unit                                   : integer;
    signal minutes_s, seconds_ten_s, seconds_unit_s, serial1, serial2, errors_s : std_logic_vector(3 downto 0);
    signal errors                                                               : std_logic_vector(1 downto 0);

    component fluxo_dados
        port (
            clock        : in std_logic;
            countT       : in std_logic;
            resetT       : in std_logic;
            clearS       : in std_logic;
            registerS    : in std_logic;
            resetE       : in std_logic;
            db_err       : in std_logic;
            endT         : out std_logic;
            minutes      : out integer;
            seconds_ten  : out integer;
            seconds_unit : out integer;
            endE         : out std_logic;
            errors       : out std_logic_vector(1 downto 0);
            serial1      : out std_logic_vector(3 downto 0);
            serial2      : out std_logic_vector(3 downto 0)
        );
    end component;

    component unidade_controle is
        port (
            clock     : in std_logic;
            reset     : in std_logic;
            start     : in std_logic;
            endT      : in std_logic;
            endE      : in std_logic;
            countT    : out std_logic;
            resetT    : out std_logic;
            clearS    : out std_logic;
            registerS : out std_logic;
            resetE    : out std_logic;
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

    component modulo_genius is
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

begin

    fd : fluxo_dados
    port map(
        clock        => clock,
        countT       => countT,
        resetT       => resetT,
        clearS       => clearS,
        registerS    => registerS,
        resetE       => resetE,
        db_err       => db_err,
        endT         => endT,
        minutes      => minutes,
        seconds_ten  => seconds_ten,
        seconds_unit => seconds_unit,
        endE         => endE,
        errors       => errors,
        serial1      => serial1,
        serial2      => serial2
    );

    uc : unidade_controle
    port map(
        clock     => clock,
        reset     => reset,
        start     => start,
        endT      => endT,
        endE      => endE,
        countT    => countT,
        resetT    => resetT,
        clearS    => clearS,
        registerS => registerS,
        resetE    => resetE,
        exploded  => exploded,
        db_estado => db_estado
    );

    genius : modulo_genius
    port map(
        clock       => clock,
        reset       => reset,
        iniciar     => start,
        botoes      => botoes,
        tem_vogal   => tem_vogal,
        erros       => errors,
        pronto      => pronto_genius,
        errou       => err,
        leds        => leds_genius,
        db_clock    => open,
        db_igual    => open,
        db_contagem => open,
        db_memoria  => open,
        db_jogada   => open,
        db_rodada   => open,
        db_estado   => open
    )

    minutes_s      <= std_logic_vector(to_unsigned(minutes, 4));
    seconds_unit_s <= std_logic_vector(to_unsigned(seconds_unit, 4));
    seconds_ten_s  <= std_logic_vector(to_unsigned(seconds_ten, 4));

    hex5 : hexa7seg
    port map(
        hexa => minutes_s,
        sseg => minutes_hex
    );

    hex4 : hexa7seg
    port map(
        hexa => seconds_unit_s,
        sseg => seconds_unit_hex
    );

    hex3 : hexa7seg
    port map(
        hexa => seconds_ten_s,
        sseg => seconds_ten_hex
    );

    errors_s <= "00" & errors;

    hex2 : hexa7seg
    port map(
        hexa => errors_s,
        sseg => errors_hex
    );

    hex1 : hexa7seg
    port map(
        hexa => serial1,
        sseg => serial1_hex
    );

    hex0 : hexa7seg
    port map(
        hexa => serial2,
        sseg => serial2_hex
    );

    db_clock <= clock;

end architecture structural;
