library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ktne is
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

end entity;

architecture structural of ktne is

    signal countT, resetT, endT, clearS, registerS, endE, resetE, tem_letra, err_gen, err_mem, s_pronto_gen, s_pronto_mem                            : std_logic;
    signal minutes, seconds_ten, seconds_unit                                                                                                        : integer;
    signal minutes_s, seconds_ten_s, seconds_unit_s, serial1, serial2, errors_s                                                                      : std_logic_vector(3 downto 0);
    signal errors                                                                                                                                    : std_logic_vector(1 downto 0);
    signal display_mem, num1_mem, num2_mem, num3_mem, num4_mem, serial1_hex, serial2_hex, errors_hex, seconds_unit_hex, seconds_ten_hex, minutes_hex : std_logic_vector(6 downto 0);

    component fluxo_dados
        port (
            clock        : in std_logic;
            countT       : in std_logic;
            resetT       : in std_logic;
            clearS       : in std_logic;
            registerS    : in std_logic;
            resetE       : in std_logic;
            err_gen      : in std_logic;
            err_mem      : in std_logic;
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
            clock      : in std_logic;
            reset      : in std_logic;
            start      : in std_logic;
            pronto_gen : in std_logic;
            pronto_mem : in std_logic;
            endT       : in std_logic;
            endE       : in std_logic;
            countT     : out std_logic;
            resetT     : out std_logic;
            clearS     : out std_logic;
            registerS  : out std_logic;
            resetE     : out std_logic;
            defused    : out std_logic;
            exploded   : out std_logic;
            db_estado  : out std_logic_vector(3 downto 0)
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
            tem_letra   : in std_logic;
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

    component modulo_memoria is
        port (
            clock     : in std_logic;
            reset     : in std_logic;
            iniciar   : in std_logic;
            botoes    : in std_logic_vector (3 downto 0);
            pronto    : out std_logic;
            err       : out std_logic;
            estagio   : out std_logic_vector (4 downto 0);
            display   : out std_logic_vector (6 downto 0);
            num1      : out std_logic_vector (6 downto 0);
            num2      : out std_logic_vector (6 downto 0);
            num3      : out std_logic_vector (6 downto 0);
            num4      : out std_logic_vector (6 downto 0);
            db_estado : out std_logic_vector (6 downto 0)
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
        err_gen      => err_gen,
        err_mem      => err_mem,
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
        clock      => clock,
        reset      => reset,
        start      => start,
        pronto_gen => s_pronto_gen,
        pronto_mem => s_pronto_mem,
        endT       => endT,
        endE       => endE,
        countT     => countT,
        resetT     => resetT,
        clearS     => clearS,
        registerS  => registerS,
        resetE     => resetE,
        defused    => defused,
        exploded   => exploded,
        db_estado  => db_estado
    );

    genius : modulo_genius
    port map(
        clock       => clock,
        reset       => reset,
        iniciar     => start,
        botoes      => botoes_gen,
        tem_letra   => tem_letra,
        erros       => errors,
        pronto      => pronto_gen,
        errou       => err_gen,
        leds        => leds_gen,
        db_clock    => open,
        db_igual    => open,
        db_contagem => open,
        db_memoria  => open,
        db_jogada   => open,
        db_rodada   => open,
        db_estado   => open
    );

    memoria : modulo_memoria
    port map(
        clock     => clock,
        reset     => reset,
        iniciar   => start,
        botoes    => botoes_mem,
        pronto    => pronto_mem,
        err       => err_mem,
        estagio   => estagio_mem,
        display   => display_mem,
        num1      => num1_mem,
        num2      => num2_mem,
        num3      => num3_mem,
        num4      => num4_mem,
        db_estado => open
    );

    minutes_s      <= std_logic_vector(to_unsigned(minutes, 4));
    seconds_unit_s <= std_logic_vector(to_unsigned(seconds_unit, 4));
    seconds_ten_s  <= std_logic_vector(to_unsigned(seconds_ten, 4));

    hex_5 : hexa7seg
    port map(
        hexa => minutes_s,
        sseg => minutes_hex
    );

    hex_4 : hexa7seg
    port map(
        hexa => seconds_unit_s,
        sseg => seconds_unit_hex
    );

    hex_3 : hexa7seg
    port map(
        hexa => seconds_ten_s,
        sseg => seconds_ten_hex
    );

    errors_s <= "00" & errors;

    hex_2 : hexa7seg
    port map(
        hexa => errors_s,
        sseg => errors_hex
    );

    hex_1 : hexa7seg
    port map(
        hexa => serial1,
        sseg => serial1_hex
    );

    hex_0 : hexa7seg
    port map(
        hexa => serial2,
        sseg => serial2_hex
    );

    tem_letra <= '1' when (to_integer(unsigned(serial1)) > 9 or to_integer(unsigned(serial2)) > 9);
    db_clock  <= clock;

    pronto_gen <= s_pronto_gen;
    pronto_mem <= s_pronto_mem;

    hex0 <= serial2_hex when sel_hex = '0' else
        num4_mem;

    hex1 <= serial1_hex when sel_hex = '0' else
        num3_mem;

    hex2 <= errors_s when sel_hex = '0' else
        num2_mem;

    hex3 <= seconds_unit_hex when sel_hex = '0' else
        num1_mem;

    hex4 <= seconds_ten_hex when sel_hex = '0' else
        "1000000";

    hex5 <= minutes_hex when sel_hex = '0' else
        display_mem;

end architecture structural;
